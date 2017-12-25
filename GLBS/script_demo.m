%% 
% This MATLAB script is used as a demo to select bands from prepared dataset
% with well trained GLBS model.
%
% Input: 1. Prepared .mat files of training and test datasets. Such as:
%         <ProjectRoot>/data/India/Cls_India_150.mat
%        2. Trained model files for ten rounds in direcory as:
%          <ProjectRoot>/GLBS/models_India_150/GLBS/model_{i}.mat
% Output:Testing results with txt file, such as:
%          <ProjectRoot>/results/sequences/GLBS_India_150_model2.txt
%
% Feel free to use this code and cite:
%    D. Yang and W. Bao. Group lasso-based band selection for hyperspectral image classification. IEEE
%    Geoscience and Remote Sensing Letters, 14(12):2438¨C2442, Dec 2017. 7.
%%
clc
clear

root_dir = fullfile('D:\¸ß¹âÆ×\Published\GLBS');
cd(root_dir);
addpath('../utils');
% =================================================================================
% 1 150 (Indian Pines) or 100 (Botswana) randomly selected training samples per land cover type
% 2. Prepare the fixed randomly selected data for 10 rounds of experiments.
% =================================================================================
datasets_name = 'India';
train_num_base = 150;
nIter = 10;

% input 
modelname = 'GLBS'; 
datasets = [datasets_name,'_',num2str(train_num_base)];
load(fullfile(root_dir,'../data',datasets_name,['Cls_',datasets,'.mat']));
models_dir = fullfile(root_dir,['models_',datasets],modelname);
n = 2;  % test the second model
% output
output_path = fullfile(root_dir,'../results','sequences');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end
fid = fopen(fullfile(output_path, [modelname,'_',datasets,'_model',num2str(n),'.txt']),'w');

% for n=1:nIter
    load(fullfile(models_dir,['model_',num2str(n),'.mat']));
    
    nbands = zeros(1,length(fit_class.lambda));
    bands = cell(1,length(fit_class.lambda));
    for i=1:length(fit_class.lambda)
        % the selected bands
        u = [];
        for j=1:length(fit_class.label)
            co = fit_class.beta{j};
            sel = find(co(:,i)~=0);
            u = union(u,sel);
        end
        nbands(i) = length(u);
        bands{i} = u;
        for j=1:length(u)
            fprintf(fid,'%d\t',u(j));
        end
        fprintf(fid,'\n');
    end
%     % eliminate duplicate bands, and keep sequential
%     for i=1:1:max(nbands)
%         idx = find(nbands==i);
%         if ~isempty(idx)
%             subbands = bands(idx);
%             seq = subbands{1};
%             for j=1:length(seq)
%                 fprintf(fid,'%d\t',seq(j));
%             end
%             fprintf(fid,'\n');
%         end
%     end

% end


fclose(fid);
