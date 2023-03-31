    
function FeaturesCalculation(Folder)

    Folder = '../ImagesAndMasks/';

    % Chosing folders with microscopic images
    % Folders where images with masks are placed include "_otsu" at 
    % the end of the folder name
    
    % One can select folder names in ImagesAndMasks folder for which the features
    % will be calculated. Here are all the five available bacteria genera:
    % Pi - Enterobacter
    % E7 - Rhizobium
    % x5 - Pantoea
    % Br - Bradyrhizobium
    % Ps - Pseudomonas
    
    folderNames = ["Pi","E7","x5","Br","Ps"];
    imageNumber = 1;

    % Go through every folder
    for i = 1:size(folderNames,2)

        myFolder = append(Folder,folderNames(i));

        % Check to make sure that folder actually exists. Warn user if it doesn't.
        if ~isfolder(myFolder)
            errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
            uiwait(warndlg(errorMessage));
            % Ask for a new one.
            myFolder = uigetdir(); 
            if myFolder == 0
                 % User clicked Cancel
                 return;
            end
        end

        % Get a list of all files in the folder with the desired file name pattern.
        filePattern = fullfile(myFolder, '*.png'); 
        theFiles = dir(filePattern);


        % Go through every image in the current folder
        for k = 1:length(theFiles)

            % Image number
            number(imageNumber) = imageNumber;

            % Number of the bacteria genera
            classNumber(imageNumber) = i;

            % Name of the bacteria genera
            className(imageNumber) = folderNames(i);

            % Number of the microscopic image (inside current bacteria genera)
            numberInClass(imageNumber) = k;

            % Get current microscopic image
            baseFileName(k,:) = theFiles(k).name;
            fullFileName = fullfile(theFiles(k).folder, baseFileName(k,:));
            imageArray = imread(fullFileName);
            % imshow(imageArray)

            % Get the mask corresponding to the current image (calculated
            % previously)
            maskFolder = append(Folder,folderNames(i),"_otsu");
            fullFileName = fullfile(maskFolder,baseFileName(k,:));
            imageArrayMask = imread(fullFileName);
            % imshow(imageArrayMask)

            % Calculating features

            featureNumber = 1;

            % Features based on geometric (1-10)

            % For curvature calculations
            % 1, 2
            p = 10; % Amount of points for interpolation: 9,10,20
            b = 50; % Amount of analyzed bacteria objects: 5,10
    
            [features(imageNumber,featureNumber), features(imageNumber,featureNumber+1)] = FeaturesBasedOnShapeNoCurvatureLandC(imageArrayMask,p,b); 
            colName(featureNumber) = {append(char(string(featureNumber)),' ','meanBacteriaarcLength')};
            colName(featureNumber + 1) = {append(char(string(featureNumber + 1)),' ','meanBacteriaWholeCurvature')};
            featureNumber = featureNumber + 2;
            
    
            % For vector comparison
            % 3 - (distance from point to middle)
            % 4 - (distance between points)
            % 5 - (angle between: point, point, middle)
            % 6 - (angle between: point, middle, point) 
            % 3, 4, 5, 6
            p = 10; % Amount of points for interpolation: 9,10,20
            b = 10; % Amount of analyzed bacteria objects: 5,10
            [~, ~, ~,features(imageNumber,featureNumber),features(imageNumber,featureNumber+1),features(imageNumber,featureNumber+2),features(imageNumber,featureNumber+3)] = FeaturesBasedOnShapeChooseCertainStartingPointForCalculationsV(imageArrayMask,p,b);% FeaturesBasedOnShapeChooseCertainStartingPointForCalculations(imageArrayMask,p,b);
            colName(featureNumber ) = {append(char(string(featureNumber)),' ','minrolcorPointAndMidP',char(string(p)),'B',char(string(b)))};
            colName(featureNumber + 1) = {append(char(string(featureNumber + 1)),' ','minrolcorPointsP',char(string(p)),'B',char(string(b)))};
            colName(featureNumber + 2) = {append(char(string(featureNumber + 2)),' ','minrolcoranglespointpointmiddleP',char(string(p)),'B',char(string(b)))};
            colName(featureNumber + 3) = {append(char(string(featureNumber + 3)),' ','minrolcoranglespointmiddlepointP',char(string(p)),'B',char(string(b)))};
            featureNumber = featureNumber + 4;
            
            % 7        
            features(imageNumber,featureNumber) = objectSizeMedian(imageArrayMask);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','medianOfTheObjectsSize')};
            featureNumber = featureNumber + 1;
            
            % 8
            features(imageNumber,featureNumber) = howMuchWhite(imageArrayMask);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','howMuchWhiteInMaskPercent')};
            featureNumber = featureNumber + 1;
            
            % 9, 10
            [features(imageNumber,featureNumber), features(imageNumber,featureNumber+1)] = BacteriasAndObjects(imageArrayMask);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','howManyObjects')};
            colName(featureNumber + 1) = {append(char(string(featureNumber + 1)),' ','howManyBacterias')};
            featureNumber = featureNumber + 2;

            % Features based on dispersion (11-26)
            
            % 11 - 17

            rad = 25;
            for w = 1:8
                features(imageNumber,featureNumber) = MeanShiftCalculation(imageArrayMask,rad);
                colName(featureNumber) = {append(char(string(featureNumber)),' ','meanShiftr', char(string(rad)))};
                featureNumber = featureNumber + 1;
                rad = rad + 25;
            end

           
            
            % 19
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 3, false, 0, 2);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance2DForK3')};
            featureNumber = featureNumber + 1;
            
            % 20
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 6, false, 0, 2);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance2DForK6')};
            featureNumber = featureNumber + 1;
            
            % 21
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 10, false, 0, 2);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance2DForK10')};
            featureNumber = featureNumber + 1;
            
            % 22
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 3, false, 0, 3);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance3DForK3')};
            featureNumber = featureNumber + 1;
            
            % 23
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 6, false, 0, 3);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance3DForK6')};
            featureNumber = featureNumber + 1;
            
            % 24
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 10, false, 0, 3);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance3DForK10')};
            featureNumber = featureNumber + 1;
            
            % 25
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 3, true, 0, 2);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance2DForK3weighted')};
            featureNumber = featureNumber + 1;
            
            % 26
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 6, true, 0, 2);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance2DForK6weighted')};
            featureNumber = featureNumber + 1;
            
            % 27
            features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, 10, true, 0, 2);
            colName(featureNumber) = {append(char(string(featureNumber)),' ','NewKmeansAndVariance2DForK10weighted')};
            featureNumber = featureNumber + 1;


        % Features based on color 1-32
    %             % 1 - gray
    %             features(imageNumber,featureNumber) = varianceCalculations(imageArray,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','varianceOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 2 - gray
    %             features(imageNumber,featureNumber) = varianceWholeImage(imageArray);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','varianceWholeImage')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 3 - color
    %             features(imageNumber,featureNumber) = varianceWholeImageColor(imageArray,1);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','varianceWholeImageRed')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 4 - color
    %             features(imageNumber,featureNumber) = varianceWholeImageColor(imageArray,2);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','varianceWholeImageGreen')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 5 - color
    %             features(imageNumber,featureNumber) = varianceWholeImageColor(imageArray,3);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','varianceWholeImageBlue')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 6 - gray
    %             features(imageNumber,featureNumber) = meanCalculations(imageArray,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 7 - gray
    %             features(imageNumber,featureNumber) = meanWholeImage(imageArray);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanWholeImage')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 8 - color
    %             features(imageNumber,featureNumber) = meanWholeImageColor(imageArray,1);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanWholeImageRed')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 9 - color
    %             features(imageNumber,featureNumber) = meanWholeImageColor(imageArray,2);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanWholeImageGreen')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 10 - color
    %             features(imageNumber,featureNumber) = meanWholeImageColor(imageArray,3);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanWholeImageBlue')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 11 - color
    %             features(imageNumber,featureNumber) = varianceColor(imageArray,imageArrayMask,1);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','warRedOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 12 - color
    %             features(imageNumber,featureNumber) = varianceColor(imageArray,imageArrayMask,2);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','warGreenOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 13 - color
    %             features(imageNumber,featureNumber) = varianceColor(imageArray,imageArrayMask,3);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','warBlueOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 14 - color
    %             features(imageNumber,featureNumber) = meanColor(imageArray,imageArrayMask,1);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanOnMaskRed')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 15 - color
    %             features(imageNumber,featureNumber) = meanColor(imageArray,imageArrayMask,2);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanOnMaskGreen')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 16 - color
    %             features(imageNumber,featureNumber) = meanColor(imageArray,imageArrayMask,3);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','meanOnMaskBlue')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 17 - gray
    %             features(imageNumber,featureNumber) = kurtosisCalculation(imageArray);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisGrayWholeImage')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 18 - gray
    %             features(imageNumber,featureNumber)  = kurtosisMask(imageArray,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisGrayOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 19 - color
    %             features(imageNumber,featureNumber)  = kurtosisColor(imageArray,1);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisRedWholeImage')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 20 - color
    %             features(imageNumber,featureNumber) = kurtosisColor(imageArray,2);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisGreenWholeImage')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 21 - color
    %             features(imageNumber,featureNumber) = kurtosisColor(imageArray,3);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisBlueWholeImage')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 22 - color
    %             features(imageNumber,featureNumber) = kurtosisColorMask(imageArray,1,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisRedOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 23 - color
    %             features(imageNumber,featureNumber) = kurtosisColorMask(imageArray,2,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisGreenOnMask')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 24 - color
    %             features(imageNumber,featureNumber)  = kurtosisColorMask(imageArray,3,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','kurthosisBlueOnMask')};
    %             featureNumber = featureNumber + 1;
    %             
    %             % 25 - gray
    %             features(imageNumber,featureNumber) = skewnessCalculation(imageArray);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessGrayWholeImage')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 26 - gray
    %             features(imageNumber,featureNumber) = skewnessMask(imageArray,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessGrayOnMask')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 27 - color
    %             features(imageNumber,featureNumber) = skewnessColor(imageArray,1);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessRedWholeImage')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 28 - color
    %             features(imageNumber,featureNumber) = skewnessColor(imageArray,2);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessGreenWholeImage')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 29 - color
    %             features(imageNumber,featureNumber) = skewnessColor(imageArray,3);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessBlueWholeImage')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 30 - color
    %             features(imageNumber,featureNumber) = skewnessColorMask(imageArray,1,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessRedOnMask')};
    %             featureNumber = featureNumber + 1;
    %               
    %             % 31 - color
    %             features(imageNumber,featureNumber) = skewnessColorMask(imageArray,2,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessGreenOnMask')};
    %             featureNumber = featureNumber + 1;
    %              
    %             % 32 - color
    %             features(imageNumber,featureNumber) = skewnessColorMask(imageArray,3,imageArrayMask);
    %             colName(featureNumber) = {append(char(string(featureNumber)),' ','skewnessBlueOnMask')};
    %             featureNumber = featureNumber + 1;


            imageNumber = imageNumber + 1    
        end
    end

    features = real(features);
    allColumns = [number', classNumber', className', numberInClass',features];
    allColNames = ['number', 'classNumber', 'className', 'numberInClass', colName];
    c = array2table(allColumns,'VariableNames',allColNames);
    writetable(c,"CalculatedTableOfFeatures.csv");

    % Normalize allFeatures
    for e = 1:size(features,2)
       allFeaturesNormalized(:,e) = normalize(features(:,e), 'range', [-1 1]);
    end

    allColumnsNormalized = [number', classNumber',className', numberInClass',allFeaturesNormalized];
    cNorm = array2table(allColumnsNormalized,'VariableNames',allColNames);
    cNorm
    
    % Save features to csv
    writetable(cNorm,"CalculatedTableOfFeaturesNormalized.csv");

    cNorm

end

