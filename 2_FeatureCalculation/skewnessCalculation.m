function result = skewnessCalculation(image)
     image = rgb2gray(image);
     imageArray = reshape(image,[1, (size(image,1) * size(image,2))]);
     result = skewness(double(imageArray));
end