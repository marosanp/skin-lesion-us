clear all
close all
clc

% relative paths
addpath('computeFeatures')      % all functions related to feature extraction
fullPath = which(mfilename);
workDirFolder = fullPath(1:find(fullPath == '\',1,'last' ));
addpath(genpath(workDirFolder));

% labels {Nevus; BCC; MELA}
load('labels.mat')


%%  DATA PRE-PROCESSING
wannadopreproc = 1;
if wannadopreproc == 1
    % load data from inputData folder:
    % ultrasound images in cell array - grayscale images [0-255]
    load('images.mat')
    % lesion masks in cell array - binary images [0-1]
    load('lesionMasks.mat')
    % dermis masks in cell array - binary images [0-1]
    load('dermisMasks.mat')
    
    % select images
    which2use = 1:length(images);   % use all of them
    
    % select outbound rectangles
    for i = 1:length(which2use)
        disp(num2str(i));
        if which2use(i)>0
            % create lesion crop and dermis crop for all images
            [lesionCrop{i},dermisCrop{i}] = preprocessSegmentedData(images{i}, lesionMasks{i}, dermisMasks{i});
        end
    end
    % save all parameters required for feature extraction
    save([workDirFolder, 'FeatureExtractionInputs.mat'],...
        'which2use','dermisCrop','lesionCrop','images', 'dermisMasks', 'lesionMasks', 'labels');
else
    load([workDirFolder, 'FeatureExtractionInputs.mat']);
end


%% EXTRACT FEATURES
M = [];     % melanoma
B = [];     % basalioma
N = [];     % nevus
T = [];     % t


% images not to use - use all images
noToUse =[];
for i = 1:length(noToUse)
    which2use(noToUse(i)) = 0;
end
% feature extraction
for i = 1:length(lesionCrop)
    if which2use(i) >0
        disp([num2str(i),'/', num2str(length(lesionCrop))]);
        
        no = dermisCrop{i};     % dermisCrop
        ule = lesionCrop{i};    % lesionCrop
        
        % Crop lesion - zooming, keeping only the usefull rectangle
        [row, col] = find(~isnan(ule));
        rectLes = [min(col), min(row), max(col)-min(col), max(row)-min(row)];
        ule = ule(rectLes(2):rectLes(2)+rectLes(4),...
            rectLes(1):rectLes(1)+rectLes(3));
        
        % Crop dermis - zooming, keeping only the usefull rectangle
        [row, col] = find(~isnan(no));
        rectDermis = [min(col), min(row), max(col)-min(col), max(row)-min(row)];
        no = no(rectDermis(2):rectDermis(2)+rectDermis(4),...
            rectDermis(1):rectDermis(1)+rectDermis(3));
        
        %% get features
        [featureVector, nameVector] = getAllFeatures(images{i}, ule, no, lesionMasks{i}, dermisMasks{i});      
        featureVector = [featureVector; i]; %add index number to the end
        
        % separate feature vectors based on label
        if(~isempty(findstr(labels{i},'Nevus')))
            N = [N featureVector];
        elseif(~isempty(findstr(labels{i},'MELA')))
            M = [M featureVector];
        else
            B = [B featureVector];
        end
    end
end

feature_vectors.N = N;
feature_vectors.M = M;
feature_vectors.B = B;

save feature_vectors feature_vectors
