function [chunkNumberMatrix] = CrossValidation(numbers,howManyGroups)

    howManyNumbers = size(numbers,2);
    shuffledNumbers = randperm(howManyNumbers);

    howManyInAGroup = howManyNumbers/howManyGroups;

    howManyAdditional = howManyNumbers - (floor(howManyInAGroup) * howManyGroups);

    chunkElement = 1;
    chunkNumber = 1;

    if howManyAdditional ~= 0
        chunkNumberMatrix = zeros(howManyGroups,floor(howManyInAGroup) + 1);
    else
        chunkNumberMatrix = zeros(howManyGroups,howManyInAGroup);
    end


    for i = 1 : howManyNumbers

            if howManyAdditional > 0
                if chunkElement > howManyInAGroup + 1
                    chunkNumber = chunkNumber + 1;
                    chunkElement = 1;
                    howManyAdditional = howManyAdditional - 1;
                end
            else
                if chunkElement > howManyInAGroup
                    chunkNumber = chunkNumber + 1;
                    chunkElement = 1;
                end
            end

            chunkNumberMatrix(chunkNumber,chunkElement) = shuffledNumbers(i);

        chunkElement = chunkElement + 1;
    end

    chunkNumberMatrix
end
