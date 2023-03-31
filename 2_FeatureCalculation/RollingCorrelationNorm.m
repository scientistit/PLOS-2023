
function [sumsvector] = RollingCorrelationNorm(vectorExemplary,vectorToCompare)
    % vectorExemplary = [4,1,2,3];
    % vectorToCompare = [1,2,3,4];
    
    % Normalize both vectors
    
    vectorExemplary = (vectorExemplary - min(vectorExemplary))./(max(vectorExemplary) - min(vectorExemplary));
    vectorToCompare = (vectorToCompare - min(vectorToCompare))./(max(vectorToCompare) - min(vectorToCompare));

    rollmatrix = zeros(size(vectorExemplary,2),size(vectorExemplary,2));

    for i = 1:size(vectorExemplary,2)
        putonbeginningindex = 1;
        for j = 1:size(vectorExemplary,2)

            if j+i-1 <= size(vectorExemplary,2)
            rollmatrix(i,j+i-1) = vectorToCompare(j);
            else
            rollmatrix(i,putonbeginningindex) = vectorToCompare(j);  
            putonbeginningindex = putonbeginningindex + 1;
            end
        end
    end
    sumsvector = zeros(1,size(vectorExemplary,2));
    for i = 1:size(vectorExemplary,2)
        for j = 1:size(vectorExemplary,2)
           sumsvector(i) = sumsvector(i) + (rollmatrix(i,j) - vectorExemplary(j))^2;
        end
    end
end

