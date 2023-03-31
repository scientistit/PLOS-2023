function [meanBacteriaarcLenght,meanBacteriaWholeCurvature,meanBacteriaCurvature,maxCorrelationPointAndMidPi,maxCorrelationBetweenPointsPi,maxCorrelationanglespointpointmiddlePi, maxCorrelationanglespointmiddlepointPi] = FeaturesBasedOnShapeChooseCertainStartingPointForCalculationsV(ImageMask,P,howManyBacteriasAreSelected)
     
      %Arbitrally selected bacteria is 1 out of 5 bacterias in S00001
%         ImageMask = imread('/Users/aleksandra/Documents/PracaMagisterska/MaskiIObrazy/SP_otsu/S00001.png');
%        %ImageMask = imread('/Users/aleksandra/Documents/PracaMagisterska/KodyDoPracyMagisterskiej/FrogForPickingPoints135.png');
%         P = 10;%9,10,20
%         howManyBacteriasAreSelected = 5;%5,10
%         ImageMask = imread('/Users/aleksandra/Documents/PracaMagisterska/MaskiIObrazy/SP_otsu/S00001.png');
%         P = 20;%9,10,20
%         howManyBacteriasAreSelected = 10;%5,10
%         

    iml = bwlabel(ImageMask,4);
    
    %Image 0: Each object labelled
    %vislabels(iml),title('Each object labelled');

    g = regionprops(iml,'Area','BoundingBox');
    area_values = [g.Area];
    
    
    half = floor(size(area_values,2)/2);
    sortedArea_values = sort(area_values);

    %Choose 5 values that are closest to the median of the area
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
    
    meanBacteriaCurvature = 0;
    meanBacteriaWholeCurvature = 0;
    meanBacteriaarcLenght = 0; 
    
    maxCorrelationPointAndMidPi = 0;
    maxCorrelationBetweenPointsPi = 0;
    maxCorrelationanglespointpointmiddlePi = 0;
    maxCorrelationanglespointmiddlepointPi = 0;
    
    %Attention - ensure we chose as many bacterias as it was required
    if indexes < howManyBacteriasAreSelected
        indexes
    end

    %% Arbitrally Selected vectors to compare
    [distancesBetweenPointAndMidArbSelectedPi,distancesBetweenPointsArbSelectedPi,anglesTwoArrayExtrArbSelectedPi, anglesArrayExtrArbSelectedPi] =  ExemplaryBacteriaVectorsCertainOrderNoCurv(P,"No");
   
    %% Code
    
% To see images inside parfor loops change parfor into par and uncomment
% chosen code

%Add par! 
 parfor i = 1:howManyBacteriasAreSelected
    
    h = ismember(iml,indexes(i));

    % Calculate mask
      I2 = filterImages(h,'laplacian'); %izotropowefiltry2(h,'laplacian');
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
    data =  table2array(data)
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
     begin = [];
     ende = [];
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
     
      
      [arcLength,wholeCurvature,curvatore,distancesBetweenPointAndMid(i,:),distancesBetweenPoints(i,:),anglesTwoArrayExtr(i,:),anglesArrayExtr(i,:)] = CurvatureCalculationsNoCurvV(data(:,1),data(:,2),ImageMask); %CurvatureCalculationsNoCurv(data(:,1),data(:,2),ImageMask);
%       [krzywiznaSrednia,distancesBetweenPointAndMid,distancesBetweenPoints,anglesTwoArrayExtr,anglesArrayExtr]
      
    
      % Calculate correlations between arbitrally selected vector and
      % vector of distances
      
      %Option 1 - Pearson 
      
%       z1Pitmp = corrcoef(distancesBetweenPointAndMidArbSelectedPi,distancesBetweenPointAndMid(i,:));
%       z1Pi = abs(z1Pitmp(1,2));
%       
%       z2Pitmp = corrcoef(distancesBetweenPointsArbSelectedPi, distancesBetweenPoints(i,:));
%       z2Pi = abs(z2Pitmp(1,2));
%       
%       z3Pitmp = corrcoef(anglesTwoArrayExtrArbSelectedPi, anglesTwoArrayExtr(i,:));
%       z3Pi = abs(z3Pitmp(1,2));
%       
%       z4Pitmp = corrcoef(anglesArrayExtrArbSelectedPi, anglesArrayExtr(i,:));
%       z4Pi = abs(z4Pitmp(1,2));
%       
      
      %Option 2 - Rolling Pearson
