function result = skewnessColor(image,num)
     image = image(:,:,num);
     imageArray = reshape(image,[1, (size(image,1) * size(image,2))]);
     result = skewness(double(imageArray));
end