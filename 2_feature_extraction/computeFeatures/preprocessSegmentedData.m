%-inputs of the function:
%   image: whole ultrasound image - if RF, log compressed envelope of the 
% signal is to be taken to get B-mode images similar to hitachi
%   lesionMask: binary mask of the segmented area of lesion
%   dermisMask: binary mask of the segmented area of dermis
%
%-outputs of the function:
%   lesionCrop: NaN out all image points except the lesion
%   dermisCrop: NaN out all image points except dermis under the lesion
%

function [lesionCrop,dermisCrop] = preprocessSegmentedData(image, lesionMask, dermisMask)
% normalize imag
dermisMask = double(dermisMask);
dermisMask = dermisMask./max(dermisMask(:));
image = double(image);
image = image./max(image(:));
%lesionMask = (lesionMask+dermisMask)==2;
lesionMask = double(lesionMask);
dermisMask(dermisMask==0) = NaN;

% generate outbounding rectangle around the lesion
[row, col] = find(lesionMask);
rectL = [min(col), min(row), max(col)-min(col), max(row)-min(row)]; %parameters of the rectangle; top left corner & size

% generate rectangle in the dermis under the lesion
if (2*max(row)-min(row)<=size(lesionMask, 1))
    rectD = [min(col), max(row), max(col)-min(col), max(row)-min(row)];
elseif (2*max(row)-min(row)>size(lesionMask, 1))
    rectD = [min(col), max(row), max(col)-min(col), size(lesionMask,1)-max(row) ];
end


dLesionMask = double(lesionMask);
dLesionMask(dLesionMask==0) = NaN;
lesionCrop = dLesionMask.*image;

dLesionMask = double(lesionMask);
leftedgeL = rectL(1);
rightedgeL = leftedgeL+rectL(3);

for j = leftedgeL:rightedgeL
    if ~isempty(find(dLesionMask(:,j),1,'last')+1)
        r(j) = find(dLesionMask(:,j),1,'last')+1;
    end
end

rectDArea = zeros(size(image));
for k = leftedgeL:rightedgeL
    rectDArea(r(k):rectD(2)+rectD(4), k) = 1;%?? -1
    
end

rectDArea(rectDArea==0) = NaN;
dermisCrop = image.*dermisMask.*rectDArea;

% visualize results
visRes = 0;
if visRes == 1
    MiklosFig(1);
    figure(x), imagesc(image), hold on, visboundaries(lesionMask, 'Color', 'r'), ...
        hold on, rectangle('Position',rectL, 'EdgeColor', 'b'),...
        hold on, rectangle('Position',rectD, 'EdgeColor', 'b'),... %visualize results
        hold on, visboundaries(dermisMask, 'Color', 'm');
end





