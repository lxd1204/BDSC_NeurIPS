function [y, objHistory, res_aio,objHistory_whole,res_whole_aio] = SC_L1_auto_once(label_init,Ls, Y,gt)
% DBMGC  Discrete Balanced Multiple Graph Clustering.
%   [y, w, obj] = DBMGC(K, Y)
%   K: n*n kernel matrix.
%   Y: n*c initial label indicator matrix.
%

%**************************************************************************
% Initialization w and Y
%**************************************************************************
% Lw = compute_Ls(Ls, w);
o1 = sum(sum(Y .* (Ls * Y)));
res_init= my_eval_y_6_2025(label_init, gt);
obj_init = o1;

objHistory = [];
objHistory_whole = [obj_init];
res_aio = [];
res_whole_aio = [res_init];
% iter = 0;
% maxIter = 10;
% converges = false;
% while ~converges
for iter = 1:50
   
    [Y, obj_Y, res_Y] = solve_SC_L1_Y_auto_once(Ls, Y, gt);
    objHistory = [objHistory; obj_Y]; %#ok
    % label = vec2ind(Y')';
    if exist('gt', 'var')
        res_aio = [res_aio; full(res_Y)]; %#ok
    end
 
    o1 = sum(sum(Y .* (Ls * Y)));
    obj_whole = o1;
    objHistory_whole = [objHistory_whole; obj_whole]; %#ok
    y = vec2ind(Y')';
    res_whole_iter = my_eval_y_6_2025(y, gt);
    res_whole_aio = [res_whole_aio; res_whole_iter];%#ok
    if iter > 2 && abs(objHistory_whole(iter - 1) - objHistory_whole(iter)) / abs(objHistory_whole(iter - 1)) < 1e-10
        break
    end
%     iter = iter + 1;
%     if iter > maxIter
%         converges = true;
%     end
end
y = vec2ind(Y')';
end








