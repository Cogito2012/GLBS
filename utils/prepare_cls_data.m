function [train_data,train_label,test_data,test_label] = prepare_cls_data(data,data_gt,feat_bands,train_num_perclass,rm_threshold)
% remove samples with less than a given threshold, and randomly select a
% fixed number of samples for training set and the rest of all for test set
% for each class(Land cover type).
[h,w] = size(data_gt);
data_gt_vect = reshape(data_gt,[h*w,1]);
class_num = sum(unique(data_gt_vect')~=0,2);
for i=1:class_num
    clsnum_list(i) = length(find(data_gt_vect==i));
end
new_clsnum_list = clsnum_list;
new_clsnum_list(find(clsnum_list<rm_threshold)) = [];
new_clsidx_list = 1:class_num;
new_clsidx_list(find(clsnum_list<rm_threshold)) = [];

train_num = 0;
test_num = 0;
for i=new_clsidx_list
    cls_id = i;
    % get the index row and column of class i
    [r,c] = find(data_gt==cls_id);
    randseq = randperm(length(r));
    r = r(randseq); 
    c = c(randseq);
    
    % get training samples index
    r_train = r(1:train_num_perclass);
    c_train = c(1:train_num_perclass);
    % get test samples index
    r_test = r(train_num_perclass+1:end);
    c_test = c(train_num_perclass+1:end);
    % get the training samples of class i
    for j=1:length(r_train)
        train_data(train_num+j,:) = data(r_train(j),c_train(j),feat_bands);
    end
    train_label(train_num+1:train_num+length(r_train),1) = cls_id*ones(length(r_train),1);
    % get the test samples of class i
    for j=1:length(r_test)
        test_data(test_num+j,:) = data(r_test(j),c_test(j),feat_bands);
    end
    test_label(test_num+1:test_num+length(r_test),1) = cls_id*ones(length(r_test),1);
    % accumulate training number and test number
    train_num = train_num + length(r_train);
    test_num = test_num + length(r_test);
end