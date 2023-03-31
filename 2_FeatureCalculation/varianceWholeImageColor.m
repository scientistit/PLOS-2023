function result = varianceWholeImageColor(image,colorNumber)
     image = image(:,:,colorNumber);
     imageArray = reshape(image,[1, (size(image,1) * size(image,2))]);
     result = var(double(imageArray));     
end