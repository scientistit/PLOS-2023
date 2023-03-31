function  [poly_X, poly_Y, t] = CubicSplineCBCombined(x,y)

    % Ways of time calculation

    t = zeros(1,size(x,1)+3);

    % 0 - uniform
    % timePower = 0;
    % 1 - chordal
    % timePower = 1;
    % 0,5 - centripetial
     timePower = 0.5;

    %centripetal parameterization

     xtmp = [x;x(2:4)];
     ytmp = [y;y(2:4)];

     xtmp = xtmp';
     ytmp = ytmp';

    for i = 2:size(x,1)+3
        t(i) = t(i-1) + sqrt((xtmp(i-1) - xtmp(i))^2 + (ytmp(i-1) - ytmp(i))^2)^timePower;
    end
 

    der = zeros(2,size(xtmp,2)-3);

    %par
    parfor i = 1:size(xtmp,2)-3
      from = i;
      to = i + 3;

      chosenx = xtmp(from:to);
      chosent = t(from:to);

      pointsx = [chosent',chosenx'];

      der(1,i) = LagrangeInterpolationForModyfiedHermitPararel(pointsx);
    end

    %par
    parfor i = 1:size(xtmp,2)-3
      from = i;
      to = i + 3;

      choseny = ytmp(from:to);
      chosent = t(from:to);

      pointsy = [chosent',choseny'];

      der(2,i) = LagrangeInterpolationForModyfiedHermitPararel(pointsy);
    end

    pointsx = [t(1:end-3)', x];
    pointsy = [t(1:end-3)',y];


    %Derivatives are calculated using Lagrange

    fprim11 = der(1,1);
    fprim12 = der(2,1);
    fprim21 = der(1,end);
    fprim22 = der(2,end);

    poly_X = CubicSplineCB(pointsx,fprim11,fprim21);
    poly_Y = CubicSplineCB(pointsy,fprim12,fprim22);

end