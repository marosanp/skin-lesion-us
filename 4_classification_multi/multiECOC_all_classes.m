clear all
close all
clc

% compute confusion matrices for all classes
load('processedMultiData.mat')

results = [];
c_matrices = [];
for groupInx = 1:size(processedMultiData, 2)
    
    testingLabels = processedMultiData{groupInx}.testingLabels;
    trainingLabels = processedMultiData{groupInx}.trainingLabels;
    testingSamples = processedMultiData{groupInx}.testingSamples;
    trainingSamples = processedMultiData{groupInx}.trainingSamples;
    
    X = trainingSamples;
    Y = categorical(trainingLabels);
    classOrder = unique(Y);
    rng(1); % For reproducibility
    
    t = templateSVM('Standardize',true);
    %% first example
    Mdl = fitcecoc(X,Y,'Learners',t,'ClassNames',classOrder);
    XTest = testingSamples;
    YTest = categorical(testingLabels);
    
    
    %% second example
    % PMdl = fitcecoc(X,Y,'Holdout',0.30,'Learners',t,'ClassNames',classOrder);
    % Mdl = PMdl.Trained{1};           % Extract trained, compact classifier
    %
    %
    % testInds = test(PMdl.Partition);  % Extract the test indices
    % XTest = X(testInds,:);
    % YTest = Y(testInds,:);
    labels = predict(Mdl,XTest);
    
    % idx = randsample(sum(testInds),10);
    % table(YTest(idx),labels(idx),...
    %     'VariableNames',{'TrueLabels','PredictedLabels'})
    
    % table(YTest,labels,'VariableNames',{'TrueLabels','PredictedLabels'})
    % cp = classperf(testingLabels,double(labels)-1);
    
    
    %% Multiclass demo
    disp('_____________Multiclass demo_______________')
    disp('Running Multiclass confusionmat')
    
    [c_matrix,Result,RefereceResult]= confusion.getMatrix(testingLabels,double(labels)-1);
    results.accuracy(groupInx) = Result.Accuracy;
    results.error(groupInx) = Result.Error;
    results.sensitivity(groupInx) = Result.Sensitivity;
    results.specificity(groupInx) = Result.Specificity;
    results.precision(groupInx) = Result.Precision;
    results.falsePositiveRate(groupInx) = Result.FalsePositiveRate;
    results.f1_score(groupInx) = Result.F1_score;
    results.matthewsCorrelationCoefficient(groupInx) = Result.MatthewsCorrelationCoefficient;
    results.kappa(groupInx) = Result.Kappa;
        
    c_matrices(:,:,groupInx) = c_matrix;
end
results.accuracy=results.accuracy';
results.error=results.error';
results.sensitivity=results.sensitivity';
results.specificity=results.specificity';
results.precision=results.precision';
results.falsePositiveRate=results.falsePositiveRate';
results.f1_score=results.f1_score';
results.matthewsCorrelationCoefficient=results.matthewsCorrelationCoefficient';
results.kappa=results.kappa';
    
resultsMulti = results;
save resultsMulti resultsMulti
c_matricesMulti = c_matrices;
save c_matricesMulti c_matricesMulti


