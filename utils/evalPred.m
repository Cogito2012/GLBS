function [ OA,Kappa,AA] = evalPred( predict_label,test_label)
% evaluate the prediction by confusion matrix
% Input:
%   -- predict_label: predict label vetctor
%   -- test_label: test label vetctor
% Output :
%   -- OA: Overall Accuracy
%	-- Kappa: Kappa Coefficiency
%   -- AA: Average Accuracy
%%
confmatrix = cfmatrix(test_label,predict_label);
P0 = sum(sum(confmatrix))*trace(confmatrix) - sum(confmatrix,1)*sum(confmatrix,2);
P1 = sum(sum(confmatrix))^2 - sum(confmatrix,1)*sum(confmatrix,2);
Kappa = P0/P1;
OA = trace(confmatrix)/sum(sum(confmatrix));
AA = mean(diag(confmatrix)'./sum(confmatrix,1));
end

