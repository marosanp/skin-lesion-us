function [sbfVec, namesVec] = shapeBasedFeatures(lesionMask)
% computation of shape-based features
% inputs:
%     lesionMask: lesion mask, binary mask of lesion
% outputs:
%     sbfVec: shape-based features' vector
%     namesVec: shape-based feature names

sbfVec = [];        % texture-based feature vector
namesVec = {};      % vector of feature names

% Curvature
stats = regionprops(lesionMask,'BoundingBox');
r = round(stats(1).BoundingBox);
mask1 = lesionMask(r(2):r(2)+r(4),r(1):r(1)+r(3)-1);  
%mask1 = lesionCrop(find(lesionCrop>0)) = 1;

s = getShapes2(mask1);
stdCurvature = std(s.curv);

% Dev from ellipse & circularity
%devFromEllipse = std(s.dist);
circularityOfLesion = s.Circularity;    % s.ElongationAll

% Asymmetry, compactness
asymmetry = s.majoraxis/s.minoraxis;
%compactness = s.perim^2/s.A;

% Other shape based features
IrA = s.perim/s.A;
IrB = s.perim/s.majoraxis;
% IrC = s.perim* ((1/s.minoraxis)-(1/s.majoraxis) );     
% IrD = s.majoraxis-s.minoraxis;  


% sbfVec = [stdCurvature; devFromEllipse; circularityOfLesion; asymmetry;...
%     compactness; IrA; IrB; IrC; IrD];
% namesVec = [namesVec 'stdCurvature' 'devFromEllipse' 'circularity' ...
%     'asymmetry' 'compactness' 'IrA' 'IrB' 'IrC' 'IrD'];

sbfVec = [stdCurvature; circularityOfLesion; asymmetry; IrA; IrB];
namesVec = [namesVec 'stdCurvature' 'circularity' 'asymmetry' 'IrA' 'IrB'];
