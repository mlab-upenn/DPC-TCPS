function [idLeaf, meanLeaf, idWrongSplit] = findLeaves(regtree, varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FINDLEAVES finds terminal nodes and the average values at these nodes. It 
% also checks if any leaf has number of data points less than minLeaf
%
% Inputs:
%   regtree : regression tree function
%   minLeaf : minimum data points in the terminal node
%
% Outputs:
%   idLeaf       : index of the leaves
%   idWrongSplit : index of leaves which have data points less than minLeaf
%
% Author:
%   Achin Jain
%   mLAB, UPenn
%
% Update History:
%   2016-04-17 : First version
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idLeaf = [];
meanLeaf = [];
idWrongSplit = [];
for idx = 1:size(regtree.Parent,1)
    if regtree.Node{idx}{5} ==1
        if nargin>1
            minLeaf = varargin{1};
            if size(regtree.Node{idx}{4},2)<minLeaf
                idWrongSplit = [idWrongSplit, idx];
            end
        end
        idLeaf = [idLeaf, idx];
        meanLeaf = [meanLeaf, mean(regtree.Node{idx}{4},2)];
    end
end
