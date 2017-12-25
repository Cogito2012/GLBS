function [confmatrix] = cfmatrix(actual, predict, classlist, per)
% CFMATRIX calculates the confusion matrix for any prediction 
% algorithm that generates a list of classes to which the test 
% feature vectors are assigned
%
% Outputs: confusion matrix
%
%                 Actual Classes
%                   p       n
%              ___|_____|______| 
%    Predicted  p'|     |      |
%      Classes  n'|     |      |
% 
% Inputs: 
% 1. actual / 2. predict
% The inputs provided are the 'actual' classes vector
% and the 'predict'ed classes vector. The actual classes are the classes
% to which the input feature vectors belong. The predicted classes are the 
% class to which the input feature vectors are predicted to belong to, 
% based on a prediction algorithm. 
% The length of actual class vector and the predicted class vector need to 
% be the same. If they are not the same, an error message is displayed. 
% 3. classlist
% The third input provides the list of all the classes {p,n,...} for which 
% the classification is being done. All classes are numbers.
% 4. per = 1/0 (default = 0)
% This parameter when set to 1 provides the values in the confusion matrix 
% as percentages. The default provides the values in numbers.
%
% Example:
% >> a = [ 1 2 3 1 2 3 1 1 2 3 2 1 1 2 3];
% >> b = [ 1 2 3 1 2 3 1 1 1 2 2 1 2 1 3];
% >> Cf = cfmatrix(a, b);
%
% [Avinash Uppuluri: avinash_uv@yahoo.com: Last modified: 08/21/08]

% If classlist not entered: make classlist equal to all 
% unique elements of actual
if (nargin < 2)
   error('Not enough input arguments.');
elseif (nargin == 2)
    classlist = unique(actual); % default values from actual
    per = 0; % default is numbers and input 1 for percentage
elseif (nargin == 3)
    per = 0; % default is numbers and input 1 for percentage
end

if (length(actual) ~= length(predict))
    error('First two inputs need to be vectors with equal size.');
elseif ((size(actual,1) ~= 1) && (size(actual,2) ~= 1))
    error('First input needs to be a vector and not a matrix');
elseif ((size(predict,1) ~= 1) && (size(predict,2) ~= 1))
    error('Second input needs to be a vector and not a matrix');
end
format short g;
n_class = length(classlist);
for i = 1:n_class
    obind_class_i = find(actual == classlist(i));
    prind_class_i = find(predict == classlist(i));
    confmatrix(i,i) = length(intersect(obind_class_i,prind_class_i));
    for j = 1:n_class
        %if (j ~= i)
        if (j < i)
            % observed j predicted i
            confmatrix(i,j) = length(find(actual(prind_class_i) == classlist(j))); 
            % observed i predicted j
            confmatrix(j,i) = length(find(predict(obind_class_i) == classlist(j)));
        end
    end
end

if (per == 1)
    confmatrix = (confmatrix ./ length(actual)).*100;
end
