function [meanBacteriaarcLenght,meanBacteriaWholeCurvature] = FeaturesBasedOnShapeNoCurvatureLandC(ImageMask,P,howManyBacteriasAreSelected)
    
    % In this code there are three images that will be generated if you
    % uncomment the selected code and remove 'par' from loops
    % images cannot be generated inside asynchronous code
    
    iml = bwlabel(ImageMask,4);

    % Image 0: Each object labelled
    % vislabels(iml),title('Each object labelled');

    g = regionprops(iml,'Area','BoundingBox');
    area_values = [g.Area];
    
    
    half = floor(size(area_values,2)/2);
    sortedArea_values = sort(area_values);
    
    chosenBacterias = sortedArea_values(half-howManyBacteriasAreSelected/2:half+howManyBacteriasAreSelected/2);
    idx = find(area_values >= chosenBacterias(1) & area_values <= chosenBacterias(howManyBacteriasAreSelected));
    
    % Choose e.g. 5 values that are closest to the median of the area 
    areaAndIndex = [1:size(area_values,2);area_values]';
    areaAndIndexSorted = sortrows(areaAndIndex,2);
    halfOfObjects = floor(size(area_values,2)/2);
    indexes = areaAndIndexSorted(halfOfObjects-howManyBacteriasAreSelected/2:(halfOfObjects+howManyBacteriasAreSelected/2)-1,:);

    meanBacteriaWholeCurvature = 0;
    meanBacteriaarcLenght = 0; 
    
    % Attention - ensure we chose as many bacterias as it was required
    if indexes < howManyBacteriasAreSelected
        indexes
    end

    % To see images inside parfor loops change parfor into par and uncomment
    % chosen code

    % Add par! (PAR ID: 01)
     for i = 1:howManyBacteriasAreSelected

        h = ismember(iml,indexes(i));

        % Calculate mask
        I2 = filterImages(h,'laplacian'); %izotropowefiltry2(h,'laplacian');
        % Exemplary bacteria
        % I2 = imread('/Users/aleksandra/Documents/PracaMagisterska/MaskiIObrazy/SP_otsu/S00001.png');

        % Check what x and y values are not equal 0
        [x,y,~] = find(I2);

        % Image 1: Image with one bacteria and points
        % imshow(I2) 
        % hold on; 
        % plot(y,x,'o'); 

        % Put points in clockwise order
        angle = atan2(x-mean(x),y-mean(y));
        data = table(x,y,angle);
        data = sortrows(data,'angle');

        % Take certain amount of points so that their amount is always the same
        % for example 20.
        N = size(data,1);

        % If we have less points than P then we duplicate first point enough
        % amount of times so we have the same amount of points for calculating
        % correlation
         while(N<P)
             data = [data;data(1,:)];
             N = size(data,1);
         end
         r = diff(fix(linspace(0, N, P+1)));

         index = 0;
         newdata = zeros(size(r,2),3);
         for a = 1:size(r,2)
             index = index + r(a);
             newdata(a,:) = table2array(data(index,:));
         end

         data = newdata;
         data = [data;data(1,:)];

         [arcLength,wholeCurvature] = CurvatureCalculationsNoCurvWithCurvAndArcLandC(data(:,1),data(:,2),ImageMask); %CurvatureCalculationsNoCurvWithCurvAndArc(data(:,1),data(:,2),ImageMask);

         meanBacteriaWholeCurvature = meanBacteriaWholeCurvature + wholeCurvature;

         %Sum up all lengths
         meanBacteriaarcLenght = meanBacteriaarcLenght + arcLength;
     end

     % Image 3: Here i imshow chosen bacterias on image to compare how good the
     % interpolation of the shape is. See which x bacterias are selected in current image
     % the code which is commented out uses built in interpolation method

%        figure;
%        imshow(ImageMask)
%        hold on;
%      for i = 1:howManyBacteriasAreSelected
%         h = ismember(iml,indexes(i));
%         h = h';
%         
%         % Bacteria on image
%         I2 = filterImages(h,'laplacian'); % izotropowefiltry2(h,'laplacian');
%         [x,y,~] = find(I2);
%         angle = atan2(x-mean(x),y-mean(y));
%         data = table(x,y,angle);
%         data = sortrows(data,'angle');
%     
%         % Take certain amount of points so that their amount is always the same
%         % for example 20.
%         N = size(data,1);
%     
%         % If we have less points than P then we duplicate first point enough
%         % amount of times so we have the same amount of points for calculating
%         % correlation
%         while(N<P)
%          data = [data;data(1,:)];
%          N = size(data,1);
%         end
%         r = diff(fix(linspace(0, N, P+1)));
%     
%         index = 0;
%         newdata = zeros(size(r,2),3);
%         for a = 1:size(r,2)
%          index = index + r(a);
%          newdata(a,:) = table2array(data(index,:));
%         end
%     
%         data = newdata;
%     
%     
%         data = [data;data(1,:)];
%         n = 1:size(data,1);
%         s = csape(n,[data(:,1)';data(:,2)'], 'not-a-knot');
%         fnplt(s, 'r');
%     
%         %       hold on;
%         %       
%         %       data = [data;data(1,:)];
%         %       n = 1:height(data);
%         %       g = csape(n,[data.y';data.x'], 'not-a-knot');
%         %       fnplt(g, 'g');
%     
%         hold on;
%         drawnow;
%      end

     meanBacteriaWholeCurvature = meanBacteriaWholeCurvature/howManyBacteriasAreSelected;
     meanBacteriaarcLenght = meanBacteriaarcLenght/howManyBacteriasAreSelected;

 end