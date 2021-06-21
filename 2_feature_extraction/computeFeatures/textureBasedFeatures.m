function [tbfVec, namesVec] = textureBasedFeatures(image, lesionMask, lesionCrop, dermisMask, dermisCrop)
% computation of first-order textural features
% inputs:
%     image: ultrasound image
%     lesionMask: lesion mask, binary mask of lesion
%     lesionCrop: lesion crop
%     dermisMask: dermis mask, binary mask of the dermis
%     dermisCrop: dermis crop
% outputs:
%     tbfVec: texture-based features' vector
%     namesVec: texture-based feature names


tbfVec = [];        % texture-based feature vector
namesVec = {};      % vector of feature names

% attenuation features
[af, namesAF] = attenuationFeatures(lesionCrop,dermisCrop);
% contrast-based features.
[cF, namesCF] = contrastFeatures(image, lesionMask);
% boundary-based features
[bF, namesBF] = boundaryFeatures(image, lesionMask, lesionCrop, dermisCrop, dermisMask, 15);
% skewness
skewnessLesion = skewness(lesionCrop(:));
% kurtosis
kurtosisLesion = kurtosis(lesionCrop(:));
% entropy
extNaN = lesionCrop(:);
extNaN(isnan(extNaN)) = [];
entropyLesion = entropy(extNaN);

% outputs
tbfVec = [tbfVec; af; cF; bF; skewnessLesion; kurtosisLesion; entropyLesion];
namesVec = [namesVec namesAF namesCF namesBF 'skewnessLesion' 'kurtosisLesion' 'entropyLesion'];