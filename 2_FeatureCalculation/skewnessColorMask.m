function result = skewnessColorMask(image,num,mask)
    image = image(:,:,num);
    result = skewness(double(image(mask)));
end
