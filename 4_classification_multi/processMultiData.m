%% Multi-Class SVM
% preprocess all feature data for multi-class classification
clc
clear all
close all


groupNum = 10;
AUCs = zeros(groupNum, 1);


addpath("folds")
% nevus, melanoma, bcc
outputParams = {};
processedMultiData = {};
ROCxs=[];    ROCys=[];    ROCzs=[];    AUCs=[];
TPs = [];    TNs=[];    FPs=[];    FNs=[];
Ps = [];    Ns = [];    ACCs = [];    F1scores = [];
for i=1:groupNum

    load(['folds/train_group_',num2str(i),'.mat'])
    load(['folds/test_group_',num2str(i),'.mat'])


    classes = {0,1,2};     % nevus, melanoma, bcc
    %classes = binaryVariations{1,k};

    Class_N = classes{1};
    Class_M = classes{2};
    Class_B = classes{3};

    % training samples
    trainingSamples = [];
    trainingLabels = [];
    if(Class_N>=0)
        trainingSamples = [trainingSamples, fv_Train.N];
        labelsN = zeros(size(fv_Train.N,2),1)+classes{1};
        trainingLabels = [trainingLabels; labelsN];
    end

    if(Class_M>=0)
        trainingSamples = [trainingSamples, fv_Train.M];
        labelsM = zeros(size(fv_Train.M,2),1)+classes{2};
        trainingLabels = [trainingLabels; labelsM];
    end

    if(Class_B>=0)
        trainingSamples = [trainingSamples, fv_Train.B];
        labelsB = zeros(size(fv_Train.B,2),1)+classes{3};
        trainingLabels = [trainingLabels; labelsB];
    end
    trainingSamples = trainingSamples';

    % testing samples
    testingSamples = [];
    testingLabels = [];
    if(Class_N>=0)
        testingSamples = [testingSamples, fv_Test.N];
        labelsN = zeros(size(fv_Test.N,2),1)+classes{1};
        testingLabels = [testingLabels; labelsN];
    end

    if(Class_M>=0)
        testingSamples = [testingSamples, fv_Test.M];
        labelsM = zeros(size(fv_Test.M,2),1)+classes{2};
        testingLabels = [testingLabels; labelsM];
    end

    if(Class_B>=0)
        testingSamples = [testingSamples, fv_Test.B];
        labelsB = zeros(size(fv_Test.B,2),1)+classes{3};
        testingLabels = [testingLabels; labelsB];
    end
    testingSamples = testingSamples';
    
    
    processedMultiData{i}.trainingSamples = trainingSamples;
    processedMultiData{i}.trainingLabels = trainingLabels;
    processedMultiData{i}.testingSamples = testingSamples;
    processedMultiData{i}.testingLabels = testingLabels;

%     % true labels
%     trueLabels = {};
%     if max(testingLabels)==1
%         for j = 1:length(testingLabels)
%             if(testingLabels(j) == 1)
%                 trueLabels{end+1} = 'Selected';
%             else
%                 trueLabels{end+1} = 'Other';
%             end
%         end
%     end
%     %% number of samples and Class initialization
%     % nOfSamples=100;
%     % nOfClassInstance=3;
%     % Sample=rand(nOfSamples,60);
%     % class=round(rand(nOfSamples,1)*(nOfClassInstance-1));
%     %% SVM Classification
%     Model=svm.train(trainingSamples,trainingLabels);
%     [predict scores]=svm.predictMain(Model,testingSamples);
%     % [Model,predict] = svm.classify(Sample,class,Sample);
% 
%     %% Measure Performance
% 
%     [ROCx,ROCy,ROCt,AUC] = perfcurve(trueLabels, scores,'Selected');
%     TP=0; TN=0; FP=0;FN=0;
%     for l=1:length(testingLabels)
%         if(testingLabels(l) == 1)  % positive
%             if(predict(l) == 1)
%                 TP=TP+1;        % 1, 1 true positive
%             elseif(predict(l) == 0)
%                 FN=FN+1;        % 1, 0 false negative
%             end
%         elseif(testingLabels(l) == 0)% negative
%             if(predict(l) == 1)
%                 FP = FP+1;      % 0, 1 false positve
%             elseif(predict(l) == 0)
%                 TN = TN+1;      % 0, 0 true negative
%             end
%         end
%     end
%    
%     P  = TP+FN;
%     N  = TN+FP;
%     ACC = (TP+TN)/(P+N);
%     F1score = (2*TP) /(2*TP + FP + FN);    
%     
%     ROCxs(i,:) = ROCx;    ROCys(i,:) = ROCy;    ROCzs(i,:) = ROCt;    AUCs(i,:) = AUC;
%     TPs(i) = TP;    TNs(i) = TN;    FPs(i) = FP;    FNs(i) = FN;
%     Ps(i) = P;    Ns(i) = N;    ACCs(i) = ACC;    F1scores(i) = F1score;
%     
%     
end

% outputParams{end+1}.ROCxs = ROCxs;
% outputParams{end}.ROCys = ROCys;
% outputParams{end}.ROCzs = ROCzs;
% outputParams{end}.AUCs = AUCs;
% outputParams{end}.TPs = TPs;
% outputParams{end}.TNs = TNs;
% outputParams{end}.FPs = FPs;
% outputParams{end}.FNs = FNs;
% outputParams{end}.Ps = Ps;
% outputParams{end}.Ns = Ns;
% outputParams{end}.ACCs = ACCs;
% outputParams{end}.F1scores = F1scores;
% outputParams{end}.class = binaryVariations{2, k};

%mean(AUCs)
%disp([binaryVariations{2, k},' meanAUC: ',  num2str(mean(AUCs))])

%outputParamsMulti = outputParams;
%save outputParamsMulti outputParamsMulti


save processedMultiData processedMultiData