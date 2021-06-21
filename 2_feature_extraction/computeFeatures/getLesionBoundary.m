function [lesionBoundary, lesionBoundaryMask] = getLesionBoundary(image, lesionMask, dermisMask, boundarySize)
% compute lesion boundary
% inputs:
%     image: ultrasound image
%     lesionMask: lesion mask, binary mask of lesion
%     dermisMask: dermis mask, binary mask of the dermis
%     boundarySize: boundarySize
% outputs:
%     lesionBoundary
%     lesionBoundaryMask


m1 = ones(boundarySize,boundarySize);
dLesionMask = double(lesionMask);
dDermisMask = double(dermisMask);
image = double(image);

lesionBoundaryMask = conv2(dLesionMask,m1,'same');
lesionBoundaryMask = lesionBoundaryMask -  (sum(m1(:)) * dLesionMask);

lesionBoundaryMask(lesionBoundaryMask<=0) = 0;
lesionBoundaryMask(lesionBoundaryMask>0) = 1;

%lesionBoundaryMask((dDermisMask + dLesionMask) == 0) = 0;

lesionBoundary = image.*lesionBoundaryMask;
lesionBoundary(lesionBoundary==0) = NaN;