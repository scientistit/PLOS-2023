function result = MeanShiftCalculation(imageArrayMask,radious)
    iml = bwlabel(imageArrayMask,4);
    %Image: Each object labelled
    %vislabels(iml),title('Each object labelled');
    g = regionprops(iml,'Area','BoundingBox','Centroid');

    centroids = [g.Centroid];
    centroids = reshape(centroids,[2,size(centroids,2)/2]);
     
    for i = 1:size(centroids,2)
        x(i) = (centroids(1,i));
        y(i) = (centroids(2,i));
    end

    [clustCent, ~, ~] = MeanShiftCluster([x',y']',radious);
    result = size(clustCent,2);
end