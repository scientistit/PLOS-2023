function FeaturesBasedOnShapeChooseCertainStartingPointPresCorrShapes(ImageMask)
     

    % This code is a part of code for tables 3-5 in results of article
    % This code was extracted to prove the vitality of the idea of
    % correlations between vectors of distances and angles in objects
    
    % We pick the image that is to be compared with bacteria liked object
    % The selection is hardcoded (you need to pick for example RotRound or 
    % RotRound45 or RotRound90)
    
    ImageMask = imread('./RotatedShapes/RotOval135.png');
%     ImageMask = imread('./RotatedShapes/RotBac45.png');
%     or
%     ImageMask = imread('./RotatedShapes/RotBac90.png');
%     or
%     ImageMask = imread('./RotatedShapes/RotBac135.png');
%     or sth else
    
    % P = 20 means we pick 20 points on object's boundary
    
    P = 20;
    
    % there is one object on the image
    howManyBacteriasAreSelected = 1;

    iml = bwlabel(ImageMask,4);
    
    %Image 0: Each object labelled
    %vislabels(iml),title('Each object labelled');

    g = regionprops(iml,'Area','BoundingBox');
    area_values = [g.Area];
    
    
    half = floor(size(area_values,2)/2);
    sortedArea_values = sort(area_values);

    %Choose 5 values that are closest to the median of the area
    % *We choose only one for tables (1 and 2
    if howManyBacteriasAreSelected == 1
    indexes = 1;   
    else
    chosenBacterias = sortedArea_values(half-howManyBacteriasAreSelected/2:half+howManyBacteriasAreSelected/2);
    idx = find(area_values >= chosenBacterias(1) & area_values <= chosenBacterias(howManyBacteriasAreSelected));
        
    areaAndIndex = [1:size(area_values,2);area_values]';
    areaAndIndexSorted = sortrows(areaAndIndex,2);
    halfOfObjects = floor(size(area_values,2)/2);
    indexes = areaAndIndexSorted(halfOfObjects-howManyBacteriasAreSelected/2:(halfOfObjects+howManyBacteriasAreSelected/2)-1,:);
    end
    
    

    %Attention - ensure we chose as many bacterias as it was required
    if indexes < howManyBacteriasAreSelected
        indexes
    end


    %% Arbitrally Selected vectors to compare
    [distancesBetweenPointAndMidArbSelectedPi,distancesBetweenPointsArbSelectedPi,anglesTwoArrayExtrArbSelectedPi, anglesArrayExtrArbSelectedPi] =  ExemplaryRotBac(P,"FakeBacteriaCertainOrder");

    %% Code
    
% To see images inside parfor loops change parfor into par and uncomment
% chosen code

%Add par! 
 for i = 1:howManyBacteriasAreSelected
    
    h = ismember(iml,indexes(i));

    % Calculate mask
      I2 = filterImages(h,'laplacian');
%     I2 = imread('/Users/aleksandra/Documents/PracaMagisterska/MaskiIObrazy/SP_otsu/S00001.png');

    % Check what x and y values are not equal 0
     [x,y,~] = find(I2);
     
     %Image 1: Image with one bacteria and points
%      imshow(I2) 
%      hold on; 
%      plot(y,x,'o'); 
     
    % Put points in clockwise order
     angle = atan2(x-mean(x),y-mean(y));
     data = table(x,y,angle);
     data = sortrows(data,'angle');
    
    %Take certain amount of points so that their amount is always the same
    %for example 20.
     N = size(data,1);
%      P = 20;
    data =  table2array(data);
    %Find starting position
     mindistance = sqrt((data(1,1)- mean(x))^2 + (data(1,2)- mean(y))^2);
     startingpointindex = 1; 
     for ind = 2:size(data,1)
         currentdistance = sqrt((data(ind,1)- mean(x))^2 + (data(ind,2)- mean(y))^2);
         if currentdistance < mindistance
             mindistance = currentdistance;
             startingpointindex = ind;
         end
     end
     
     begin(:,:) = data(startingpointindex:end,:);
     ende(:,:) = data(1:startingpointindex-1,:);
     data = [begin; ende];

     %If we have less points than P then we duplicate first point enough
     %amount of times so we have the same amount of points for calculating
     %correlation
     while(N<P)
         data = [data;data(1,:)];
         N = size(data,1);
     end
     r = diff(fix(linspace(0, N, P+1)));
     
     index = 0;
     newdata = zeros(size(r,2),3);
     for a = 1:size(r,2)
         index = index + r(a);
         newdata(a,:) = data(index,:);
     end
     
     data = newdata;
     data = [data;data(1,:)];
     
      
      [~,~,~,distancesBetweenPointAndMid(i,:),distancesBetweenPoints(i,:),anglesTwoArrayExtr(i,:),anglesArrayExtr(i,:)] = CurvatureCalculationsNoCurvV(data(:,1),data(:,2),ImageMask);%CurvatureCalculationsNoCurvForImage(data(:,1),data(:,2),ImageMask);
     
    
      % Calculate correlations between arbitrally selected vector and
      % vector of distances
      
      %1 corrcoef - calculates Pearson coefficient
      z1Pitmp = corrcoef(distancesBetweenPointAndMidArbSelectedPi,distancesBetweenPointAndMid(i,:));
      z1Pi = abs(z1Pitmp(1,2))
      
      z2Pitmp = corrcoef(distancesBetweenPointsArbSelectedPi, distancesBetweenPoints(i,:));
      z2Pi = abs(z2Pitmp(1,2))
      
      z3Pitmp = corrcoef(anglesTwoArrayExtrArbSelectedPi, anglesTwoArrayExtr(i,:));
      z3Pi = abs(z3Pitmp(1,2))
      
      z4Pitmp = corrcoef(anglesArrayExtrArbSelectedPi, anglesArrayExtr(i,:));
      z4Pi = abs(z4Pitmp(1,2))
    
      
%       [z1Pi] = RollingCorrelationNorm(distancesBetweenPointAndMidArbSelectedPi, distancesBetweenPointAndMid(i,:));
% %       Image: Correlations
% %        figure
% %        stem(przes,z1)
%       [z2Pi] = RollingCorrelationNorm(distancesBetweenPointsArbSelectedPi, distancesBetweenPoints(i,:));
% %       Image: Correlations
% %        figure
% %        stem(przes,z2) 
%       [z3Pi] = RollingCorrelationNorm(anglesTwoArrayExtrArbSelectedPi, anglesTwoArrayExtr(i,:));
% %       Image: Correlations
% %        figure
% %        stem(przes,z3) 
%       [z4Pi] = RollingCorrelationNorm(anglesArrayExtrArbSelectedPi, anglesArrayExtr(i,:));
% %       Image: Correlations
% %        figure
% %        stem(przes,z4)
           

 end
 
 

 end