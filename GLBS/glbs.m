function [ bandset, bandseq ] = glbs( glmodel)
%% GLBS Algorithm for band selection
% Input: 
%   - glmodel: the trained glbs model with glmnet, such as: 
%     glmodel = glmnet(train_data,train_label,'multinomial',opts);
% Output:
%   - bandseq: the selected band id sequentially with glmodel
% 
% Feel free to use this code and cite:
%    D. Yang and W. Bao. Group lasso-based band selection for hyperspectral image classification. IEEE
%    Geoscience and Remote Sensing Letters, 14(12):2438¨C2442, Dec 2017. 7.
%% 
% get the band sequence for each lambda
bandset = cell(1,length(glmodel.lambda));
for i=1:length(glmodel.lambda)
    u = [];
    for j=1:length(glmodel.label)
        co = glmodel.beta{j};
        sel = find(co(:,i)~=0);
        u = union(u,sel);
    end
    bandset{i} = u;
end

% generate the ordered sequence by time
bandseq = [];
for j=2:length(bandset)
    seq = bandset{j};
    seq_new = setdiff(seq,bandset{j-1});
    if ~isempty(seq_new)
        bandseq = cat(1,bandseq,seq_new);
    end
end

[~,idx] = unique(bandseq);
bandseq = bandseq(sort(idx));

end

