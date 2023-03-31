I1 = double(imread('./RotatedShapes/RotIrregular.png'));
figure
imshow(I1)

sum(sum(I1));
Irotated = imrotate(I1,135);
sum(sum(Irotated));

sizeDifference = size(Irotated,1) - size(I1,1);
figure
imshow(Irotated);
imwrite(Irotated,"./RotatedShapes/RotIrregular135NEW.png");