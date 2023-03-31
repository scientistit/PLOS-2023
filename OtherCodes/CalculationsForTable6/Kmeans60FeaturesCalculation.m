
function Kmeans60FeaturesCalculation(Folder)

    Folder = '../../ImagesAndMasks/';


    %Chosing folders with microscopic images
    %Folders where images with masks are placed include "_otsu" at the end of the
    %folder name

    folderNames = ["Pi","E7","x5","Br","Ps"];
    imageNumber = 1;

    %Go through every folder
    for i = 1:size(folderNames,2)


        myFolder = append(Folder,folderNames(i));

        % Check to make sure that folder actually exists.  Warn user if it doesn't.
        if ~isfolder(myFolder)
            errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
            uiwait(warndlg(errorMessage));
            myFolder = uigetdir(); % Ask for a new one.
            if myFolder == 0
                 % User clicked Cancel
                 return;
            end
        end

      % Get a list of all files in the folder with the desired file name pattern.
        filePattern = fullfile(myFolder, '*.png'); 
        theFiles = dir(filePattern);


        %Go through every image in the current folder
        for k = 1:length(theFiles)

            %Image number
            number(imageNumber) = imageNumber;

            %Number of the bacteria genera
            classNumber(imageNumber) = i;

            %Name of the bacteria genera
            className(imageNumber) = folderNames(i);

            %Number of the microscopic image (inside current bacteria genera)
            numberInClass(imageNumber) = k;

            %Get current microscopic image
            baseFileName(k,:) = theFiles(k).name;
            fullFileName = fullfile(theFiles(k).folder, baseFileName(k,:));
            imageArray = imread(fullFileName);
    %         imshow(imageArray)

            %Get the mask corresponding to the current image (calculated
            %previously)
            maskFolder = append(Folder,folderNames(i),"_otsu");
            fullFileName = fullfile(maskFolder,baseFileName(k,:));
            imageArrayMask = imread(fullFileName);
    %         imshow(imageArrayMask)

            %Calculating features
            q = 0.4;
            featureNumber = 1;

            for g = 1:20
                features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, g, false, q, 2);
                colName(featureNumber) = {append(char(string(featureNumber)),' ','V')};
                featureNumber = featureNumber + 1;
            end

            for g = 1:20
                features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, g, false, q, 3);
                colName(featureNumber) = {append(char(string(featureNumber)),' ','V')};
                featureNumber = featureNumber + 1;
            end

            for g = 1:20
                features(imageNumber,featureNumber) = KmeansAndVariance(imageArrayMask, g, true, q, 2);
                colName(featureNumber) = {append(char(string(featureNumber)),' ','V')};
                featureNumber = featureNumber + 1;
            end

            imageNumber = imageNumber + 1    
        end
    end

    features = real(features);
    allColumns = [number', classNumber', className', numberInClass',features];
    allColNames = ['number', 'classNumber', 'className', 'numberInClass', colName];
    c = array2table(allColumns,'VariableNames',allColNames);
    writetable(c,"Kmeans60q04NEW.csv");

    %Normalize allFeatures
    for e = 1:size(features,2)
       allFeaturesNormalized(:,e) = normalize(features(:,e), 'range', [-1 1]);
    end

    allColumnsNormalized = [number', classNumber',className', numberInClass',allFeaturesNormalized];
    cNorm = array2table(allColumnsNormalized,'VariableNames',allColNames);
    cNorm
    %Save features to csv
    writetable(cNorm,"Kmeans60q04normNEW.csv");

    cNorm

end



