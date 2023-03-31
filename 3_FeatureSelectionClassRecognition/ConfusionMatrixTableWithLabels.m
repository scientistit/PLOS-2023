function [confusionMatrixTable] = ConfusionMatrixTableWithLabels(confusionMatrix)

    dimension = size(confusionMatrix,2);
    for i = 1:dimension
        VariableNames(i) = "Actual " + i;
        RowNames(i) = "Predicted " + i;
    end

    confusionMatrixTable = array2table(confusionMatrix,...
          'VariableNames',VariableNames,...
          'RowNames',RowNames);

end