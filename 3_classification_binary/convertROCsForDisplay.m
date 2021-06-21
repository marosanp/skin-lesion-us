function [ROCxs,ROCys] = convertROCsForDisplay(ROCxs,ROCys)
% data conversion - from cell to array structure
%   for simple handling

    % convert ROC values to display
    tmpX = ROCxs; tmpY = ROCys;
    ROCxs = []; ROCys = [];
    lengths = [];
    for cellIdx = 1:10
        lengths(cellIdx) = length(tmpX{cellIdx});
    end
    
    for cellIdx = 1:10
        if(length(tmpX{cellIdx})~= max(lengths))
            tmpX{cellIdx}(end+1) = tmpX{cellIdx}(end); 
            tmpY{cellIdx}(end+1) = tmpY{cellIdx}(end); 
        end
        ROCxs(cellIdx, :) = tmpX{cellIdx};
        ROCys(cellIdx, :) = tmpY{cellIdx};
    end


end

