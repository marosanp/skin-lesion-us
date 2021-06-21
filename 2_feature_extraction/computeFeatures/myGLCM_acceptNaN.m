function [glcm_horizontal, glcm_vertical] = myGLCM_acceptNaN(im, levels, offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    glcm_horizontal = zeros(levels);
    glcm_vertical = zeros(levels);
    [N, M] = size(im);
    %offset = 1;
    
    for i = 1:N-offset
        
        for j = 1:M-offset
            if isnan( im(i, j) ) || isnan( im(i+offset, j) ) || isnan(im(i, j+offset))
                %
            else
                x = im(i, j)+1;
                y1 = im(i+offset, j)+1;
                glcm_horizontal(x, y1) = glcm_horizontal(x, y1)+1;
                
                y2 = im(i, j+offset)+1;
                glcm_vertical(x, y2) = glcm_vertical(x, y2) + 1;
            end
        end
    end
    
    j = M;
    for i = 1:N-offset
        if isnan( im(i, j) ) || isnan( im(i+offset, j) )
            %
        else
            x = im(i, j)+1;
            y1 = im(i+offset, j)+1;
            glcm_horizontal(x, y1) = glcm_horizontal(x, y1)+1;
        end
    end
    
    i = N;
    for j = 1:M-offset
        if isnan( im(i, j) ) || isnan(im(i, j+offset))
            %
        else
            x = im(i, j)+1;
            y2 = im(i, j+offset)+1;
            glcm_vertical(x, y2) = glcm_vertical(x, y2) + 1;
        end
    end
            

    glcm_horizontal = glcm_horizontal + glcm_horizontal';
    glcm_vertical = glcm_vertical + glcm_vertical';
    % figure,imagesc(glcm_horizontal)
end

