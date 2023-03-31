function FeatureSelectionAndClassRecognitionComputations(csvPath)  
javaaddpath('/Applications/R2019b.app/java/jar/weka.jar');
    
% One can comment out this hardcoded path and apply his own path to the 
% feature set in the parameter

csvPath = '../FeatureTables/AllGeometricAndDispersionFeaturesNorm.csv';
T = readtable(csvPath);

%Choose combinations of bacteria genera you would like to compare
%As we have 5 bacteria genera these are all available combinations:

%   combinations = [1,2,0,0,0;
%                   0,2,3,0,0;
%                   1,0,3,0,0;
%                   0,0,3,4,0;
%                   0,2,0,4,0;
%                   0,0,0,4,5;
%                   1,0,0,4,0;
%                   1,0,0,0,5;
%                   0,2,0,0,5;
%                   0,0,3,0,5;
%                   1,2,3,0,0;
%                   0,2,3,4,0;
%                   0,0,3,4,5;
%                   1,0,3,4,0;
%                   1,0,0,4,5;
%                   0,2,0,4,5;
%                   1,2,0,0,5;
%                   1,0,3,0,5;
%                   1,2,3,4,0;
%                   0,2,3,4,5;
%                   1,0,3,4,5;
%                   1,2,0,4,5;
%                   1,2,3,0,5;
%                   1,2,3,4,5];


% You can uncomment all possible combinations of four out of five bacteria
% genera
%    combinations = [ 1,2,3,4,0;
%                     0,2,3,4,5;
%                     1,0,3,4,5;
%                     1,2,0,4,5;
%                     1,2,3,0,5];

  % One combination - all five bacteria genera
  combinations = [1,2,3,4,5];
  
  %Image number
  number = table2array(T(:,1));
  
  %Number of the bacteria genera
  classNumber = table2array(T(:,2));
  
  %Name of the bacteria genera
  className = table2array(T(:,3));
  
  %Number of the microscopic image (inside current bacteria genera)
  numberInClass = table2array(T(:,4));
  
  %Features
  allFeatures = table2array(T(:,5:end)); 
  
  results = zeros(size(combinations,1),5);
  results(:,1) = linspace(1,size(combinations,1),size(combinations,1));
  
  %Go through all combinations that you are to compare
  for c = 1:size(combinations,1)

      %Select one combination
      theseCombinations = nonzeros(combinations(c,:));
      
      %I choose elements from feature matrix that correspond to the
      %selected elements in a current combination
      
      comparednumber = [];
      comparedClassNumber = [];
      comparedclassName = [];
      comparedallFeatures = [];
      comparedallFeaturesNormalized = [];
      selectedFeatures = [];
      
      %Select features that belong to the combination 
      
      for e = 1:size(theseCombinations,1)
          tmpnumber = number(classNumber == theseCombinations(e));
          tmpClassNumber = classNumber(classNumber == theseCombinations(e));
          tmpclassName = className(classNumber == theseCombinations(e));
          tmpallFeatures = allFeatures(classNumber == theseCombinations(e),:);
          
          comparednumber = [comparednumber;tmpnumber];
          comparedClassNumber = [comparedClassNumber;tmpClassNumber];
          comparedclassName = [comparedclassName;tmpclassName];
          comparedallFeatures = [comparedallFeatures;tmpallFeatures];
      end
      
      uni = unique(comparedClassNumber);
      comparedclassNumber = zeros(1,size(comparedClassNumber,1));
      
      %Attatch new numbers of selected classes
      %For example when we analyze class 2,4,5 the corresponding new class
      %numbers will be: 1, 2, 3. This helps put everything in order.
      
      for u = 1:size(comparedClassNumber,1)
          for un = 1:size(uni,1)
              if comparedClassNumber(u) == uni(un)
                  comparedclassNumber(u) = un;
              end
          end     
      end

      comparednumber = linspace(1,size(comparednumber,1),size(comparednumber,1));

      % What corresponding classes are we analyzing        
      whatClasses = unique(comparedclassNumber);           

  
      %Normalize features
      for e = 1:size(comparedallFeatures,2)
           comparedallFeaturesNormalized(:,e) = normalize(comparedallFeatures(:,e), 'range', [-1 1]);
      end

      howManyClasses = size(unique(comparedclassNumber),2);


   %% Feature selection - with selected method
   % % To perform computations in this section you need to attach weka's
   % fspackage
       
