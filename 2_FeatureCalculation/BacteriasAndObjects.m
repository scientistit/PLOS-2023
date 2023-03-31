function [howManyObjects,howManyBacterias] = BacteriasAndObjects(imageArrayMask)

    iml = bwlabel(imageArrayMask,4);
    %Image: Each object labelled
%     vislabels(iml),title('Each object labelled');
    g = regionprops(iml,'Area','BoundingBox');
    area_values = [g.Area];
    
    howManyObjects = size(area_values,2);
    white = sum(imageArrayMask,'all');
    mediana = median(sort(area_values));
    
    howManyBacterias = white/mediana;

end