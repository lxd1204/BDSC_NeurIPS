function [y, objHistory, res_aio] = BSGC_entropy_hand_once(Ls, Y, e_type, gt,lambda)
% DBMGC  Discrete Balanced Multiple Graph Clustering.
%   [y, w, obj] = DBMGC(K, Y)
%   K: n*n kernel matrix.
%   Y: n*c initial label indicator matrix.
%

[nSmp, nCluster]= size(Y);
%**************************************************************************
% Initialization w and Y
%**************************************************************************

objHistory = [];
objHistory_whole = [];
res_aio = [];
% iter = 0;
% maxIter = 10;
% converges = false;
% while ~converges
for iter = 1:50
  
    %**********************************************************************
    % Update Y, fix w, lambda;
    %**********************************************************************
    [Y, obj_Y, res_Y] = solve_Y_entropy_auto_once(Ls, Y, lambda, e_type, gt);
    objHistory = [objHistory; obj_Y]; %#ok
    % label = vec2ind(Y')';
    if exist('gt', 'var')
        res_aio = [res_aio; full(res_Y)]; %#ok
    end
 
    o1 = sum(sum(Y .* (Ls * Y)));
    [~, o2] = generalized_entropy_202501(sum(Y)',nSmp,nCluster, e_type);
    obj_whole =  (lambda^2)*o1 - lambda * o2;
    objHistory_whole = [objHistory_whole; obj_whole]; %#ok
    if iter > 2 && abs(objHistory_whole(iter - 1) - objHistory(iter)) / abs(objHistory_whole(iter - 1)) < 1e-10
        break
    end
%     iter = iter + 1;
%     if iter > maxIter
%         converges = true;
%     end
end
y = vec2ind(Y')';
end


