function stats = compute_GLCM(im, offset, levels)



    [row, col] = find(im);
    rect_les = [min(col), min(row), max(col)-min(col), max(row)-min(row)];

    im = im(rect_les(2):rect_les(2)+rect_les(4),...
        rect_les(1):rect_les(1)+rect_les(3) );
% get some features of the ROI (mean of ~contrast, ~correlation, ~energy, ~homogeneity)
    %% original image
    % values outside mask = NaN -> function graycomatrix will ignore NaN values
    if ~exist('levels','var')
        levels = 16;
        disp('Variable not found; levels set to =16.')
    end
    %levels = 64;
    
    im = im./max(im(:))*(levels-1);
    im = double(round(im));
    %im(isnan(im)) = 0; %??????
    
    %% compute GLCM matrix
    %glcm = graycomatrix(im);
    %levels = 256;
    
    %[glcm_horizontal, glcm_vertical] = myGLCM(im, levels, offset); %only works with matrix values between 0 and 255
    [glcm_horizontal, glcm_vertical] = myGLCM_acceptNaN(im, levels, offset);
    
    % feature extraction
    stats.horizontal = GLCM_features(glcm_horizontal);
    stats.vertical = GLCM_features(glcm_vertical);
end
