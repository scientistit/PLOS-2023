 function varsum = KmeansAndVariance(imageArrayMask, k, weighted,quant,dim)

%      imageArrayMask = imread('/Users/aleksandra/Documents/PracaBadawcza/Artyku³/ObrazyDoObliczenWArtykule/K-means/Pi.png');
%      k = 10;
%      weighted = false;
%      quant = 0.2;
%      dim = 2;

    iml = bwlabel(imageArrayMask,4);
    g = regionprops(iml,'Area','BoundingBox','Centroid');
    area_values = [g.Area];

    centroids = [g.Centroid];
    centroids = reshape(centroids,[2,size(centroids,2)/2]);

    centroids = centroids(:,area_values >= quantile(area_values,quant));
    area_values = area_values(:,area_values >= quantile(area_values,quant));

    for i = 1 : size(area_values,2)
        normarea_values(i) = (area_values(i) - min(area_values))/(max(area_values)-min(area_values));
    end
    
    if dim == 2
        ret = kmeans([centroids(1,:)',centroids(2,:)'],k);
    elseif dim == 3
        ret = kmeans([centroids(1,:)',centroids(2,:)',area_values'],k);  
    end
        
    out = [centroids(1,:)',centroids(2,:)',ret,normarea_values'];

    
    outs = zeros(size(centroids,2),k,4);

    for j = 1:k 
      pointsforcentroid = out((ret == j)',:);
      outs(1:size(pointsforcentroid,1),j,:) = pointsforcentroid(:,:);
    end

    % figure;
%      imshow(imageArrayMask);
%      hold on;

     % As the 'outs' vector consists of zeros to fill the matrix we need to select only x and y values
     % where the k value is equal to e.g. 1, 2, 3 and not 0.
     varsum = 0;

    color = ["red", "green", "blue", "cyan","magenta", "yellow", "white", "red", "green", "blue"];
    for i = 1:k
         x = outs(outs(:,i,3) == i,i,1);
         y = outs(outs(:,i,3) == i,i,2);
         var = 0;
         if size(x,1) > 1
             oneoutnozeros = outs(outs(:,i,3) == i,i,:);
%              scatter(x,y,color(i),'filled');
%              hold on;
             p = fit(x, y, 'poly1');
%              plot(p,x, y);
%              hold on;
             var = calcVariance(p,oneoutnozeros,weighted);
         end
         varsum = varsum + var;
    end
end

 function variance = calcVariance(p,out,weighted)
 
    for i = 1:size(out,1)
        yes1(i) = p.p1 * out(i,1,1) + p.p2;
    end
    
    out(:,1,5) = yes1';
    weighsum = 0;
    for i = 1:size(out,1)
        if weighted
            suma = power((out(i,1,2) - out(i,1,5)),2)*out(i,1,4);
            weighsum = weighsum + out(i,1,4);
        else
            suma = power((out(i,1,2) - out(i,1,5)),2);
        end
    end
    
     if weighted
         variance = suma/weighsum;
     else
         variance = suma/(size(out,1)-1);
     end
 end
 
 
    