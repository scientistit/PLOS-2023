function result = kurtosisColorMask(image,num,mask)
    image = image(:,:,num);
    result = kurtosis(double(image(mask)));
end
