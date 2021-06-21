function [bF, names] = boundaryFeatures(image, lesionMask, lesionCrop, dermisCrop, dermisMask, sW)
% computation of boundary-based features
% inputs:
%     image: ultrasound image
%     lesionMask: lesion mask, binary mask of lesion
%     lesionCrop: lesion crop
%     dermisMask: dermis mask, binary mask of the dermis
%     dermisCrop: dermis crop
%     sW: boundarySize
% outputs:
%     bf: boundary-based features' vector
%     names: boundary-based feature names


names = {};

% get lesion boundary
[lesionBoundary, ~ ] = getLesionBoundary(image, lesionMask, dermisMask, sW);

% boundary-based functions
boundaryFeature1 = nanmean(lesionBoundary(:));
boundaryFeature2 = nanstd(lesionBoundary(:));
boundaryFeature3 = nanmean(lesionBoundary(:))/nanmean(lesionCrop(:));
boundaryFeature4 = nanstd(lesionBoundary(:))/nanstd(lesionCrop(:));
boundaryFeature5 = (nanmean(lesionBoundary(:))-nanmean(lesionCrop(:)))/nanmean(lesionBoundary(:));
boundaryFeature6 = (nanstd(dermisCrop(:))-nanstd(lesionCrop(:)))/nanstd(dermisCrop(:));
boundaryFeature7 = (nanstd(lesionBoundary(:))-nanstd(lesionCrop(:)))/nanstd(lesionBoundary(:));

% construct output
bF = [boundaryFeature1; boundaryFeature2; boundaryFeature3;...
    boundaryFeature4; boundaryFeature5; boundaryFeature6; boundaryFeature7];
names(end+1) = {'bf1'};
names(end+1) = {'bf2'};
names(end+1) = {'bf3'};
names(end+1) = {'bf4'};
names(end+1) = {'bf5'};
names(end+1) = {'bf6'};
names(end+1) = {'bf7'};