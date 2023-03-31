function [arcLength,wholeCurvature,curvatureMean,distancesBetweenPointAndMid,distancesBetweenPoints,anglesTwoArrayExtr,anglesArrayExtr] = CurvatureCalculationsNoCurvV(x,y,ImageMask)
    
    % New maximas,minimas and middle x and y
    maximasAndMinimas = zeros(size(x,1),3);
    maximasAndMinimas(:,2) = x;
    maximasAndMinimas(:,3) = y;
    middlex = mean(x);
    middley = mean(y);
        
    % Angles between All extremums
    
    for angleExtrNumber = 2:size(maximasAndMinimas,1)
    
         first = angleExtrNumber-1;
         second = angleExtrNumber;
            
             
        % I calculate angles between previous point, center of mass and current point
        P0 = [middlex, middley]; %- angle here
        P1 = [maximasAndMinimas(first,2), maximasAndMinimas(first,3)];
        P2 = [maximasAndMinimas(second,2), maximasAndMinimas(second,3)];

        n1 = (P2 - P0) / norm(P2 - P0);  % Normalized vectors
        n2 = (P1 - P0) / norm(P1 - P0);
        
        
        anglesArrayExtr(angleExtrNumber-1) = double(acosd(dot(n1, n2)));
        
        % I calculate angles between previous point, next point and center
        % of mass

        P10 = [maximasAndMinimas(second,2), maximasAndMinimas(second,3)]; %Second - angle here
        P11 = [maximasAndMinimas(first,2), maximasAndMinimas(first,3)]; %First
        P12 = [middlex, middley]; %Third

        n11 = (P12 - P10) / norm(P12 - P10);  % Normalized vectors
        n12 = (P11 - P10) / norm(P11 - P10);
        
        if ~isnan(double(acosd(dot(n11, n12))))
            anglesTwoArrayExtr(angleExtrNumber-1) = double(acosd(dot(n11, n12)));
        else
            anglesTwoArrayExtr(angleExtrNumber-1) = 0;
        end
        
        % Distance between next extremas
        points = [maximasAndMinimas(first,2),maximasAndMinimas(first,3);maximasAndMinimas(second,2),maximasAndMinimas(second,3)];
        distancesBetweenPoints(angleExtrNumber-1) = pdist(points,'euclidean');
        
        % Distance between point and center of mass
        points2 = [maximasAndMinimas(second,2),maximasAndMinimas(second,3);double(middlex), double(middley)];
        distancesBetweenPointAndMid(angleExtrNumber-1) = pdist(points2,'euclidean');
 
    end
    
    % These values will be unused in this case
    arcLength = 0;
    wholeCurvature = 0;
    curvatureMean = 0;

end

function p = solvePolynomial(A)
syms f(x)
f(x) = double(A(1))*(x)^3 + double(A(2))*(x)^2 + double(A(3))*(x) + double(A(4));
p = simplify(f);
p = formula(p);
end