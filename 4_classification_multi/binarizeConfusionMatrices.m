clear all
close all
clc

% binarize confusion matrices
% nevus, melanoma, bcc
load('c_matricesMulti.mat')
c_matrices = c_matricesMulti;
% % nevus vs others
% conf = c_matrices;
% NO_matrices = [conf(1,1,:), conf(1,2,:)+conf(1,3,:); conf(2,1,:)+conf(3,1,:),...
%     conf(2,2,:)+conf(2,3,:)+conf(3,2,:)+conf(3,3,:)];
%
% % melanoma vs others
% MO_matrices = [conf(1,1,:), conf(1,2,:)+conf(1,3,:); conf(2,1,:)+conf(3,1,:),...
%     conf(2,2,:)+conf(2,3,:)+conf(3,2,:)+conf(3,3,:)];
%
%
% % bcc vs others

n_class  = 3;
n_groups = 10;
c_matrix = c_matrices(:,:,1);
TP=zeros(n_groups,n_class);
FN=zeros(n_groups,n_class);
FP=zeros(n_groups,n_class);
TN=zeros(n_groups,n_class);
P=zeros(n_groups,n_class);
N=zeros(n_groups,n_class);
ACC=zeros(n_groups,n_class);

for i=1:n_class
    for j=1:n_groups
        c_matrix = c_matrices(:,:,j);
        TP(j,i)=c_matrix(i,i);
        FN(j,i)=sum(c_matrix(i,:))-c_matrix(i,i);
        FP(j,i)=sum(c_matrix(:,i))-c_matrix(i,i);
        TN(j,i)=sum(c_matrix(:))-TP(j,i)-FP(j,i)-FN(j,i);
        
    end
end
P  = TP+FN;
N  = TN+FP;
ACC = (TP+TN)./(P+N);
mean(ACC)