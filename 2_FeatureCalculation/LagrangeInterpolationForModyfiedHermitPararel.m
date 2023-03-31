function dx = LagrangeInterpolationForModyfiedHermitPararel(points)
% enter points for example
%  points = [5,12;6,13;9,14;11,16]
x0 = points(1,1);
syms f(x); 
f(x) = 0;

for i = 1:size(points,1)
        licznik = 1;
        mianownik = 1;
        syms licznik(x);
        licznik(x) = 1;

     for j = 1:size(points,1)
        if j ~= i      
            points(j,1);
            licznik(x) = licznik *  (x - points(j,1));
            mianownik = mianownik * (points(i,1) - points(j,1));
        end
    end


     f(x) = f + (licznik(x)/mianownik) * points(i,2);
end 

p = f; 


% fplot(p, [1,18]);
% hold on;

% scatter(points(:,1),points(:,2));
dif = diff(p);
x0;
dif(x0);

dx = dif(x0);

end

