function [af, names] = attenuationFeatures(lesionCrop,dermisCrop)

names = {};
% Attenuation --1 %%%   %%%   %%%   %%%   %%%   %%%
af = nanmean(lesionCrop(:))/nanmean(dermisCrop(:));
names(end+1) = {'attenuation'};
% Attenuation contrast --2 %%%   %%%   %%%   %%%   %%%   %%%
af=[af; (nanmean(dermisCrop(:))-nanmean(lesionCrop(:)))/nanmean(dermisCrop(:))];
names(end+1) = {'attenuationContrast'};
% Attenuation heterogeneity --3 %%%   %%%   %%%   %%%   %%%   %%%
af = [af; nanstd(lesionCrop(:))];
names(end+1) = {'attenuationHeterogeneity'};
