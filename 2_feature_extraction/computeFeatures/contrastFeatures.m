function [cf, names] = contrastFeatures(image, lesionMask)
% computation of contrast-based features
% inputs:
%     image: ultrasound image
%     lesionMask: lesion mask, binary mask of lesion
% outputs:
%     cf: contrast-based features' vector
%     names: contrast-based feature names

names = {};

s = getContrast(lesionMask, image);
% contrastFeature1 = std(s.s);
% contrastFeature2 = mean(s.b/length(s.b));
% contrastFeature3 = std(s.b)/length(s.b);
% contrastFeature4 = s.S/std(double(image(find(lesionMask))));
% contrastFeature5 = s.M/mean(image(find(lesionMask)));
contrastFeature4 = s.S/std(double(image(lesionMask>0)));
contrastFeature5 = s.M/mean(image(lesionMask>0));

% create contrast features' vector
cf = [
    %contrastFeature1; contrastFeature2; contrastFeature3; 
    contrastFeature4; contrastFeature5];
%names(end+1) = {'cf1'};
%names(end+1) = {'cf2'};
%names(end+1) = {'cf3'};
names(end+1) = {'cf4'};
names(end+1) = {'cf5'};

