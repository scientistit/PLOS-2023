function result = meanCalculations(image, mask)
     ones = sum(mask(:) == 1); 
     image = rgb2gray(image);
     result = sum(double(image(mask)))/ones;     
end