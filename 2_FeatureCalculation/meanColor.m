function result = meanColor(image, mask,colorNumber)
     ones = sum(mask(:) == 1); 
     colorImage = image(:,:,colorNumber);
     result = sum(double(colorImage(mask)))/ones;     
end