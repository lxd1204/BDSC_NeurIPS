function [y,objHistory,result_iter] = DBMGC_entropy_auto_once(Ls, Y, e_type,true_Y)
% DBMGC  Discrete Balanced Multiple Graph Clustering.
%   [y, w, obj] = DBMGC(K, Y)
%   K: n*n kernel matrix.
%   Y: n*c initial label indicator matrix.
%
[nSmp, nCluster]= size(Y);
%**************************************************************************
% Initialization w and Y
%**************************************************************************
% Lw = compute_Ls(Ls, w);
o1 = sum(sum(Y .* (Ls * Y)));
[~, o2] = generalized_entropy(sum(Y)',nSmp,nCluster, e_type);
objHistory = [];
result_iter = [];
for iter = 1:50
    %**********************************************************************
    % Update lambda, fix Y, w;
    %**********************************************************************
    
    lambda = o2 / (2 * o1);

    %**********************************************************************
    % Update Y, fix w, lambda;
    %**********************************************************************
    [Y, obj_Y] = solve_Y_entropy_auto_once(Ls, Y, lambda, e_type);
    label = vec2ind(Y')';
    result = my_eval_y(label, true_Y);
    unique_labels = unique(label);
    Num_cluster = zeros(1,nCluster);
    Num_cluster_1 = histcounts(label, [unique_labels; max(unique_labels)+1]);
    Num_cluster(1:length(Num_cluster_1)) = Num_cluster_1;
    [entropy,bal ,stDev, RME] = BalanceEvl(nCluster,Num_cluster);
    result_summary = [result',entropy,bal ,stDev, RME];
    result_iter = [result_iter; result_summary];
    %**********************************************************************
    % Update w, Yix Y;
    %**********************************************************************
%     e = compute_err(Ls, Y);
%     w = update_w(e);
%     Lw = compute_Ls(Ls, w);
   
    o1 = sum(sum(Y .* (Ls * Y)));
    [~,o2] = generalized_entropy(sum(Y)',nSmp,nCluster, e_type);
    obj = lambda*o1 - (lambda^2) * o2;
    objHistory = [objHistory; obj]; %#ok
    if iter > 2 && abs(objHistory(iter - 1) - objHistory(iter)) / abs(objHistory(iter - 1)) < 1e-10
        break;
    end
    
end
y = vec2ind(Y')';
end

function e = compute_err(Ls, Y)
nKernel = length(Ls);
e = zeros(nKernel, 1);
for iKernel = 1:nKernel
    LY = Ls{iKernel} * Y;
    e(iKernel) = sum(sum(Y .* LY));
end
end

function Lw = compute_Ls(Ls, w)
Lw = zeros(size(Ls{1}, 1));
for iKernel = 1:length(Ls)
    Lw = Lw + w(iKernel) * Ls{iKernel};
end
Lw = (Lw + Lw')/2;
end
