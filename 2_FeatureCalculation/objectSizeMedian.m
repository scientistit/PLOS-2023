 function medianOut = objectSizeMedian(ImageMask)
    iml = bwlabel(ImageMask,4);
    vislabels(iml),title('Each object labelled');
    g = regionprops(iml,'Area','BoundingBox');
    area_values = [g.Area];
    medianOut = median(sort(area_values));
end