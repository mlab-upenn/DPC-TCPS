function regtree = buildTree3(xData, yData, minLeaf, res, varargin)

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
%   2016-04-16 : Edit for categorical variables
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check for categorical variables
noOutputs = size(yData,1);
if nargin > 4 && ~isempty(varargin{1})
    catIdx = sort(varargin{1});
    noCatVars = length(catIdx);
    CATEGORICAL.xIndex = catIdx;
    for idx = 1:noCatVars
        catVal = unique(xData(catIdx(idx),:));
        meanY = zeros(noOutputs,length(catVal));
        dataPoints = false(length(catVal), size(yData,2));
        for idy = 1:length(catVal)
            dataPoints(idy,:) = xData(catIdx(idx),:)==catVal(idy);
            meanY(:,idy) = mean(yData(1, dataPoints(idy,:)),2);
        end
        [~, sortCatIdx] = sort(meanY,2);
%         CATEGORICAL.sortedValIdx{idx} = sortCatIdx;
        CATEGORICAL.val{idx} = catVal(sortCatIdx);
        
        % save for all outputs
%         catValIdx = zeros(noOutputs, size(yData,2), length(catVal));
%         for idz = 1:noOutputs
%            catValIdx(idz,:,:) = dataPoints(sortCatIdx(idz,:),:)';
%         end
        catValIdx = dataPoints(sortCatIdx(1,:),:);
        CATEGORICAL.catValIdx{idx} = catValIdx;
    end
else
    CATEGORICAL = [];
end

% initialize tree
regtree = tree();
[splitVar, splitVal, splitCatL, splitCatR, isTerminal] = splitNodes(xData, yData, res, minLeaf, CATEGORICAL);
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
            
            [splitVarNew, splitValNew, splitCatLNew, splitCatRNew, isTerminalNew] = splitNodes(xL, yL, res, minLeaf, CATEGORICAL);
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
            
            [splitVarNew, splitValNew, splitCatLNew, splitCatRNew, isTerminalNew] = splitNodes(xR, yR, res, minLeaf, CATEGORICAL);
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
    disp(nodeCurrent);
end

end

function [splitVar, splitVal, splitCatL, splitCatR, isTerminal] = splitNodes(xData, yData, res, minLeaf, CATEGORICAL)

if size(yData,2)< 2*minLeaf
    
    splitVar = [];
    splitVal = [];
    splitCatL = [];
    splitCatR = [];
    isTerminal = true;
    
else
    
    % categorical variables
    if ~isempty(CATEGORICAL)
        
        catIdx = CATEGORICAL.xIndex;
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
            
        end
        objCat = objCat(~cellfun('isempty', objCat));
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
            
            obj(ridx,sidx) = sum(sum((yData(:,ind_pos)-repmat(y_pos_mean,1,size(yData(:,ind_pos),2))).^2)) +...
                sum(sum((yData(:,ind_neg)-repmat(y_neg_mean,1,size(yData(:,ind_neg),2))).^2));
            
        end
    end
    obj(catIdx,:) = Inf;
    
    % decide the split
    [splitVar, splitVal, splitCatL, splitCatR] = optSplit(obj, objCat, CATEGORICAL, xData, yData, res, minLeaf);
    
    isTerminal = false;
    
end
end

function [splitVar, splitVal, splitCatL, splitCatR] = optSplit(obj, objCat, CATEGORICAL, xData, yData, res, minLeaf)

% continuous
[a, b] = min(obj);
[c, d] = min(a);
splitVar = b(d);
s = linspace(min(xData(splitVar,:)),max(xData(splitVar,:)), res);
splitVal = s(d);
splitCatL = [];
splitCatR = [];
stop = sum(xData(splitVar,:)<splitVal) < minLeaf || sum(xData(splitVar,:)>=splitVal) < minLeaf;
obj(b(d),d) = NaN;

if ~isempty(objCat)
    % categorical
    catIdx = CATEGORICAL.xIndex;
    noCatVars = length(catIdx);
    aCat = zeros(1,noCatVars);
    bCat = zeros(1,noCatVars);
    for idx = 1:noCatVars
        [aCat(idx), bCat(idx)] = min(objCat{idx});
    end
    [cCat, dCat] = min(aCat);
    
    if c>cCat
        splitVar = catIdx(dCat);
        [catVal, catValIdx] = findCategoricalIndex(xData, yData, splitVar);
        splitCatL = catVal(1:bCat(dCat));
        splitCatR = catVal(bCat(dCat)+1:end);
        
        ind_all = catValIdx;
        ind_neg = sum(ind_all(1:bCat(dCat),:),1)>0;
        ind_pos = sum(ind_all(bCat(dCat)+1:end,:),1)>0;
        stop = sum(ind_pos) < minLeaf || sum(ind_neg) < minLeaf;
    end
end


while stop
    
    obj(b(d),d) = NaN;
    [a, b] = min(obj);
    [c, d] = min(a);
    splitVar = b(d);
    s = linspace(min(xData(splitVar,:)),max(xData(splitVar,:)), res);
    splitVal = s(d);
    splitCatL = [];
    splitCatR = [];
    stop = sum(xData(splitVar,:)<splitVal) < minLeaf || sum(xData(splitVar,:)>=splitVal) < minLeaf;
    
    if ~isempty(objCat)
        % categorical
        objCat{dCat}(bCat(dCat)) = NaN;
        noCatVars = length(catIdx);
        aCat = zeros(1,noCatVars);
        for idx = 1:noCatVars
            [aCat(idx), bCat(idx)] = min(objCat{idx});
        end
        [cCat, dCat] = min(aCat);
        
        if c>cCat
            splitVar = catIdx(dCat);
            [catVal, catValIdx] = findCategoricalIndex(xData, yData, splitVar);
            splitCatL = catVal(1:bCat(dCat));
            splitCatR = catVal(bCat(dCat)+1:end);
            
            ind_all = catValIdx;
            ind_neg = sum(ind_all(1:bCat(dCat),:),1)>0;
            ind_pos = sum(ind_all(bCat(dCat)+1:end,:),1)>0;
            stop = sum(ind_pos) < minLeaf || sum(ind_neg) < minLeaf;
        end
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
[~, sortCatIdx] = sort(meanY,2);
catVal = catVal(sortCatIdx);
catValIdx = dataPoints(sortCatIdx(1,:),:);

end