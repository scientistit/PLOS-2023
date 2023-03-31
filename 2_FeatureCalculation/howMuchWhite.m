function howMuch = howMuchWhite(imageArrayMask)
white = sum(imageArrayMask,'all');
howMuch = white /(size(imageArrayMask,1) * size(imageArrayMask,2));
end