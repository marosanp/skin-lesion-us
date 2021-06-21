function [featureVector, nameVector] = getAllFeatures(image, lesionCrop, dermisCrop, lesionMask, dermisMask)
%   computes all features
% based on the images, lesionCrop, DermisCrop, lesionMask, dermisMask
% output:   texture and shape-based features,
%           GLCM features (vertical & horizontal) for both dermis & lesion with name


% names and values of features
featureVector = [];
nameVector = {};

% first-order texture features 
[tbfVec, newNameVec] = textureBasedFeatures(image, lesionMask, lesionCrop, dermisMask, dermisCrop);
% sahpe based features
[sbfVec, newNameVec2] = shapeBasedFeatures(lesionMask);

featureVector = [featureVector; tbfVec; sbfVec];
nameVector = [nameVector, newNameVec, newNameVec2];
			

% second-order (GLCM-based) textural features
for enum = 1:1
    % uses only one offset and one level parameter
    offset = [1 2 3 4];
    level = [16 64 64 64];
    % compute GLCM features for lesion crop
    GLCM_featuresL = compute_GLCM(lesionCrop, offset(enum), level(enum));
    
    % all GLCM-based features
    % verticalFields = {'contr', 'corrm', 'corrp', 'dissi', 'energ', 'entro', 'homom', 'homop', 'maxpr', 'savgh', 'senth', 'dvarh', 'denth', 'inf1h', 'inf2h', 'indnc', 'idmnc'};
    % horizantFields = {'contr', 'corrm', 'corrp', 'dissi', 'energ', 'entro', 'homom', 'homop', 'maxpr', 'senth', 'dvarh', 'denth', 'inf1h', 'inf2h', 'indnc', 'idmnc'};
    
    % selected features
    verticalFields = {'contr', 'corrm', 'corrp', 'dissi', 'maxpr', 'dvarh', 'denth', 'inf1h'};
    horizantFields = {'contr', 'corrm', 'corrp', 'dissi', 'energ', 'entro', 'homom', 'homop', 'maxpr', 'dvarh', 'denth', 'inf1h', 'inf2h'};
    
    % add feature values and names to output - horizontal and vertical also
    for j = 1:length(verticalFields)
        feature_gv_l(j) = getfield(GLCM_featuresL.vertical,verticalFields{j});
        name_gv_l{j} = [verticalFields{j}  'GLCMVer_L'];
    end
    
    for j = 1:length(horizantFields)
        feature_gh_l(j) = getfield(GLCM_featuresL.horizontal,horizantFields{j});
        name_gh_l{j} = [horizantFields{j}  'GLCMHor_L'];
    end
    
    featureVector = [featureVector;feature_gv_l';feature_gh_l'];
    nameVector = [nameVector name_gv_l name_gh_l];
    
    % compute GLCM features for dermis crop
    GLCM_featuresD = compute_GLCM(dermisCrop,offset(enum), level(enum));
    
    % add feature values and names to output - horizontal and vertical also
    for j = 1:length(verticalFields)
        feature_gv_d(j) = getfield(GLCM_featuresD.vertical,verticalFields{j});
        name_gv_d{j} = [verticalFields{j}  'GLCMVer_D'];
    end
    
    for j = 1:length(horizantFields)
        feature_gh_d(j) = getfield(GLCM_featuresD.horizontal,horizantFields{j});
        name_gh_d{j} = [horizantFields{j}  'GLCMHor_D'];
    end

    featureVector = [featureVector;feature_gv_d';feature_gh_d'];
    nameVector = [nameVector name_gv_d name_gh_d];
    
end

% further shape-based features, currently not used
shpind = shapeindex(lesionCrop,0);
shpH10 = histcounts(shpind,10);
shpH100 = histcounts(shpind,100);
shpENT = entropy(shpH100);
% shpM = mean(shpH100); %seems to be useless
% shpMAX = max(shpH100);
% shpSTD = std(shpH100); %seems to be useless
% shpSKEW = skewness(shpH100); %seems to be useless
% shpKURT = kurtosis(shpH100);
% shpCONT = (max(shpH100(:))-min(shpH100(:)))/ mean(shpH100(:));
% lpq = lpqNEW(lesionCrop);
% [ltp_up ltp_lo] = ltp(lesionCrop,0);
% featureVector = [featureVector; shpENT];
% nameVector = [nameVector 'shpENT'];

end