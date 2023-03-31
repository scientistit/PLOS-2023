function polys = CubicSplineCB (points,fprim1,fprim2)


    dimensionOfMatrix = (size(points,1)-1)*4;
    B = zeros(dimensionOfMatrix,1);
    
    howManyPoints = size(points,1);
    toBindex = 1;
    for bIndex = 1:dimensionOfMatrix/2
        B(bIndex) = points(toBindex,2);
        toBindex = toBindex + 1;
        if bIndex == howManyPoints - 1
          toBindex = 2;
        end
    end
    B(size(B,1)-1) = fprim1;
    B(size(B,1)) = fprim2;
    B;

    A = zeros(dimensionOfMatrix,dimensionOfMatrix);
    ind = 1;
    innyind = 1;
    inds = 1;
    
    for rowIndex = 1:dimensionOfMatrix
        %Points at the beginning of each ompartment
        %PL: Punkty na pocz±tkach ka¿dego przedzia³u
        if rowIndex <= dimensionOfMatrix/4
            column = rowIndex + 3 * (rowIndex-1);
            A(rowIndex,column) = 1;
        end
        %Functions at the end points for example S0(x1), S1(x2), S2(x3)
        %PL: Funcje na punktach koñcowych np S0(x1), S1(x2), S2(x3)
        if rowIndex > dimensionOfMatrix/4 && rowIndex <= dimensionOfMatrix/2
            howMuch = dimensionOfMatrix/4;
            %3,4,5
            from = 1 + (rowIndex - howMuch - 1)*4;
            to = 4 + (rowIndex - howMuch - 1)*4;
            for colIndex = from:to%12
                doPotegi = (colIndex - 1) - (4 * (ind - 1));
                A(rowIndex,colIndex) = (points(ind + 1,1) - points(ind,1))^doPotegi;
            end
            ind = ind + 1;
        end
        
        %In points that connect compartments first derivatives and second
        %derivatives should be equal
        %PL: W punktach w których ³±cz± siê przedzia³y pierwsza pochodna ma byæ
        %równa pierwszej, a druga ma byæ równa drugiej
        
        %How many such points are there?
        %Amount of all points - two on edges
        %First derivative should be equal to first derivative S0'(x1)=S1'(x2) S1'(x2)=S2'(x2)
        %PL: ile jest takich punktów
        %liczba wszystkich punktów - 2 na brzegach
        %Pierwsza pochodna równa pierwszej pochodnej S0'(x1)=S1'(x2) S1'(x2)=S2'(x2)
        
        if rowIndex > dimensionOfMatrix/2 && rowIndex <= ((dimensionOfMatrix/2) + size(points,1) - 2)
            fromA = 2 + 4 * (innyind - 1);
            toA = 4 + 4 * (innyind - 1);
            insideI = 1;
            for colIndex = fromA :toA
                A(rowIndex,colIndex) = insideI*((points(innyind + 1,1)-points(innyind,1))^(insideI-1));  
                insideI = insideI + 1;
            end
            A(rowIndex,6 + ((innyind-1) * 4)) = -1;
            innyind = innyind + 1;
        end
        %Second derivative should be equal to second derivative
        %PL: Druga pochodna równa drugiej pochodnej 
        if rowIndex > ((dimensionOfMatrix/2) + size(points,1) - 2) && rowIndex <= ((dimensionOfMatrix/2) + 2 *( size(points,1) - 2))
            A(rowIndex,4 + ((inds-1) * 4) ) = 6*((points(inds + 1,1)-(points(inds,1))));
            A(rowIndex,3 + ((inds-1) * 4)) = 2;
            A(rowIndex,7 + ((inds-1) * 4)) = -2;
            inds = inds + 1;
        end
      
        if rowIndex ==  dimensionOfMatrix - 1
             A(rowIndex,2) = 1;
        end
        
        
        if rowIndex ==  dimensionOfMatrix
            p1 = points(size(points,1),1);
            p2 = points(size(points,1)-1,1);
            place = ((size(points,1)-1)*4) - 3;
            for coIndex = 1:4
                A(rowIndex,place) = (coIndex-1)*(p1-p2)^(coIndex-2); 
                place = place + 1;
            end
            
        end
    end
    
    
%     Bdocelowe = [2;5;5;7;0;0;0;0]
%     Adocelowe = [1,0,0,0,0,0,0,0; 
%                  0,0,0,0,1,0,0,0; 
%                  1,2,4,8,0,0,0,0;
%                  0,0,0,0,1,3,9,27;
%                  0,1,4,12,0,-1,0,0;
%                  0,0,2,12,0,0,-2,0;
%                  0,0,2,0,0,0,0,0;
%                  0,0,0,0,0,0,2,18]
%              
%     Xdocelowe = linsolve(Adocelowe,Bdocelowe) 

    A;
    X = linsolve(A,B); 
    polys = solvePolynomialsFromBigMatrix(X,points);
    
%     %Image - I dont remember what image it is but I leave it because maybe i
%     will recall it
%     for i = 1:size(X,1)/4
%         interval = [points(i,1),points(i+1,1)];
%         if (points(i,1)>points(i+1,1))
%             interval = [points(i+1,1),points(i,1)];
%         end
%         fplot(polys(i),interval);
%         hold on; 
%     end
%     scatter(points(:,1),points(:,2));
%     
%     for a = 1 : howManyPoints - 1
%         from = points(a,1) + 1;
%         to = points(a + 1,1);
%         
%         if a == 1
%             from = points(1,a);
%         end
%         
%         searchedXesV(a,:) = linspace(from,to,100);
%     end
%     
%     size(searchedXesV);
    
end

function polys = solvePolynomialsFromBigMatrix(X,points)
    X = reshape(X,[4,size(X,1)/4]);
    X = X';
    syms x
    for i = 1:size(X,1)
        polys{i} =  double(X(i,1))*(x-points(i,1))^0 + double(X(i,2))*(x-points(i,1))^1 + double(X(i,3))*(x-points(i,1))^2 + double(X(i,4))*(x-points(i,1))^3;
    end
end