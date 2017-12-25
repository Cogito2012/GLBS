%% 
% This MATLAB script is used to train GLBS models. 
% Notice that glmnet MATLAB toolkit is needed to be installed before 
% running this script in MATLAB software.
%
% Input: Prepared .mat files of training and test datasets. such as:
%         <ProjectRoot>/data/India/Cls_India_150.mat
% Output: Trained model files for ten rounds in direcory
%         <ProjectRoot>/GLBS/models_India_150/GLBS/model_{i}.mat, where i belongs to {1,2,...,10}
% Tips:
% 1. Glmnet toolkit: http://www.stanford.edu/~hastie/glmnet_matlab and 
%    cite: Glmnet for Matlab (2013) Qian, J., Hastie, T., Friedman, J., Tibshirani, R. and Simon, N.
% 2. Feel free to use this code and cite:
%    D. Yang and W. Bao. Group lasso-based band selection for hyperspectral image classification. IEEE
%    Geoscience and Remote Sensing Letters, 14(12):2438¨C2442, Dec 2017. 7.
%%
clc
clear

root_dir = fullfile('D:\¸ß¹âÆ×\Published\GLBS');
cd(root_dir);
addpath('../utils');
% =================================================================================
% 1. Land cover types with sample number less than 300 (Indian Pines) and 200 (Botswana) are removed.
% 2. 150 (Indian Pines) or 100 (Botswana) randomly selected training samples per land cover type
% 3. Prepare the fixed randomly selected data for 10 rounds of experiments.
% =================================================================================
datasets_name = 'India';
rm_threshold = 300; 
train_num_base = 150;
nIter = 10;

% prepare classification training and testing data
datasets = [datasets_name,'_',num2str(train_num_base)];
load(fullfile(root_dir,'../data',datasets_name,['Cls_',datasets,'.mat']));

% Training Configuration
models_dir = fullfile(root_dir,['models_',datasets]);
if ~exist(models_dir,'dir')
    mkdir(models_dir);
end
%% 
% Parameters description for glmnet MATLAB toolkit
% opts.lambda_min    :  Smallest value for lambda, If nobs > nvars, the default is 0.0001
%                       If nobs < nvars, the defaults is 0.01
% opts.standardize   :  Default is standardize = true
% opts.mtype         :  The default is 'ungrouped'
% opts.maxit         :  default is 10^5.
% opts.penalty_factor:  Default is 1 for all variables
% opts.weights       :  Observation weights, Default is 1 for each observation
%%
% GLBS algorithm implemented with glmnet toolkit for band selection and
% multi-class classification. Samples are not standarized and we set the
% maximum iteration to be 1000,000 and minimum lambda to be 1e-4.
% 
modelname = 'GLBS';
if ~exist(fullfile(models_dir,modelname),'dir')
    mkdir(fullfile(models_dir,modelname));
end
disp(['Training model: ',modelname]);
logfile = fopen(fullfile(models_dir,modelname,'Time_LOG.txt'),'a');
for i=1:nIter
    disp(['Training iters: ',num2str(i),' ...']);
    modelfile = fullfile(models_dir,modelname,['model_',num2str(i),'.mat']);
    if ~exist(modelfile,'file')
        opts.mtype = 'grouped';
        opts.lambda_min = 0.0001;
        opts.standardize = false;
        opts.maxit = 1000000;
        train_data = clsdata{i}.train_data;
        train_label = clsdata{i}.train_label;
        th = tic();
        fit_class = glmnet(train_data,train_label,'multinomial',opts);
        t_glbstrain = toc(th);
        fprintf(logfile, 'Training Time: %.3fs\n',t_glbstrain);
        save(modelfile,'fit_class');
        clear train_data train_label opts fit_class
    end
end

