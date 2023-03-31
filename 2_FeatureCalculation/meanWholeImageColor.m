function result = meanWholeImageColor(image,colorNumber)
     % 1 - red
     % 2 - green
     % 3 - blue
     image = image(:,:,colorNumber);
     imageArray = reshape(image,[1, (size(image,1) * size(image,2))]);
     result = sum(double(imageArray))/(size(image,1) * size(image,2));     
end