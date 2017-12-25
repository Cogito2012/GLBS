function [ bandseq ] = glbscv( glmodel)
%% GLBS Algorithm with Cross-Validation for band selection
% Input: 
%   - glmodel: the trained glbs model with cvglmnet, such as: 
%     glmodel = cvglmnet(train_data,train_label,'multinomial',opts,'default',10,[],true);
% Output:
%   - bandseq: the selected band id sequentially with glmodel
% 
% Feel free to use this code and cite:
%    D. Yang and W. Bao. Group lasso-based band selection for hyperspectral image classification. IEEE
%    Geoscience and Remote Sensing Letters, 14(12):2438¨C2442, Dec 2017. 7.
%% 
% get the band sequence for each lambda
selID = find(glmodel.lambda == glmodel.lambda_1se);
bandseq = [];
for j=1:length(glmodel.glmnet_fit.label)
    co = glmodel.glmnet_fit.beta{j};
    sel = find(co(:,selID)~=0);
    bandseq = union(bandseq,sel);
end

end

