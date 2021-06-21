clear all
close all
clc

% segmentation growing step - calculates final segmentation boundary
% based on the lesion seeds get from lesion detection
% inputs:
%     input ultrasound images
%     lesion seeds, previosuly detected

% output:
%     final lesion boundaries

% (freehand-based seeding - Ground Truth like masks)


load('images.mat')                  % ultrasound images
load('lesionSeed_FA.mat')           % lesion seeds FA
load('lesionMasks_freehand.mat')    % GT-like freehand masks


FA_ACM_masks = {};
FA_ACM_dices = [];
times = [];
for i = 1:length(images)
    disp(i)
    
    image = images{i};
    BW = lesionSeed_FA{i};
    GT = lesionMasks_freehand{i};
    %D = computeDice(BW, GT);
    %FA_ACM_dices(1, i) = D;
    %FA_ACM_masks{1, i} = BW;
    
    
    % active contour model
    smoothFactor = 0.7;         % smoothing parameter
    contractionBias = -0.29;    % contraction bias
    for j = 1:4
        BW = activecontour(image, BW, 25, 'edge',...
            'SmoothFactor',smoothFactor, 'ContractionBias',contractionBias);
        
        %FA_ACM_dices(j+1, i) = D;
        %FA_ACM_masks{j+1, i} = BW;
    end
    D = computeDice(BW, GT);
    FA_ACM_dices(i) = D;
    FA_ACM_masks{i} = BW;
end

%save FA_ACM_dices FA_ACM_dices
%save('FA_ACM_masks.mat', 'FA_ACM_masks', '-v7.3')