%       z1Pi = RollingPearson(distancesBetweenPointAndMidArbSelectedPi,distancesBetweenPointAndMid(i,:));
%       %z1Pi = abs(z1Pitmp(1,2));
%       
%       z2Pi = RollingPearson(distancesBetweenPointsArbSelectedPi, distancesBetweenPoints(i,:));
%       %z2Pi = abs(z2Pitmp(1,2));
%       
%       z3Pi = RollingPearson(anglesTwoArrayExtrArbSelectedPi, anglesTwoArrayExtr(i,:));
%       %z3Pi = abs(z3Pitmp(1,2));
%       
%       z4Pi = RollingPearson(anglesArrayExtrArbSelectedPi, anglesArrayExtr(i,:));
%       %z4Pi = abs(z4Pitmp(1,2));

        
      %Option 3 - Rolling Cor norm - replace max with min
      
      %1
      [z1Pi] = RollingCorrelationNorm(distancesBetweenPointAndMidArbSelectedPi, distancesBetweenPointAndMid(i,:));
%       Image: Correlations
%        figure
%        stem(przes,z1)
      [z2Pi] = RollingCorrelationNorm(distancesBetweenPointsArbSelectedPi, distancesBetweenPoints(i,:));
%       Image: Correlations
%        figure
%        stem(przes,z2) 
      [z3Pi] = RollingCorrelationNorm(anglesTwoArrayExtrArbSelectedPi, anglesTwoArrayExtr(i,:));
%       Image: Correlations
%        figure
%        stem(przes,z3) 
      [z4Pi] = RollingCorrelationNorm(anglesArrayExtrArbSelectedPi, anglesArrayExtr(i,:));
%       Image: Correlations
%        figure
%        stem(przes,z4)

      
      %now we choose maximal values from correlation vector
      %we sum them and calculate their mean value
      
      %1
      maxCorrelationPointAndMidPi = maxCorrelationPointAndMidPi + min(z1Pi);
      maxCorrelationBetweenPointsPi = maxCorrelationBetweenPointsPi + min(z2Pi);
      maxCorrelationanglespointpointmiddlePi = maxCorrelationanglespointpointmiddlePi + min(z3Pi);
      maxCorrelationanglespointmiddlepointPi = maxCorrelationanglespointmiddlepointPi + min(z4Pi);
      
      %Sum up all curvatures
      meanBacteriaCurvature = meanBacteriaCurvature + curvatore;
      meanBacteriaWholeCurvature = meanBacteriaWholeCurvature + wholeCurvature;
      
      %Sum up all lengths
      meanBacteriaarcLenght = meanBacteriaarcLenght + arcLength;
 end
 
 
 %Image 3: Here i imshow chosen bacterias on image to compare how good the
 %interpolation of the shape is. See which 5 bacterias are selected in
 %current image
 
%    figure;
%    imshow(ImageMask)
%    hold on;
%  for i = 1:howManyBacteriasAreSelected
%     h = ismember(iml,indexes(i));
%     h = h';
%     %Bakterie na obrazku
%     I2 = izotropowefiltry2(h,'laplacian');
%     [x,y,~] = find(I2);
%     angle = atan2(x-mean(x),y-mean(y));
%     data = table(x,y,angle);
%     data = sortrows(data,'angle');
% 
%     %Tutaj wezmiemy tyle punktów, ¿eby by³o ich zawsze tyle samo np. 20
%     N = size(data,1);
%     %      P = 20;
% 
%     %Je¶li mamy mniej niz P punktów to powielamy pierwszy punkt zeby miec
%     %zawsze tyle samo punktów potem do liczenia korelacji
%     while(N<P)
%      data = [data;data(1,:)];
%      N = size(data,1);
%     end
%     r = diff(fix(linspace(0, N, P+1)));
% 
%     index = 0;
%     newdata = zeros(size(r,2),3);
%     for a = 1:size(r,2)
%      index = index + r(a);
%      newdata(a,:) = table2array(data(index,:));
%     end
% 
%     data = newdata;
% 
% 
%     data = [data;data(1,:)];
%     n = 1:size(data,1);
%     s = csape(n,[data(:,1)';data(:,2)'], 'not-a-knot');
%     fnplt(s, 'r');
% 
%     %       hold on;
%     %       
%     %       data = [data;data(1,:)];
%     %       n = 1:height(data);
%     %       g = csape(n,[data.y';data.x'], 'not-a-knot');
%     %       fnplt(g, 'g');
% 
%     hold on;
%     drawnow;
%  end

 meanBacteriaCurvature = meanBacteriaCurvature/howManyBacteriasAreSelected;
 meanBacteriaWholeCurvature = meanBacteriaWholeCurvature/howManyBacteriasAreSelected;
 meanBacteriaarcLenght = meanBacteriaarcLenght/howManyBacteriasAreSelected;
 
 maxCorrelationBetweenPointsPi = maxCorrelationBetweenPointsPi/howManyBacteriasAreSelected;
 maxCorrelationPointAndMidPi = maxCorrelationPointAndMidPi/howManyBacteriasAreSelected;
 maxCorrelationanglespointpointmiddlePi = maxCorrelationanglespointpointmiddlePi/howManyBacteriasAreSelected;
 maxCorrelationanglespointmiddlepointPi = maxCorrelationanglespointmiddlepointPi/howManyBacteriasAreSelected;
 
 end