%
%         [out] = fsFCBF(comparedallFeaturesNormalized,comparedclassNumber')
%         %[out] = fsSBMLR(comparedallFeaturesNormalized,comparedclassNumber')
%         %[out] = fsCFS(comparedallFeaturesNormalized,comparedclassNumber')
%         %[out] = fsInfoGain(comparedallFeaturesNormalized,comparedclassNumber')

%      out = out.fList
%       
%     %      out = linspace(1,32,32)
%     
%     chosenFeaturesString = "";
%     for o = 1:size(out,2)
%         chosenFeaturesString = chosenFeaturesString.append(num2str(out(o)),",");
%     end
%      
%     for i = 1:size(out,2)
%       selectedFeatures(:,i) = comparedallFeaturesNormalized(:,out(i));
%     end

  %% Feature Selection - Hardcoded
  % One can hardcode which variables should be used instead of using
  % feature selection algorithm
  
  % You can uncommend this section and replace it with FCBF section
  % Here all the 27 features are applied in the classification process

    out = linspace(1,27,27);
    chosenFeaturesString = "";
    
    for o = 1:size(out,2)
        chosenFeaturesString = chosenFeaturesString.append(num2str(out(o)),",");
    end
     
    for i = 1:size(out,2)
      selectedFeatures(:,i) = comparedallFeaturesNormalized(:,out(i));
    end

 %%

  accuracyInAllCrossVRandomForest = 0;
  accuracyInAllCrossVKNN = 0;
  accuracyInAllCrossVSVM = 0;
  accuracyInAllCrossVMLP = 0;
  
  howManyCrossVal = 50;
 %Performance of 'howManyCrossVal' different 10% crossvaidations
 for i = 1:howManyCrossVal 
     
    fprintf("Crossval number " + i);
    accuracyInAllTestsRandomForest = 0;
    accuracyInAllTestsKNN = 0;
    accuracyInAllTestsSVM = 0;
    accuracyInAllTestsMLP = 0;

    %Crossvalidation
    %I divide thee set into 10 equal groups (+/- one element)
    %One row is one grup in crossvalidation
    
    howManyGroups = 10;
    indexesMatrix = CrossValidation(comparednumber,howManyGroups);
    
    %Prepare empty confusion matrixes for all cross validations combined 
    %and amount of correctly assigned images 
    
    howManyCorrectInAllTestsRandomForest = 0;
    confusionMatrixSumUpRandomForest = zeros(howManyClasses,howManyClasses);

    howManyCorrectInAllTestsKNN = 0;
    confusionMatrixSumUpKNN = zeros(howManyClasses,howManyClasses);

    howManyCorrectInAllTestsSVM = 0;
    confusionMatrixSumUpSVM = zeros(howManyClasses,howManyClasses);
    
    howManyCorrectInAllTestsMLP = 0;
    confusionMatrixSumUpMLP = zeros(howManyClasses,howManyClasses);
    
    %Divide matrix into teaching and testing groups.
    
    teachFeatures = [];
    teachClasses = [];
    
    %Go through every combination of 9/10 teaching and 1/10 testing groups
    for idm = 1:howManyGroups
       
        
        %Select test group (1/10)
        testgroup = indexesMatrix(idm,:);
        testgroup = nonzeros(testgroup);

        whatValuesInTest = zeros(howManyClasses,1);
        testClasses = zeros(1,size(testgroup,1));
        testFeatures = zeros(size(testgroup,1),size(selectedFeatures,2));
        
        %Check what features correspond to current test group
        %Chcek what classes do the test group elements belong to
        
        for tst = 1:size(testgroup,1)
            whatValuesInTest(comparedclassNumber(testgroup(tst))) = comparedclassNumber(testgroup(tst));
            testClasses(tst) = comparedclassNumber(testgroup(tst));
            testFeatures(tst,:) = selectedFeatures(testgroup(tst),:);
        end
        
        %Select teach group (9/10) - images that are left
        
        teachgroup = reshape(indexesMatrix,1,size(indexesMatrix,1) * size(indexesMatrix,2));
        teachgroup = setdiff(teachgroup,testgroup);
        teachgroup = nonzeros(teachgroup);

        whatValuesInTeach = zeros(howManyClasses,1);
        
        %Check what features correspond to current teach group
        %Chcek what classes do the teach group elements belong to
        
        for tch = 1:size(teachgroup,1)
            teachClasses(tch) = comparedclassNumber(teachgroup(tch));
            teachFeatures(tch,:) = selectedFeatures(teachgroup(tch),:);
            whatValuesInTeach(comparedclassNumber(teachgroup(tch))) = comparedclassNumber(teachgroup(tch));
        end


         %% SVM

    %       SVMModel = fitcsvm(teachFeatures,teachClasses,'KernelFunction','rbf','OptimizeHyperparameters','auto',...
    %        'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    %        'expected-improvement-plus','ShowPlots',true)); 

    %       SVMModel = fitcsvm(teachFeatures,teachClasses,'KernelScale','auto','Standardize',true,...
    %      'OutlierFraction',0.05);

        %Multi-class Support Vector Machines

        t = templateSVM('SaveSupportVectors',true);
        MdlSV = fitcecoc(teachFeatures,teachClasses,'Learners',t);
        isLoss = resubLoss(MdlSV);

        (predict(MdlSV, testFeatures) == testClasses');
        howManyCorrectInOneTestSVM = sum(predict(MdlSV, testFeatures) == testClasses');
        howManyCorrectInAllTestsSVM = howManyCorrectInAllTestsSVM + howManyCorrectInOneTestSVM;
        predictionsSVM = predict(MdlSV, testFeatures);

        %% Random Forest Of Decision Trees

        nTrees = 200;%200
        B = TreeBagger(nTrees,teachFeatures,teachClasses, 'Method', 'classification'); 
        predictionsRandomForest = B.predict(testFeatures);  % Predictions is a char though. We want it to be a number.
        predictionsRandomForest = str2double(predictionsRandomForest);
        howManyCorrectInOneTestRandomForest = sum(predictionsRandomForest'==testClasses);
        howManyCorrectInAllTestsRandomForest = howManyCorrectInAllTestsRandomForest + howManyCorrectInOneTestRandomForest;

        %% KNN - K- nearest neighbourhood

        k = 1;%1

        %For every testing sample
        predictionsKNN = zeros(1,size(testFeatures,1));
        distance = [];
        for a = 1:size(testFeatures,1)
            % With every training sample
            for j = 1:size(teachFeatures,1)
                %We calculate euclidean distance for all features
                distance(j,1) = 0;
                for g = 1:size(testFeatures,2)
                    %Distance
                    distance(j,1) = distance(j,1) + (testFeatures(a,g) - teachFeatures(j,g))^2;
                    %Compared class number
                    distance(j,2) = teachClasses(j);
                end
            end
            
            %We sort all values and choose k-nearest neighbors
            distance;
            E = sortrows(distance,1);
            classes = E(:,2);
            kclasses = classes(1:k);
            predictionsKNN(a) = mode(kclasses);
        end
          howManyCorrectInOneTestKNN = sum(predictionsKNN==testClasses);
          howManyCorrectInAllTestsKNN = howManyCorrectInAllTestsKNN + howManyCorrectInOneTestKNN;

        %% BackPropagation
        
        selectedClassNumber = zeros(1,size(testFeatures,1));
        net = feedforwardnet([15,15,15]);% [15,15,15]
        net.trainParam.showWindow = 0;
        [net,~] = train(net,teachFeatures',teachClasses);
        
        predictionsMLP = net(testFeatures');
        for p = 1:size(predictionsMLP,2)
            min = 1000;
            selectedClassNumber(p) = whatClasses(1);
            for a = 1:size(whatClasses,2)
                distanceMLP = whatClasses(a) - predictionsMLP(p);
                if abs(distanceMLP) < abs(min)
                  selectedClassNumber(p) = whatClasses(a);
                  min = abs(distanceMLP);
                end
            end
        end

        predictionsMLP = selectedClassNumber;
        howManyCorrectInOneTestMLP = sum(predictionsMLP==testClasses);
        howManyCorrectInAllTestsMLP = howManyCorrectInAllTestsMLP + howManyCorrectInOneTestMLP;

        %% Confusion Matrixes
        
        %Prepare empty confusion matrixes for every single method for one crossvalidation, 

        confusionMatrixRandomForest = zeros(howManyClasses,howManyClasses);
        confusionMatrixKNN = zeros(howManyClasses,howManyClasses);
        confusionMatrixSVM = zeros(howManyClasses,howManyClasses);
        confusionMatrixMLP = zeros(howManyClasses,howManyClasses);

        %Fill matrixes with values

         for j = 1:size(testClasses,2)
             confusionMatrixRandomForest(predictionsRandomForest(j),testClasses(j)) = confusionMatrixRandomForest(predictionsRandomForest(j),testClasses(j)) + 1;
         end

         confusionMatrixSumUpRandomForest = confusionMatrixSumUpRandomForest + confusionMatrixRandomForest;
         confusionMatrixPrettyRandomForest = ConfusionMatrixTableWithLabels(confusionMatrixRandomForest);

         for j = 1:size(testClasses,2)
             confusionMatrixKNN(predictionsKNN(j),testClasses(j)) = confusionMatrixKNN(predictionsKNN(j),testClasses(j)) + 1;
         end

         confusionMatrixSumUpKNN = confusionMatrixSumUpKNN + confusionMatrixKNN;
         confusionMatrixPrettyKNN = ConfusionMatrixTableWithLabels(confusionMatrixKNN);

         for j = 1:size(testClasses,2)
             confusionMatrixSVM(predictionsSVM(j),testClasses(j)) = confusionMatrixSVM(predictionsSVM(j),testClasses(j)) + 1;
         end

         confusionMatrixSumUpSVM = confusionMatrixSumUpSVM + confusionMatrixSVM;
         confusionMatrixPrettySVM = ConfusionMatrixTableWithLabels(confusionMatrixSVM);

         for j = 1:size(testClasses,2)
             confusionMatrixMLP(predictionsMLP(j),testClasses(j)) = confusionMatrixMLP(predictionsMLP(j),testClasses(j)) + 1;
         end

         confusionMatrixSumUpMLP = confusionMatrixSumUpMLP + confusionMatrixMLP;
         confusionMatrixPrettyMLP = ConfusionMatrixTableWithLabels(confusionMatrixMLP);


        % If one or two of classes dont appear in teaching or testing group
        % we could write code to shuffle values again, but for now we
        % shuffle images only once without testing whether it occurs

%         if any(whatValuesInTest<1)
%             "Lack of a class in test";
%         end
%         if any(whatValuesInTeach<1)
%             "Lack of a class in teach";
%         end


    end

    %Accuracy in All Tests in one crossvalidation for Random Forest
    accuracyInAllTestsRandomForest = (howManyCorrectInAllTestsRandomForest/size(comparednumber,2)) * 100
    confusionMatrixSumUpPrettyRandomForest = ConfusionMatrixTableWithLabels(confusionMatrixSumUpRandomForest)

    %Accuracy in All Tests in one crossvalidation for KNN
    accuracyInAllTestsKNN = (howManyCorrectInAllTestsKNN/size(comparednumber,2)) * 100
    confusionMatrixSumUpPrettyKNN = ConfusionMatrixTableWithLabels(confusionMatrixSumUpKNN)

    %Accuracy in All Tests in one crossvalidation for SVM
    accuracyInAllTestsSVM = (howManyCorrectInAllTestsSVM/size(comparednumber,2)) * 100
    confusionMatrixSumUpPrettySVM = ConfusionMatrixTableWithLabels(confusionMatrixSumUpSVM)
    
    %Accuracy in All Tests in one crossvalidation for SVM
    accuracyInAllTestsMLP = (howManyCorrectInAllTestsMLP/size(comparednumber,2)) * 100
    confusionMatrixSumUpPrettyMLP = ConfusionMatrixTableWithLabels(confusionMatrixSumUpMLP)

    %Accuracy in 10 CrossValidations

    accuracyInAllCrossVRandomForest = accuracyInAllCrossVRandomForest + accuracyInAllTestsRandomForest;
    accuracyInAllCrossVKNN = accuracyInAllCrossVKNN + accuracyInAllTestsKNN;
    accuracyInAllCrossVSVM = accuracyInAllCrossVSVM + accuracyInAllTestsSVM;
    accuracyInAllCrossVMLP = accuracyInAllCrossVMLP + accuracyInAllTestsMLP;
end

    accuracyInAllCrossVRandomForest = accuracyInAllCrossVRandomForest/howManyCrossVal;
    accuracyInAllCrossVKNN = accuracyInAllCrossVKNN/howManyCrossVal;
    accuracyInAllCrossVSVM = accuracyInAllCrossVSVM/howManyCrossVal;
    accuracyInAllCrossVMLP = accuracyInAllCrossVMLP/howManyCrossVal;

    chosenFeatures(c) = chosenFeaturesString;
    results(c,3) = accuracyInAllCrossVRandomForest;
    results(c,4) = accuracyInAllCrossVKNN;
    results(c,2) = accuracyInAllCrossVSVM;
    results(c,5) = accuracyInAllCrossVMLP;

  end

%Place results into table and save them into csv file
finalArray = [chosenFeatures',results];

tab = array2table(finalArray,'VariableNames',{'Chosen Features' 'Combination', 'SVM','RandomForest','KNN','MLP'});  
tab
writetable(tab,"RezultsAllShapeandDispersionFeatures.csv");

end


