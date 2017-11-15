function regtree = buildTree(xData, yData, minLeaf, res, varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BUILDTREE outputs a regression tree for multi-output data using the
% approach in HTF-Elements of Statistical Learning
%
% Inputs:
%   xData   : Training Features [nx, N]
%   yData   : Training Outputs [ny, N]
%   minLeaf : Minimum number of data points in the terminal nodes
%   res     : Resolution scale splitting values (larger the better)
%   catIdx  : index of categorical variables
%
% Outputs:
%   regtree : regression tree function
%
% Author:
%   Achin Jain
%   mLAB, UPenn
%
% Update History:
%   2016-03-17 : First version, single input
%   2016-03-21 : Adapted to multi output
%   2016-03-27 : Fixed a bug for minLeaf
%   2016-04-16 : Added condition for categorical variables
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check for categorical variables
if nargin > 4 && ~isempty(varargin{1})
    catIdx = sort(varargin{1});
else
    catIdx = [];
end
if nargin > 5
    dispOn = varargin{2};
else
    dispOn = false;
end

% initialize tree
regtree = tree();
[splitVar, splitVal, splitCatL, splitCatR, isTerminal] = splitNodes(xData, yData, res, minLeaf, catIdx);
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
if isempty(splitCatL)||isempty(splitCatR)
    data{8} = [];
    data{9} = [];
else
    data{8} = splitCatL;
    data{9} = splitCatR;
end
regtree = addnode(regtree, Parent, data);

% splitting
stop = false;
while ~stop
    
    isTerminal = regtree.Node{nodeCurrent}{5};
    if ~isTerminal
        
        splitVar = regtree.Node{nodeCurrent}{1};
        splitVal = regtree.Node{nodeCurrent}{2};
        x = regtree.Node{nodeCurrent}{3};
        y = regtree.Node{nodeCurrent}{4};
        splitCatL = regtree.Node{nodeCurrent}{8};
        splitCatR = regtree.Node{nodeCurrent}{9};
        
        % left node
        if isempty(splitCatL)||isempty(splitCatR)
            xL = x(:,x(splitVar,:)<splitVal);
            yL = y(:,x(splitVar,:)<splitVal);
        else
            [catVal, catValIdx] = findCategoricalIndex(x, y, splitVar);
            splitPoint = find(catVal==splitCatL(end));
            leftIdx = sum(catValIdx(1:splitPoint,:),1)>0;
            xL = x(:,leftIdx);
            yL = y(:,leftIdx);
%             xL = x(:,x(splitVar,:)==splitCatL);
%             yL = y(:,x(splitVar,:)==splitCatL);
        end
        
        if ~isempty(yL)
            
            [splitVarNew, splitValNew, splitCatLNew, splitCatRNew, isTerminalNew] = splitNodes(xL, yL, res, minLeaf, catIdx);
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
            if isempty(splitCatLNew)||isempty(splitCatRNew)
                data{8} = [];
                data{9} = [];
            else
                data{8} = splitCatLNew;
                data{9} = splitCatRNew;
            end
            regtree = addnode(regtree, Parent, data);
        end
        
        % right node
        if isempty(splitCatL)||isempty(splitCatR)
            xR = x(:,x(splitVar,:)>=splitVal);
            yR = y(:,x(splitVar,:)>=splitVal);
        else
            rightIdx = sum(catValIdx(splitPoint+1:end,:),1)>0;
            xR = x(:,rightIdx);
            yR = y(:,rightIdx); 
%             xR = x(:,x(splitVar,:)==splitCatR);
%             yR = y(:,x(splitVar,:)==splitCatR);
        end
        
        if ~isempty(yR)
            
            [splitVarNew, splitValNew, splitCatLNew, splitCatRNew, isTerminalNew] = splitNodes(xR, yR, res, minLeaf, catIdx);
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
            if isempty(splitCatLNew)||isempty(splitCatRNew)
                data{8} = [];
                data{9} = [];
            else
                data{8} = splitCatLNew;
                data{9} = splitCatRNew;
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
    
    % display current iteration?
    if dispOn
        disp(nodeCurrent);
    end
end

end

function [splitVar, splitVal, splitCatL, splitCatR, isTerminal] = splitNodes(xData, yData, res, minLeaf, catIdx)

if size(yData,2)< 2*minLeaf
    
    splitVar = [];
    splitVal = [];
    splitCatL = [];
    splitCatR = [];
    isTerminal = true;
    
else
    
    % categorical variables
    if ~isempty(catIdx)
        
        objCat = cell(1, length(catIdx));
        
        for rCat = 1:length(catIdx)
            
            [catVal, catValIdx] = findCategoricalIndex(xData, yData, catIdx(rCat));
            
            for sCat = 1:length(catVal)-1
                
                ind_all = catValIdx;
                ind_neg = sum(ind_all(1:sCat,:),1)>0;
                ind_pos = sum(ind_all(sCat+1:end,:),1)>0;
                y_pos_mean = mean(yData(:,ind_pos),2);
                y_neg_mean = mean(yData(:,ind_neg),2);
                
                objCat{rCat}(sCat) = sum(sum((yData(:,ind_pos)-repmat(y_pos_mean,1,size(yData(:,ind_pos),2))).^2)) +...
                    sum(sum((yData(:,ind_neg)-repmat(y_neg_mean,1,size(yData(:,ind_neg),2))).^2));
                
            end
            if length(catVal)==1
                objCat{rCat} = Inf;
            end
        end
%         objCat = objCat(~cellfun('isempty', objCat));
    else
        objCat = [];
        catIdx = [];
    end
    
    % continuous variables
    r = 1:1:size(xData,1);
    obj = zeros(length(r),res);
    
    for ridx = 1:length(r)
        s = linspace(min(xData(ridx,:)), max(xData(ridx,:)), res);
        for sidx = 1:length(s)
            
            ind_pos = xData(ridx,:)>=s(sidx);
            ind_neg = xData(ridx,:)<s(sidx);
            
            y_pos_mean = mean(yData(:,ind_pos),2);
            y_neg_mean = mean(yData(:,ind_neg),2);
            
            % norm 2
            obj(ridx,sidx) = sum(sum((yData(:,ind_pos)-repmat(y_pos_mean,1,size(yData(:,ind_pos),2))).^2)) +...
                sum(sum((yData(:,ind_neg)-repmat(y_neg_mean,1,size(yData(:,ind_neg),2))).^2));
            
            % norm 1
%             obj(ridx,sidx) = sum(abs(yData(:,ind_pos)-repmat(y_pos_mean,1,size(yData(:,ind_pos),2)))) +...
%                 sum(abs(yData(:,ind_neg)-repmat(y_neg_mean,1,size(yData(:,ind_neg),2))));
            
        end
    end
    obj(catIdx,:) = Inf;
    
    % decide the split
    [splitVar, splitVal, splitCatL, splitCatR] = optSplit(obj, objCat, catIdx, xData, yData, res, minLeaf);
    
    isTerminal = false;
    
end
end

function [splitVar, splitVal, splitCatL, splitCatR] = optSplit(obj, objCat, catIdx, xData, yData, res, minLeaf)

% continuous
next = 1;
while next
    [a, b] = min(obj);
    [c, d] = min(a);
    splitVar = b(d);
    s = linspace(min(xData(splitVar,:)),max(xData(splitVar,:)), res);
    splitVal = s(d);
    splitCatL = [];
    splitCatR = [];
    next = sum(xData(splitVar,:)<splitVal) < minLeaf || sum(xData(splitVar,:)>=splitVal) < minLeaf;
    obj(b(d),d) = NaN;
end

% categorical
if ~isempty(objCat)
    
    noCatVars = length(catIdx);
    
    next = 1;
    while next
        aCat = zeros(1,noCatVars);
        bCat = zeros(1,noCatVars);
        for idx = 1:noCatVars
            [aCat(idx), bCat(idx)] = min(objCat{idx});
        end
        [cCat, dCat] = min(aCat);
        [catVal, catValIdx] = findCategoricalIndex(xData, yData, catIdx(dCat));
        ind_all = catValIdx;
        ind_neg = sum(ind_all(1:bCat(dCat),:),1)>0;
        ind_pos = sum(ind_all(bCat(dCat)+1:end,:),1)>0;
        next = sum(ind_pos) < minLeaf || sum(ind_neg) < minLeaf;
        objCat{dCat}(bCat(dCat)) = NaN;
        
        % terminate if no partition exists
        if all(isnan(objCat{dCat}))
            next = 0;
            cCat = Inf;
        end
    end
    
    if c>cCat
        splitVal = [];
        splitVar = catIdx(dCat);
        splitCatL = catVal(1:bCat(dCat));
        splitCatR = catVal(bCat(dCat)+1:end);
    end
    
end

end

function [catVal, catValIdx] = findCategoricalIndex(xData, yData, catIdx)

noOutputs = size(yData,1);
catVal = unique(xData(catIdx,:));
meanY = zeros(noOutputs,length(catVal));
dataPoints = false(length(catVal), size(yData,2));
for idy = 1:length(catVal)
    dataPoints(idy,:) = xData(catIdx,:)==catVal(idy);
    meanY(:,idy) = mean(yData(1, dataPoints(idy,:)),2);
end
% [~, sortCatIdx1] = sort(meanY,2);
[~, sortCatIdx] = sort(sum(meanY,1),2);
% if sum(sortCatIdx1(1,:)-sortCatIdx)~=0
%     keyboard;
% end
catVal = catVal(sortCatIdx(1,:));
catValIdx = dataPoints(sortCatIdx(1,:),:);

end