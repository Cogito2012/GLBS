%% 
% This MATLAB script is used to test GLBS models. 
% Notice that glmnet MATLAB toolkit is needed to be installed, and datasets
% as well as trained models are need to be well prepared before running 
% this script in MATLAB software.
%
% Input: 1. Prepared .mat files of training and test datasets. Such as:
%         <ProjectRoot>/data/India/Cls_India_150.mat
%        2. Trained model files for ten rounds in direcory as:
%          <ProjectRoot>/GLBS/models_India_150/GLBS/model_{i}.mat
% Output:Testing results including Kappa, OA, AA in .mat files such as:
%          <ProjectRoot>/GLBS/results_India_150/GLBS/GLBS_RES.mat
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
% 1. Land cover types with sample number less than 300 (Indian Pines) and 200 (Botswana) are removed.
% 2. 150 (Indian Pines) or 100 (Botswana) randomly selected training samples per land cover type
% 3. Prepare the fixed randomly selected data for 10 rounds of experiments.
% =================================================================================
datasets_name = 'India';
train_num_base = 150;
nIter = 10;

% prepare classification training and testing data
datasets = [datasets_name,'_',num2str(train_num_base)];
load(fullfile(root_dir,'../data',datasets_name,['Cls_',datasets,'.mat']));

% Training Configuration
modelname = 'GLBS'; 
models_dir = fullfile(root_dir,['models_',datasets],modelname);
if ~exist(models_dir,'dir')
    mkdir(models_dir);
end
results_dir = fullfile(root_dir,['results_',datasets],modelname);
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

%%
% evaluate the GLBS Models
GLBS_RES = cell(1,nIter);
for n=1:nIter
    load(fullfile(models_dir,['model_',num2str(n),'.mat']));
    test_data = clsdata{n}.test_data;
    test_label = clsdata{n}.test_label;

    predict_label = glmnetPredict(fit_class,test_data,[],'class');

    OA = zeros(1,length(fit_class.lambda));
    Kappa = zeros(1,length(fit_class.lambda));
    AA = zeros(1,length(fit_class.lambda));
    nbands = zeros(1,length(fit_class.lambda));
    bands = cell(1,length(fit_class.lambda));
    for i=1:length(fit_class.lambda)
        [OA(i),Kappa(i),AA(i)] = evalPred( predict_label(:,i),test_label);
        % select bands within fit_class
        u = [];
        for j=1:length(fit_class.label)
            co = fit_class.beta{j};
            sel = find(co(:,i)~=0);
            u = union(u,sel);
        end
        nbands(i) = length(u);
        bands{i} = u;
    end
    % remove the results with the same number of bands
    [nbands_sort,ind] = sort(nbands);
    OA_sort = OA(ind);
    Kappa_sort = Kappa(ind);
    AA_sort = AA(ind);
    [nbands_uq,~,~] = unique(nbands_sort);
    for i=1:length(nbands_uq)
        idx = find(nbands_sort==nbands_uq(i));
        % get new OA and bands
        oa = OA_sort(idx);
        [oa_new,idx_oa] = max(oa);
        GLBS_RES{n}.OA(i) = oa_new;
        IDX = idx(idx_oa);
        GLBS_RES{n}.bands{i} = bands{ind(IDX)};
        GLBS_RES{n}.nbands(i) = length(bands{ind(IDX)});
        % get new Kappa
        kappa = Kappa_sort(idx);
        [kappa_new,idx_kappa] = max(kappa);
        GLBS_RES{n}.Kappa(i) = kappa_new;
        % get new AA
        aa = AA_sort(idx);
        [aa_new,idx_aa] = max(aa);
        GLBS_RES{n}.AA(i) = aa_new;
    end
    % remove zero nbands data
    rm_idx = find(cellfun(@(x) isempty(x),GLBS_RES{n}.bands));
    GLBS_RES{n}.nbands(rm_idx) = [];
    GLBS_RES{n}.bands(rm_idx) = [];
    GLBS_RES{n}.OA(rm_idx) = [];
    GLBS_RES{n}.Kappa(rm_idx) = [];
    GLBS_RES{n}.AA(rm_idx) = [];
end
save(fullfile(results_dir,'GLBS_RES.mat'),'GLBS_RES','-v7.3');

