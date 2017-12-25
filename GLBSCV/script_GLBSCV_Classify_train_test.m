%% 
% This MATLAB script is used to implement Classifiers (SVM and kNN) on the selected bands result from GLBSCV. 
% Requirements: libsvm-3.21 (https://www.csie.ntu.edu.tw/~cjlin/libsvm/)
% 
% Input: 1. Prepared .mat files of training and test datasets. Such as:
%         <ProjectRoot>/data/India/Cls_India_150.mat
%        2. Trained model files for ten rounds in direcory as:
%          <ProjectRoot>/GLBSCV/models_India_150/GLBSCV/model_{i}.mat
% Output:1. Testing results including Kappa, OA, AA in .mat files by Classifiers  such as:
%          <ProjectRoot>/GLBSCV/results_India_150/GLBSCV_RES.mat
%        2. All the trained models of SVM and kNN for ten rouds
%          <ProjectRoot>/GLBSCV/models_India_150/Model.mat
%
% Feel free to use this code and cite:
%    D. Yang and W. Bao. Group lasso-based band selection for hyperspectral image classification. IEEE
%    Geoscience and Remote Sensing Letters, 14(12):2438¨C2442, Dec 2017. 7.
%%
clc
clear

root_dir = fullfile('D:\¸ß¹âÆ×\Published\GLBSCV');
cd(root_dir);
addpath('../utils');
% =================================================================================
% 1. Land cover types with sample number less than 300 (Indian Pines) and 200 (Botswana) are removed.
% 2. 150 (Indian Pines) or 100 (Botswana) randomly selected training samples per land cover type
% 3. Prepare the fixed randomly selected data for 10 rounds of experiments.
% =================================================================================
datasets_name = 'Botswana';
rm_threshold = 200; 
train_num_base = 100;
nIter = 10;

% prepare classification training and testing data
datasets = [datasets_name,'_',num2str(train_num_base)];
load(fullfile(root_dir,'../data',datasets_name,['Cls_',datasets,'.mat']));

% Training Configuration
models_dir = fullfile(root_dir,['models_',datasets]);
if ~exist(models_dir,'dir')
    mkdir(models_dir);
end
results_dir = fullfile(root_dir,['results_',datasets]);
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

%%
% training the GLBSCV_SVM & GLBSCV_KNN Models
modelname = 'GLBSCV'; 
band_step = 5;  % The incremental selection step for training classifiers
Model = cell(1,nIter);
GLBSCV_RES = cell(1,nIter);
logfile = fopen(fullfile(models_dir,'GLBSCV_LOG.txt'),'w');
for n=1:nIter
    fprintf(logfile, '\nIteration %d: \n',n);
    train_data = clsdata{n}.train_data;
    train_label = clsdata{n}.train_label;
    test_data = clsdata{n}.test_data;
    test_label = clsdata{n}.test_label;
    
    % glbs algorithm to select bands
    load(fullfile(models_dir,modelname,['model_',num2str(n),'.mat']));
    [ S_ALL] = glbscv(fit_class);
    Model{n}.bands = S_ALL;
    fprintf(logfile, 'GLBSCV selected %d bands in sequence.\n',length(S_ALL));
    
    trial_num = floor(length(S_ALL)/band_step);
    OA_knn = zeros(1,trial_num);
    Kappa_knn = zeros(1,trial_num);
    AA_knn = zeros(1,trial_num);
    OA_svm = zeros(1,trial_num);  
    Kappa_svm = zeros(1,trial_num);
    AA_svm = zeros(1,trial_num);
    knn_mdl = cell(1,trial_num);
    svm_mdl = cell(1,trial_num);
    for i=1:trial_num
        sel_num = band_step*i;
        S = S_ALL(1:sel_num);
        fprintf(logfile, 'selected %d bands: %s\n',sel_num,num2str(band_index(S)));
        
         % kNN
        thresh_k = 3; 
        th = tic();
        knn_mdl{i} = ClassificationKNN.fit(train_data(:,S),train_label,'NumNeighbors',thresh_k);
        t_train = toc(th);
        th = tic();
        predict_label = predict(knn_mdl{i},test_data(:,S));
        [OA_knn(i),Kappa_knn(i),AA_knn(i)] = evalPred( predict_label,test_label);
        t_test = toc(th);
        fprintf(logfile,'knn: Training time = %.3fs, Test time = %.3fs\n',t_train,t_test);
        fprintf(logfile,'knn: Overall Accuracy = %.3f, Kappa Coefficiency = %.3f, Average Accuracy = %.3f\n',OA_knn(i),Kappa_knn(i),AA_knn(i));
        % SVM
        % svm training by libsvm with linear kernel, default params, no shrinking
        th = tic();
        svm_mdl{i} = svmtrain(train_label, train_data(:,S),'-s 0 -t 0 -h 0'); 
        t_train = toc(th);
        th = tic();
        [predict_label, accuracy, dec_values] = svmpredict(test_label,test_data(:,S),svm_mdl{i});
        [OA_svm(i),Kappa_svm(i),AA_svm(i)] = evalPred( predict_label,test_label);
        t_test = toc(th);
        fprintf(logfile,'svm: Training time = %.3fs, Test time = %.3fs\n',t_train,t_test);
        fprintf(logfile,'svm: Overall Accuracy = %.3f, Kappa Coefficiency = %.3f, Average Accuracy = %.3f\n',OA_svm(i),Kappa_svm(i),AA_svm(i));
    end
    % save results, knn
    Model{n}.knn = knn_mdl;
    GLBSCV_RES{n}.knn.OA = OA_knn;
    GLBSCV_RES{n}.knn.Kappa = Kappa_knn;
    GLBSCV_RES{n}.knn.AA = AA_knn;
    % save results, svm
    Model{n}.svm = svm_mdl;
    GLBSCV_RES{n}.svm.OA = OA_svm;
    GLBSCV_RES{n}.svm.Kappa = Kappa_svm;
    GLBSCV_RES{n}.svm.AA = AA_svm;
end
save(fullfile(models_dir,'Model.mat'),'Model','-v7.3');
save(fullfile(results_dir,'GLBSCV_RES.mat'),'GLBSCV_RES','-v7.3');
fclose(logfile);





