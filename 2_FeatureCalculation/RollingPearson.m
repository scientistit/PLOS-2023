
function [sumsvector] = RollingPearson(vectorExemplary,vectorToCompare)
    % vectorExemplary = [1,2,3,4,5,6];
    % vectorToCompare = [1,2,3,4,5,6];
    
    % Normalize both vectors

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
           mat = corrcoef(rollmatrix(i,:),vectorExemplary);
           sumsvector(i) = mat(1,2);
    end
end

