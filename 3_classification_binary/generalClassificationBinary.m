%% Multi-Class SVM
%% Demo Begin
%% Initialize all to default
clc
clear all
close all

groupNum = 10;
AUCs = zeros(groupNum, 1);
AUCs_final = {};
ACCs_final = {};
% nevus, melanoma, bcc
binaryVariations={{1,0,0},{0,1,0},{0,0,1}, {1,-1,0}, {1,0,-1}, {-1,1,0};
    'Nevus vs others', 'MELA vs others', 'BCC vs others', 'NEVUS vs BCC', 'NEVUS vs MELA', 'BCC vs MELA'};
outputParams = {};
processedBinaryData = {};

addpath('folds')
all_classification_results = {};
for k = 1:size(binaryVariations,2)
ROCxs=[];    ROCys=[];    ROCzs=[];    AUCs=[];
TPs = [];    TNs=[];    FPs=[];    FNs=[];
Ps = [];    Ns = [];    ACCs = [];    F1scores = [];
classification_temp = [];
for i=1:groupNum

    load(['folds/train_group_',num2str(i),'.mat'])
    load(['folds/test_group_',num2str(i),'.mat'])


    classes = {1,0,0};     % nevus, melanoma, bcc
    classes = binaryVariations{1,k};

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
    testingInxs = [];
    if(Class_N>=0)
        testingSamples = [testingSamples, fv_Test.N];
        labelsN = zeros(size(fv_Test.N,2),1)+classes{1};
        testingLabels = [testingLabels; labelsN];
        testingInxs = [testingInxs, fv_Test.Nser];
    end

    if(Class_M>=0)
        testingSamples = [testingSamples, fv_Test.M];
        labelsM = zeros(size(fv_Test.M,2),1)+classes{2};
        testingLabels = [testingLabels; labelsM];
        testingInxs = [testingInxs, fv_Test.Mser];
    end

    if(Class_B>=0)
        testingSamples = [testingSamples, fv_Test.B];
        labelsB = zeros(size(fv_Test.B,2),1)+classes{3};
        testingLabels = [testingLabels; labelsB];
        testingInxs = [testingInxs, fv_Test.Bser];
    end
    testingSamples = testingSamples';
    
    
    processedBinaryData{k,i}.trainingSamples = trainingSamples;
    processedBinaryData{k,i}.trainingLabels = trainingLabels;
    processedBinaryData{k,i}.testingSamples = testingSamples;
    processedBinaryData{k,i}.testingLabels = testingLabels;

    % true labels
    trueLabels = {};
    if max(testingLabels)==1
        for j = 1:length(testingLabels)
            if(testingLabels(j) == 1)
                trueLabels{end+1} = 'Selected';
            else
                trueLabels{end+1} = 'Other';
            end
        end
    end
    %% number of samples and Class initialization
    % nOfSamples=100;
    % nOfClassInstance=3;
    % Sample=rand(nOfSamples,60);
    % class=round(rand(nOfSamples,1)*(nOfClassInstance-1));
    %% SVM Classification
    Model=svm.train(trainingSamples,trainingLabels);
    [predict scores]=svm.predictMain(Model,testingSamples);
    % [Model,predict] = svm.classify(Sample,class,Sample);
    
    classification_temp = [classification_temp;testingInxs',testingLabels, predict];

    %% Measure Performance

    [ROCx,ROCy,ROCt,AUC] = perfcurve(trueLabels, scores,'Selected');
    TP=0; TN=0; FP=0;FN=0;
    for l=1:length(testingLabels)
        if(testingLabels(l) == 1)  % positive
            if(predict(l) == 1)
                TP=TP+1;        % 1, 1 true positive
            elseif(predict(l) == 0)
                FN=FN+1;        % 1, 0 false negative
            end
        elseif(testingLabels(l) == 0)% negative
            if(predict(l) == 1)
                FP = FP+1;      % 0, 1 false positve
            elseif(predict(l) == 0)
                TN = TN+1;      % 0, 0 true negative
            end
        end
    end
   
    P  = TP+FN;
    N  = TN+FP;
    ACC = (TP+TN)/(P+N);
    F1score = (2*TP) /(2*TP + FP + FN);    
    
    % TODO examine this code!!!
%     while(length(ROCx)) < 32
%         ROCx = [ROCx; ROCx(end)];
%         ROCy = [ROCy; ROCy(end)];
%         ROCt = [ROCt; ROCt(end)];
%     end
    
    
    ROCxs{end+1} = ROCx;
    ROCys{end+1} = ROCy;
    ROCzs{end+1} = ROCt;
    AUCs(i,:) = AUC;
    TPs(i) = TP;    TNs(i) = TN;    FPs(i) = FP;    FNs(i) = FN;
    Ps(i) = P;    Ns(i) = N;    ACCs(i) = ACC;    F1scores(i) = F1score;
    
end

outputParams{end+1}.ROCxs = ROCxs;
outputParams{end}.ROCys = ROCys;
outputParams{end}.ROCzs = ROCzs;
outputParams{end}.AUCs = AUCs;
outputParams{end}.TPs = TPs;
outputParams{end}.TNs = TNs;
outputParams{end}.FPs = FPs;
outputParams{end}.FNs = FNs;
outputParams{end}.Ps = Ps;
outputParams{end}.Ns = Ns;
outputParams{end}.ACCs = ACCs;
outputParams{end}.F1scores = F1scores;
outputParams{end}.class = binaryVariations{2, k};

%mean(AUCs)
disp([binaryVariations{2, k},' meanAUC: ',  num2str(mean(AUCs))])
all_classification_results{end+1} = classification_temp;
AUCs_final{k} = mean(AUCs);
ACCs_final{k} = mean(ACCs);

end
save outputParams outputParams
save processedBinaryData processedBinaryData
save all_classification_results all_classification_results

save AUCs AUCs
save ACCs ACCs