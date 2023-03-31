function result = meanWholeImage(image)
     image = rgb2gray(image);
     imageArray = reshape(image,[1, (size(image,1) * size(image,2))]);
     result = sum(double(imageArray))/(size(image,1) * size(image,2));     
end