clear all
close all
clc

load('outputParams.mat')%Binary?
ACCs = [];
fig=figure;
for i = 1:length(outputParams)
    params = outputParams{i};

    ROCxs = params.ROCxs;
    ROCys = params.ROCys;
    AUCs = params.AUCs;
    ACCs(i) = mean(params.ACCs);
    %[value, index] = min(params.ACCs);
    
    % data conversion for simple display
    [ROCxs,ROCys] = convertROCsForDisplay(ROCxs,ROCys);

    stairs(mean(ROCxs),mean(ROCys),'LineWidth', 3);     % plot
    grid on
    hold on
    legend(["Nevus vs others (AUC_{mean}= " + num2str(mean(outputParams{1}.AUCs), '%1.3f')+")"],...
            ["MM vs others (AUC_{mean}= " + num2str(mean(outputParams{2}.AUCs), '%1.3f')+")"],...
            ["BCC vs others (AUC_{mean}= " + num2str(mean(outputParams{3}.AUCs), '%1.3f')+")"],...
            ["Nevus vs BCC (AUC_{mean}= " + num2str(mean(outputParams{4}.AUCs), '%1.3f')+")"],...
            ["Nevus vs MM (AUC_{mean}= " + num2str(mean(outputParams{5}.AUCs), '%1.3f')+")"],...
            ["BCC vs MM (AUC_{mean}= " + num2str(mean(outputParams{6}.AUCs), '%1.3f')+")"],...
        'Location','southeast');
    params.class
    'meanAUC: ', num2str(round(mean(AUCs),3))
    ylabel('Sensitivity'); xlabel('1-Specificity');
    %title({'Binary classification ROC curves','using XXX-seeding based segmentation'});
    text(-0.1,0.97,'b.', 'FontSize',18)
end
hold off
print(fig,['figures/binary_class_ROCs_XXX'],'-dpng');
