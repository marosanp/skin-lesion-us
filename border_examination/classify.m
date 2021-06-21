clear all;
close all;
clc

addpath('../2_feature_extraction/computeFeatures')
addpath('../3_classification_binary')
fullPath = which(mfilename);
workDirFolder = [ fullPath(1:find(fullPath == '\',1,'last' )) ];
addpath(genpath(workDirFolder));

%%  data processing
wannadopreproc = 1;
if wannadopreproc == 1
    
    imageNum = 278;
    %folder = 'borderMasks_diamond';
    %folder = 'borderMasks_rect_2_2';
    %folder = 'borderMasks_rect_2_1';
    folder = 'borderMasks_rect_1_2';
    
    load([folder, '/image.mat'])
    load([folder, '/lesionMasks.mat'])    
    load([folder, '/dermisMask.mat'])

    images = {};
    dermisMasks = {};
    
    for i = 1:length(lesionMasks)
        disp(num2str(i))
        if sum(lesionMasks{i}(:))>0
            [lesionCrop{i},dermisCrop{i}] = preprocessSegmentedData(image, lesionMasks{i}, dermisMask);
            Keys(i) = "Nevus";
            images{i} = image;
            dermisMasks{i} = dermisMask;
        end
    end
    % WE HAVE THE LESION and DERMIS crops
    save([workDirFolder, 'FeatureExtractionInputs.mat'],'dermisCrop','lesionCrop','images', 'dermisMasks', 'lesionMasks', 'Keys');
else
    load([workDirFolder, 'FeatureExtractionInputs.mat']);
end


% GET FEATURES
FV = [];    % feature vector set

for i = 1:length(lesionCrop)
    if max(lesionCrop{i}(:)) >0
        disp([num2str(i),'/', num2str(length(lesionCrop))]);
        no = dermisCrop{i};     % dermisCrop
        ule = lesionCrop{i};    % lesionCrop
        % Crop lesion
        [row, col] = find(~isnan(ule));
        rectLes = [min(col), min(row), max(col)-min(col), max(row)-min(row)];
        ule = ule(rectLes(2):rectLes(2)+rectLes(4),...
            rectLes(1):rectLes(1)+rectLes(3));
        % Crop dermis 
        [row, col] = find(~isnan(no));
        rectDermis = [min(col), min(row), max(col)-min(col), max(row)-min(row)];
        no = no(rectDermis(2):rectDermis(2)+rectDermis(4),...
            rectDermis(1):rectDermis(1)+rectDermis(3));
        
        % WE HAVE THE CROPPED VERSION OF LESION AND DERMIS
        % FEATURE EXTRACTION
        [featureVector, nameVector] = getAllFeatures(images{i}, ule, no, lesionMasks{i}, dermisMasks{i});
        FV = [FV featureVector];
    end
end

testingSamples = FV';

%% SVM Classification
load('Model.mat');

[predict scores]=svm.predictMain(Model,testingSamples);       % predict, scores
predict'

zero_element  = zeros(size(image));
lesionMasks = horzcat(zero_element,lesionMasks);
%% DISPLAY RESULTS
% zoom in image
image_zoomed = image(60:108, 420:530);
classification_map = zeros([size(image_zoomed), 3]);
lesionMaskSlices = {};
new_scores = [];
counter=0;
for i = 1: length(lesionMasks)-1
    i
    if(sum(lesionMasks{i+1}(:))>0 && ~isempty(lesionMasks{i}) )
    
        lesionMaskZoomed = lesionMasks{i+1}(60:108, 420:530)-lesionMasks{i}(60:108, 420:530);
        lesionMaskSlices{end+1} = lesionMaskZoomed;

%         if predict(i-counter) == 0
%             lesionMaskSlice = cat(3,255*lesionMaskZoomed, lesionMaskZoomed, lesionMaskZoomed);
%         else
%             lesionMaskSlice = cat(3,lesionMaskZoomed, 255*lesionMaskZoomed, lesionMaskZoomed);
%         end
        
        if predict(i-counter) == 0
            lesionMaskSlice = cat(3,155*lesionMaskZoomed, 155*lesionMaskZoomed, 155*lesionMaskZoomed);
        else
            lesionMaskSlice = cat(3,255*lesionMaskZoomed, 255*lesionMaskZoomed, 255*lesionMaskZoomed);
        end

        classification_map = classification_map + lesionMaskSlice;
    else
        counter = counter+1;   % if there are empty cells! 
    end
end

lesionMasksZoomed = lesionMasks{1+11}(60:108, 420:530);
figure,
% subplot 211
% imshow(image_zoomed), hold on
% visboundaries(lesionMasksZoomed,'Color','w', 'LineWidth', 1), hold off
% subplot 212
imshow(uint8(classification_map)), hold on
visboundaries(lesionMasksZoomed,'Color','b', 'LineWidth', 2), hold off

