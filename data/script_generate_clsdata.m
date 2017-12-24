%% 
% This MATLAB script is used to generate training and test dataset
% for both Indian Pines and Botswana. Just modify root datapath and 
% source data path, and run this script in MATLAB software.
%
% Input: source data path, such as:
%       <ProjectRoot>/data/source/Indian Pines/
% Output: well prepared datasets for training and test. 
%       <ProjectRoot>/data/India/Cls_India_150.mat
% Statistics of dataset are also generated:
%       <ProjectRoot>/data/India/gt_statistics.txt
%%
clc
clear

root_dir = fullfile('D:\¸ß¹âÆ×\Published\data');
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
datasets_dir = fullfile(root_dir,datasets_name);
if ~exist(datasets_dir,'dir')
   mkdir(datasets_dir) ;
end

% read source data and remove noisy bands with 'true'
source_datapath = fullfile(root_dir, 'source');
[data,data_gt,band_index] = load_datasets(source_datapath, datasets_name, true);
L = size(data,3);

% get class num list
data_gt_vect = reshape(data_gt,[size(data_gt,1)*size(data_gt,2),1]);
stat_gt = tabulate(data_gt_vect);
fid = fopen(fullfile(datasets_dir,'gt_statistics.txt'),'w');
for i=1:size(stat_gt,1)
    fprintf(fid,'%d\t\t%-6d\t%-3.1f\n',stat_gt(i,1),stat_gt(i,2),stat_gt(i,3));
end
fclose(fid);
%% prepare classification training and testing data
datasets = [datasets_name,'_',num2str(train_num_base)];
datafile = fullfile(datasets_dir,['Cls_',datasets,'.mat']);
if ~exist(datafile,'file')
    disp(['Generate training datasets: ',datasets]);
    clsdata = cell(1,nIter);
    for i=1:nIter
        [x,y,test_data,test_label] = prepare_cls_data(data,data_gt,1:L,train_num_base,rm_threshold);
        clsdata{i}.train_data = x;
        clsdata{i}.train_label = y;
        clsdata{i}.test_data = test_data;
        clsdata{i}.test_label = test_label;
        disp([num2str(i)])
    end
    save(datafile,'clsdata','band_index');
else
    clear x y test_data test_label clsdata
    load(datafile);
end
