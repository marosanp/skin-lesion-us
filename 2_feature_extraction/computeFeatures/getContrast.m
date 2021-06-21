function  s = getContrast(m1, im)
numofIt = 15;
numofItd = 5;

% examine
if sum(m1(:)) <300
    numofItd = 1;
end

d = m1;
b = cell(1,numofIt + numofItd);
bval = cell(1,numofIt + numofItd);
a = [0 0 0;1 1 1;0 1 0];

for I = numofItd:-1:1
    d = imerode(d,a);%strel('diamond',1)
    B = bwboundaries(d);
    B = B{1};
    b{I} = B;
    tmp = [];
    for K = 1:size(b{I},1)-1
        tmp = [tmp, im(B(K,1),B(K,2))];
    end
    bval{I} = tmp;
end

d = m1;

for I = 1:numofIt
    B = bwboundaries(d);
    B = B{1};
    b{I} = B;
    tmp = [];
    for K = 1:size(b{I},1)-1
        tmp = [tmp, im(B(K,1),B(K,2))];
    end
    bval{numofItd + I} = tmp;
    d = imdilate(d,a);%strel('diamond',1)
end

tmp = zeros(numofItd+numofIt,length(bval{end}));
for I = numofItd + numofIt:-1:1
    if I ~= numofIt + numofItd
        bval{I} = linearInterp(bval{I}, length(bval{end})); 
        %bval{I} = interp1(1:length(bval{I}),double(bval{I}),linspace(1,length(bval{I}),length(bval{end}))); 
    end
    tmp(I,:) = bval{I};
    
end
s.S = std2(tmp(11:end,:));
s.M = mean2(tmp(11:end,:));

s.s = std(tmp);
th = 0.85;
bound = ones(2,size(tmp,2));
bound(2,:) = bound(1,:)*size(tmp,1);
for I = 1:size(tmp,2)
    
    for J = 2:size(tmp,1)
        if tmp(J,I)>tmp(1,I)+abs(tmp(end,I)-th*tmp(end,I))
            bound(1,I) = J;
            %tmp(J,I) = 0;
            break
        end
    end
    for J = size(tmp,1)-1:-1:1
        if tmp(J,I)<th*tmp(end,I)
            bound(2,I) = J;
            %tmp(J,I) = 0;
            break
        end
    end
end

s.b = abs(bound(1,:)-bound(2,:));

end

function output = linearInterp(input, outputDim)
        ratio = (length(input) - 1) / (outputDim - 1);
        output = zeros(1, outputDim);
        for outputInd = 1 : outputDim
            currentPosition = (outputInd-1) * ratio + 1;
            nearestLeftPosition = floor(currentPosition);
            nearestRightPosition = nearestLeftPosition + 1;
            if nearestRightPosition>length(input)
                nearestRightPosition=length(input);
            end
            nearestLeftPositionValue = input(nearestLeftPosition);
            nearestRightPositionValue =  input(nearestRightPosition);
            slope=nearestRightPositionValue-nearestLeftPositionValue;
            positionFromLeft = currentPosition - nearestLeftPosition;

            output(outputInd) = (slope*positionFromLeft+nearestLeftPositionValue);

        end
end



