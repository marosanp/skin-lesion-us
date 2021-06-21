clear all
close all
clc

load('processedMultiData.mat')
% binary input for multi-class classification (nevus vs mela, nevus vs bcc, bcc vs mela)
% always comment out the unnecessary parts
results = [];
c_matrices = [];
for groupInx = 1:size(processedMultiData, 2)
    
    trainingLabels = processedMultiData{groupInx}.trainingLabels;
    trainingSamples = processedMultiData{groupInx}.trainingSamples;
    
    % Nevus vs MELA
    testingLabels = processedMultiData{groupInx}.testingLabels(processedMultiData{groupInx}.testingLabels~=2);
    testingSamples = processedMultiData{groupInx}.testingSamples(processedMultiData{groupInx}.testingLabels~=2, :);
    
    % Nevus vs BCC
    %testingLabels = processedMultiData{groupInx}.testingLabels(processedMultiData{groupInx}.testingLabels~=1);
    %testingSamples = processedMultiData{groupInx}.testingSamples(processedMultiData{groupInx}.testingLabels~=1, :);
    
    % BCC vs MELA
    %testingLabels = processedMultiData{groupInx}.testingLabels(processedMultiData{groupInx}.testingLabels~=0);
    %testingSamples = processedMultiData{groupInx}.testingSamples(processedMultiData{groupInx}.testingLabels~=0, :);
    
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
    
    %% TO CHECK
    if(length(c_matrix ==2))
        tmp = c_matrix;
        c_matrix = zeros(3);
        
        % BCC vs MELA
        c_matrix(2,2) = tmp(1,1);
        c_matrix(2,3) = tmp(1,2);
        c_matrix(3,2) = tmp(2,1);
        c_matrix(3,3) = tmp(2,2);
        
        % NEVUS vs BCC
        c_matrix(1,1) = tmp(1,1);
        c_matrix(1,3) = tmp(1,2);
        c_matrix(3,1) = tmp(2,1);
        c_matrix(3,3) = tmp(2,2);
    end
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

results_Nevus_MELA = results;
c_matrices_Nevus_MELA = c_matrices;
save results_Nevus_MELA results_Nevus_MELA
save c_matrices_Nevus_MELA c_matrices_Nevus_MELA

% results_Nevus_BCC = results;
% c_matrices_Nevus_BCC = c_matrices;
% save results_Nevus_BCC results_Nevus_BCC
% save c_matrices_Nevus_BCC c_matrices_Nevus_BCC

% results_BCC_MELA = results;
% c_matrices_BCC_MELA = c_matrices;
% save results_BCC_MELA results_BCC_MELA
% save c_matrices_BCC_MELA c_matrices_BCC_MELA


