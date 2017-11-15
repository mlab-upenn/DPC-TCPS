function [yData, leafIndex] = evalTree(regtree, xData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EVALTREE calculates predicted output using tree of class TREE
%
% Inputs:
%   xData : Training Features [nx, N]
%   regtree: regression tree function
%
% Outputs:
%   yData : Training Outputs [ny, N]
%
% Author:
%   Achin Jain
%   mLAB, UPenn
%
% Update History:
%   2016-03-21 : First version
%   2016-04-16 : Added condition for categorical variables
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NoOutput = size(regtree.Node{1}{4},1);
noObs = size(xData,2);
yData = zeros(NoOutput,noObs);
leafIndex = zeros(1,noObs);

for yidx = 1:noObs
    currentNode = 1;
    stop = 0;
    while ~stop
        splitVar = regtree.Node{currentNode}{1};
        splitVal = regtree.Node{currentNode}{2};
        if length(regtree.Node{currentNode})>7
            splitCatL = regtree.Node{currentNode}{8};
            splitCatR = regtree.Node{currentNode}{9};
        else
            splitCatL = [];
            splitCatR = [];
        end
        
        isTerminal = regtree.Node{currentNode}{5};
        
        if isTerminal
            stop = 1;
            yData(:,yidx) = mean(regtree.Node{currentNode}{4},2);
            leafIndex(1,yidx) = currentNode;
        else
            if isempty(splitCatL)||isempty(splitCatR)
                if xData(splitVar,yidx)<splitVal
                    currentNode = regtree.Node{currentNode}{6};
                else
                    currentNode = regtree.Node{currentNode}{7};
                end
            else
                if any(splitCatL==xData(splitVar,yidx))
                    currentNode = regtree.Node{currentNode}{6};
                else
                    currentNode = regtree.Node{currentNode}{7};
                end
            end
            
        end
        
    end
end