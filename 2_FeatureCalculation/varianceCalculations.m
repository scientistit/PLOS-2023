function result = varianceCalculations(image, mask)
     image = rgb2gray(image);
     result = var(double(image(mask)));     
end