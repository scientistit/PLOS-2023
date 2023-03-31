function result = kurtosisMask(image,mask)
     image = rgb2gray(image);
     result = kurtosis(double(image(mask)));
end