% Researchers should provide more details on 
% how slight differences in the borders led to different classification results as this is very important.


clear all
%close all
clc


load('input_data/image.mat')
load('input_data/dermisMask.mat')
load('input_data/lesionMask.mat')

%     figure, imagesc(image), hold on
%     visboundaries(lesionMask,'Color','r'), 
%     visboundaries(dermisMask,'Color','g'), hold off

%sum(lesionMask(:))

%SE = strel('diamond',1);
%se_type = 'diamond';

%SE = strel('disk',1,4);

%SE = strel('rectangle',[1 2]) 
%se_type = 'rect_1_2';

%SE = strel('rectangle',[2 1])
%se_type = 'rect_2_1';

SE = strel('rectangle',[2 2]);
se_type = 'rect_2_2';

%lesionMask2 = imdilate(lesionMask,SE);
%sum(lesionMask2(:))
%figure, imagesc(lesionMask2-lesionMask)

lesionMasks = {};

% current mask - always the 11th (10 smaller?, 10 bigger)
lesionMasks{11} = lesionMask;
%figure, imagesc(lesionMasks{11}), title(num2str(sum(lesionMasks{11}(:))))

% erode    TODO!!!! only one blob
counter = 1;
tmp = lesionMask;   % use tmp
while sum(tmp(:))>200
    if counter > 10 
       break; 
    end
    % erode
    tmp = imerode(tmp,SE);

    lesionMasks{11-counter} = tmp;
    %figure, imagesc(tmp), title(num2str(sum(tmp(:))))

    counter = counter+1;
end

% init tmp again
tmp = lesionMask;

% dilate
for i=1:10
    tmp = imdilate(tmp,SE);
    lesionMasks{11+i} = tmp;
    %figure, imagesc(tmp), title(num2str(sum(tmp(:))))
end

myFolder = ['borderMasks_',se_type];
if ~exist(myFolder, 'dir')
   mkdir(myFolder)
end

figure, imagesc(lesionMasks{11}), title(num2str(sum(lesionMasks{11}(:))))
save([myFolder ,'/lesionMasks.mat'],'lesionMasks');
save([myFolder ,'/dermisMask.mat'],'dermisMask');
save([myFolder ,'/image.mat'],'image');