clear all
close all
clc

% input:
% 


load('feature_vectors.mat');

% optional: we can randomly swipe the columns of all 3 matrices

% number of folds
folds = 10;

% number of different lesions, used for classification training and testing
numN = 110;
numM = 70;
numB = 130;

feature_vectors.N = feature_vectors.N(:,1:numN); 
feature_vectors.M = feature_vectors.M(:,1:numM);
feature_vectors.B = feature_vectors.B(:,1:numB);


% add feature vectors to the folds 
for i = 0:folds-1
    %% nevus
    % test set
    iTestN = 1:folds:size(feature_vectors.N,2)-mod(size(feature_vectors.N,2),folds);
    iTestN=iTestN+i;
    %iTestN(iTestN>size(f1.N,2))=[];
    n=length(iTestN);
    fv_Test.N(:,1:n) = feature_vectors.N(1:end-1,iTestN);
    
    % train set
    fv_Train.N = feature_vectors.N(1:end-1,:);
    fv_Train.N(:,iTestN) = [];
    
    % image indices for latter use
    fv_Test.Nser = feature_vectors.N(end,iTestN);
    fv_Train.Nser = feature_vectors.N(end,:);
    fv_Train.Nser(:,iTestN) = [];
    
    %% melanoma
    % test set
    iTestM = 1:folds:size(feature_vectors.M,2)-mod(size(feature_vectors.M,2),folds);
    iTestM=iTestM+i;
    %iTestM(iTestM>size(f1.M,2))=[];
    n=length(iTestM);
    fv_Test.M(:,1:n) = feature_vectors.M(1:end-1,iTestM);
    
    % train set
    fv_Train.M = feature_vectors.M(1:end-1,:);
    fv_Train.M(:,iTestM) = [];
    
    % image indices for later use
    fv_Test.Mser = feature_vectors.M(end,iTestM);
    fv_Train.Mser = feature_vectors.M(end,:);
    fv_Train.Mser(:,iTestM) = [];
    
    %% BCCs
    % test set
    iTestB = 1:folds:size(feature_vectors.B,2)-mod(size(feature_vectors.B,2),folds);
    iTestB=iTestB+i;
    %iTestB(iTestB>size(f1.B,2))=[];
    n=length(iTestB);
    fv_Test.B(:,1:n) = feature_vectors.B(1:end-1,iTestB);
    
    % train set
    fv_Train.B = feature_vectors.B(1:end-1,:);
    fv_Train.B(:,iTestB) = [];
    
    % image indices for later use
    fv_Test.Bser = feature_vectors.B(end,iTestB);
    fv_Train.Bser = feature_vectors.B(end,:);
    fv_Train.Bser(:,iTestB) = [];
    
    
    % save folds
    folder = 'folds';
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    save(['folds\train_group_',num2str(i+1),'.mat'],'fv_Train');
    save(['folds\test_group_',num2str(i+1),'.mat'],'fv_Test');
    
end