function regtree = buildTree(xData, yData, minLeaf, res, cat)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BUILDTREE outputs a regression tree for multi-output data using the
% approach in the book Elements of Statistical Learning [HTF]
%
% Inputs:
%   xData   : Training Features [nx, N]
%   yData   : Training Outputs [ny, N]
%   minLeaf : Minimum number of data points in the terminal nodes
%   res     : Resolution scale splitting values (larger the better)
%
% Outputs:
%   regtree: regression tree function
%
% Author:
%   Achin Jain
%   mLAB, UPenn
%
% Update History:
%   2016-03-17 : First version, single input
%   2016-03-21 : Adapted to multi output
%   2016-03-27 : Fixed a bug for minLeaf
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stop = false;

% initialize tree
regtree = tree();
[splitVar, splitVal, isTerminal] = splitNodes(xData, yData, res, minLeaf);
Parent = 0;
nodeCurrent = 1;
nodeTotal = 1;
data = cell(1,9);
data{1} = splitVar;
data{2} = splitVal;
data{3} = xData;
data{4} = yData;
data{5} = isTerminal;
if ~isTerminal
    nodeTotal = nodeTotal+1;
    data{6} = nodeTotal;
    nodeTotal = nodeTotal+1;
    data{7} = nodeTotal;
else
    data{6} = [];
    data{7} = [];
end
regtree = addnode(regtree, Parent, data);

% splitting
while ~stop
    
    isTerminal = regtree.Node{nodeCurrent}{5};
    if ~isTerminal
        
        splitVar = regtree.Node{nodeCurrent}{1};
        splitVal = regtree.Node{nodeCurrent}{2};
        x = regtree.Node{nodeCurrent}{3};
        y = regtree.Node{nodeCurrent}{4};
        
        % left node
        xL = x(:,x(splitVar,:)<splitVal);
        yL = y(:,x(splitVar,:)<splitVal);
        
        if ~isempty(yL)
            
            [splitVarNew, splitValNew, isTerminalNew] = splitNodes(xL, yL, res, minLeaf);
            Parent = Parent+1;
            data = cell(1,9);
            data{1} = splitVarNew;
            data{2} = splitValNew;
            data{3} = xL;
            data{4} = yL;
            data{5} = isTerminalNew;
            if ~isTerminalNew
                nodeTotal = nodeTotal+1;
                data{6} = nodeTotal;
                nodeTotal = nodeTotal+1;
                data{7} = nodeTotal;
            else
                data{6} = [];
                data{7} = [];
            end
            regtree = addnode(regtree, Parent, data);
        end
        
        % right node
        xR = x(:,x(splitVar,:)>=splitVal);
        yR = y(:,x(splitVar,:)>=splitVal);
        
        if ~isempty(yR)
            
            [splitVarNew, splitValNew, isTerminalNew] = splitNodes(xR, yR, res, minLeaf);
            Parent = Parent+1;
            data = cell(1,9);
            data{1} = splitVarNew;
            data{2} = splitValNew;
            data{3} = xR;
            data{4} = yR;
            data{5} = isTerminalNew;
            if ~isTerminalNew
                nodeTotal = nodeTotal+1;
                data{6} = nodeTotal;
                nodeTotal = nodeTotal+1;
                data{7} = nodeTotal;
            else
                data{6} = [];
                data{7} = [];
            end
            regtree = addnode(regtree, Parent, data);
        end
        
    end
    
    % stopping criteria
    if nodeCurrent == Parent+1
        stop = true;
    end
    
    % next node to expand
    nodeCurrent = nodeCurrent+1;
    disp(nodeCurrent);
end

end

function [splitVar, splitVal, isTerminal] = splitNodes(xData, yData, res, minLeaf)

if size(yData,2)< 2*minLeaf
    
    splitVar = [];
    splitVal = [];
    isTerminal = true;
    
else
       
    r = 1:1:size(xData,1);
    obj = zeros(length(r),res);
    
    for ridx = 1:length(r)
        s = linspace(min(xData(ridx,:)),max(xData(ridx,:)), res);
        for sidx = 1:length(s)
            
            ind_pos = xData(ridx,:)>=s(sidx);
            ind_neg = xData(ridx,:)<s(sidx);
            
            y_pos_mean = mean(yData(:,ind_pos),2);
            y_neg_mean = mean(yData(:,ind_neg),2);
            
            obj(ridx,sidx) = sum(sum((yData(:,ind_pos)-repmat(y_pos_mean,1,size(yData(:,ind_pos),2))).^2)) +...
                sum(sum((yData(:,ind_neg)-repmat(y_neg_mean,1,size(yData(:,ind_neg),2))).^2));
            
        end
    end
    
    [splitVar, splitVal] = optSplit(obj, xData, yData, res, minLeaf);
    isTerminal = false;
    
end
end

function [splitVar, splitVal] = optSplit(obj, xData, yData, res, minLeaf)

[a, b] = min(obj);
[~, d] = min(a);
splitVar = b(d);
s = linspace(min(xData(splitVar,:)),max(xData(splitVar,:)), res);
splitVal = s(d);

% while length(yData(:,xData(splitVar,:)<splitVal)) < minLeaf || length(yData(:,xData(splitVar,:)>=splitVal)) < minLeaf
while sum(xData(splitVar,:)<splitVal) < minLeaf || sum(xData(splitVar,:)>=splitVal) < minLeaf
    
    obj(b(d),d) = NaN;
    [a, b] = min(obj);
    [~, d] = min(a);
    splitVar = b(d);
    s = linspace(min(xData(splitVar,:)),max(xData(splitVar,:)), res);
    splitVal = s(d);
    
end

end