function [L,integ,tmp,Lnumber] = CurvatureAndIntegral(poly_X, poly_Y,t1,t2)
    
    %Testing data:
%     t1 = 0;
%     t2 = 1;
%     syms t
%     px = 3*sin(sym(t));
%     py = 3*cos(sym(t));
    %integ = 1/3
    
    %Take one polynomial
     px = poly_X;
     py = poly_Y;
    
    %Curvature = length (derivative of the unit tangent) / length (vector tangent)
    %PL: Krzywizna = d³ugo¶æ(pochodna stycznej jednostkowej) / d³ugo¶æ(wektora
    %stycznego)
    
    %First, let's calculate the denominator ||r'(t)||
    %PL = Najpierw wyliczymy mianownik ||r'(t)||
    dlrprimodt = sqrt((diff(px))^2 + (diff(py))^2);



    %Let's count the length of the arc (may be useful later)
    %PL: policzmy przy okazji d³ugo¶æ ³uku
    L = int(dlrprimodt,t1,t2);
    Lnumber = double(vpa(L));
    
    %Now we determine T'(t), that is, we divide each of the elements of the vector r'(t) into its length
    %PL: Teraz wyznaczymy  T'(t) czyli ka¿dy z elementów wetora r'(t) dzielimy na jego d³ugo¶æ
    Tprimx = diff(px)/dlrprimodt;
    Tprimy = diff(py)/dlrprimodt;

    %Now we determine ||T'(t)||
    %PL:wyliczymy ||T'(t)||
    dltprimodt = sqrt((Tprimx)^2 + (Tprimy)^2);
    k =  dltprimodt/dlrprimodt;
    tmp = k;
    
    q=matlabFunction(k);

    %Jezeli to liczba to zwrocic liczbe
    try
        integ = integral(q,t1,t2); %zdjecie 55, 10,10, bakteria 3, krzywizna 8
    catch
        integ = sqrt(q())/log(q());    
    end
        %integ = integral(q,t1,t2);
    
%     k(1)
%     k = double(k(1))
%     k = simplifyFraction(k);

    %Image: Curvature function
%     figure
%     ezplot(k,[0,2])
end