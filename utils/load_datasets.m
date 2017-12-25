function [data,data_gt,band_index] = load_datasets(datapath, datasets,remove)
% prepare_data script

if strcmp(datasets,'India')
    data_folder = fullfile(datapath,'Indian Pines');
    load(fullfile(data_folder,'Indian_pines.mat'));
    load(fullfile(data_folder,'Indian_pines_gt.mat'));

    band_index = [1:size(indian_pines,3)];
    if remove
        % We remove the following hyperspectral bands as the E-FDPC's
        % authors's suggestion. For the bands 221-224, they are zero bands 
        % and not included in source data files.
        % Reference:
        % S. Jia, G. Tang, J. Zhu, and Q. Li, "A Novel Ranking-Based 
        % Clustering Approach for Hyperspectral Band Selection," IEEE Trans. 
        % Geosci. Remote Sens., vol. 54, no. 1, pp. 88-102, 2016.
        remove_bands = [1:3,103:112,148:165,217:220]; 
        band_index(remove_bands) = [];
        preserved_num = length(band_index);
        data(:,:,1:preserved_num) = indian_pines(:,:,band_index);
    else
        data = indian_pines;
    end
    data_gt = indian_pines_gt;
    clear indian_pines;
end
if strcmp(datasets,'Botswana')
    data_folder = fullfile(datapath,'Botswana');
    load(fullfile(data_folder,'Botswana.mat'));
    load(fullfile(data_folder,'Botswana_gt.mat'));
    
    % For dataset Botswana, source files are already processed to remove
    % bands as entailed in:
    % http://www.ehu.eus/ccwintco/index.php?title=Hyperspectral_Remote_Sensing_Scenes
    data  = Botswana;
    data_gt = Botswana_gt;
    band_index = [10:55,82:97,102:119,134:164,187:220];
    clear Botswana;
end