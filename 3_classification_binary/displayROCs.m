clear all
close all
clc


folder = '.\figures';
if ~exist(folder, 'dir')
    mkdir(folder)
end


load('outputParams.mat')%outputParamsBinary?
ACCs = [];
meanAUCs = [];
for i = 1:length(outputParams)
    params = outputParams{i};

    ROCxs = params.ROCxs;
    ROCys = params.ROCys;
    AUCs = params.AUCs;
    ACCs(i) = mean(params.ACCs);
    meanAUCs(i) = mean(AUCs);
    [value, index] = min(params.ACCs);
    
    % data conversion for simple display
    [ROCxs,ROCys] = convertROCsForDisplay(ROCxs,ROCys);
    
    fig=figure; stairs(mean(ROCxs),mean(ROCys),'LineWidth', 3);
    hold on
    legend("mean of ROC curves", 'Location','best');
    ylabel('Sensitivity'); xlabel('1-Specificity');
    title({'Receiver operating characteristic curve of the classification of ', params.class,...
        ['meanAUC: ', num2str(round(mean(AUCs),3)),'\pm ',num2str(round(std(AUCs),3)) ]});
    hold off
    print(fig,['figures/',params.class],'-dpng');
end

