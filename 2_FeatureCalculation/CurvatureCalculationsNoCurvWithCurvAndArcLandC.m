function [arcLength,wholeCurvature] = CurvatureCalculationsNoCurvWithCurvAndArcLandC(x,y,ImageMask)
    
    % In this code we calculate curvature and arc length for bacteria
    [poly_X, poly_Y, t] = CubicSplineCBCombined(x,y);

    curvature = 0;
    arcLength = 0;
    wholeCurvature = 0;

    % For each polynomial
    % Add par!
    parfor i = 1:length(x)-1
        % I calculate curvature
        [L(i),K(i),curvPoly(i),arcL(i)] = CurvatureAndIntegral(poly_X{i}, poly_Y{i},t(i),t(i+1));
        
        curvature = curvature + K(i);
        arcLength = arcLength + arcL(i);
        % Whole curvature without dividing on amount of polynomials
        wholeCurvature = wholeCurvature + K(i);
    end
    
    % In this version of code we dont need to calculate more. If you want
    % to analyze the images that could be created with the following code
    % you can remove the return statement and
    % uncomment the code for generating images
    
    return
    
    curvatureMean = curvature/size(poly_X,2);
    
    %% Image 1: Curvature Function
%     
%     figure;
%     for j = 1:length(x)-1
%         moved = 0;
%         
%         interval = [t(j),t(j+1)];
% 
%         [xx,yy] = fplot(curvPoly(j), interval);
%         plot(xx+moved,yy);
%         title('curvature')
%         hold on;
%     end
%     hold off;
    %% Image end

%%     Image 2: Bacterias and extreme points from curvature put on it
%      figure
%     for i = 1:size(poly_X,2)
%         
%          interval = [t(i),t(i+1)];
%          
%          fplot(poly_X{i}, poly_Y{i}, interval); 
%          hold on;
%          title('Bakteria');
%          hold on;
%     end
%     %%Image end
%     
%     %New maximas,minimas and middle x and y
    maximasAndMinimas = zeros(size(x,1),3);
    maximasAndMinimas(:,2) = x;
    maximasAndMinimas(:,3) = y;
    middlex = mean(x);
    middley = mean(y);
    
%     %Image: center if mass - middle x and y
%     scatter(middlex, middley);
%     hold on;
    
    %Some points repeat because some maximas and minimas are same points
    % As we want the same number of maximas and minimas i leave duplicates 
    % If i get nan i put there 0
%      output_array = unique(maximasAndMinimas(:,2:3),'rows')


%%     Image 3 (Requires Image 2 to be uncommented): Adding lines between
%    which i calculate distances and angles

%     for i = 2:size(maximasAndMinimas,1)%size(poly_X,2)*2+1
%          first = i-1;
%          second = i;
%          
% %          if second > size(poly_X,2)*2
% %             second = 1;
% %          end    
%              
%         plot([maximasAndMinimas(first,2), middlex],[maximasAndMinimas(first,3), middley]);
%         plot([maximasAndMinimas(second,2), middlex],[maximasAndMinimas(second,3), middley]);
%         plot([maximasAndMinimas(first,2), maximasAndMinimas(second,2)],[maximasAndMinimas(first,3), maximasAndMinimas(second,3)]);
%     end
%     
    %Angles between All extremums
    
    for angleExtrNumber = 2:size(maximasAndMinimas,1)%size(poly_X,2)*2+1
    
         first = angleExtrNumber-1;
         second = angleExtrNumber;
         
%          if second > size(poly_X,2)*2
%             second = 1;
%          end    
             
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
        
        %Distance between next extremas
        points = [maximasAndMinimas(first,2),maximasAndMinimas(first,3);maximasAndMinimas(second,2),maximasAndMinimas(second,3)];
        distancesBetweenPoints(angleExtrNumber-1) = pdist(points,'euclidean');
        
        %Distance between point and center of mass
        points2 = [maximasAndMinimas(second,2),maximasAndMinimas(second,3);double(middlex), double(middley)];
        distancesBetweenPointAndMid(angleExtrNumber-1) = pdist(points2,'euclidean');
 
    end
    
%     arcLength = 0;
%     wholeCurvature = 0;
%     curvatureMean = 0;

end

function p = solvePolynomial(A)
syms f(x)
f(x) = double(A(1))*(x)^3 + double(A(2))*(x)^2 + double(A(3))*(x) + double(A(4));
p = simplify(f);
p = formula(p);
end