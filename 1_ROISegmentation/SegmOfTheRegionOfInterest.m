function SegmOfTheRegionOfInterest(inputImagesFolder,outputMaskFolder)
    
    % These two variables are hardcoded
    % You can comment these two lines out if you want to invoke the function
    % applying your custom parameters
    
    % Specify the folder where the files are located
    inputImagesFolder = './ExampleImages';
    % Specify where you would like to place masks
    outputMaskFolder = "./ExampleMasks";
    
    % Check to make sure that folder actually exists. 
    % Warn user if it doesn't.
    if ~isfolder(inputImagesFolder)
        errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', inputImagesFolder);
        uiwait(warndlg(errorMessage));
        % Ask for a new one.
        inputImagesFolder = uigetdir(); 
        if inputImagesFolder == 0
             % User clicked Cancel
             return;
        end
    end
    
    % Get a list of all files in the folder with the desired file name pattern.
    filePattern = fullfile(inputImagesFolder, '*.png');
    theFiles = dir(filePattern);

    for k = 1 : length(theFiles)

        baseFileName = theFiles(k).name;
        fullFileName = fullfile(theFiles(k).folder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);

        imageArray = imread(fullFileName);
        
        % Display image.
        % imshow(imageArray)  

        baseFileName = baseFileName(1:end-4);

        % Perform operations that will lead to creating a mask
        imageArrayOtsu = builtInOtsu(imageArray,1);

        zeros = sum(imageArrayOtsu(:) == 0);
        ones = sum(imageArrayOtsu(:) == 1);

        if zeros < ones
           imageArrayOtsu = ~imageArrayOtsu;
        end

        imageArrayOtsu = imfill(imageArrayOtsu,'holes');
        imageArrayOtsu = bwareaopen(imageArrayOtsu, 60, 4);

        saveImage(imageArrayOtsu,outputMaskFolder,baseFileName,'_otsu','png')

    end
end

function saveImage(Image,folderName,baseFileName,suffix,filetype)
    % Create new path name (without .png)
    newImagePath = append(folderName,'/',baseFileName,suffix);

    n = 1;
    % If there is a file with a certain name add number at the end of it "_2" (2,3,4..)
    while exist(append(newImagePath,'.',filetype),'file')
        n = n + 1;
        newImagePath = append(newImagePath,'_',int2str(n));
    end
    
    % File add extension
    newImagePath = append(newImagePath,'.',filetype);

    % Save file
    imwrite(Image,newImagePath,filetype);
end