function result = varianceColor(image, mask,colorNumber)
     image = image(:,:,colorNumber);
     result = var(double(image(mask)));
end