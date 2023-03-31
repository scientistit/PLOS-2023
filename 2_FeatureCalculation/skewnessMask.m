function wynik = skewnessMask(image,mask)
     image = rgb2gray(image);
     wynik = skewness(double(image(mask)));
end