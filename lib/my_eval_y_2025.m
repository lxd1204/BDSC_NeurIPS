function [res]= my_eval_y_2025(y,Y)

[newIndx] = best_map(Y,y);
acc = mean(Y==newIndx);
nmi = mutual_info(Y,newIndx);
purity = pur_fun(Y,newIndx);
[AR,RI,MI,HI] = RandIndex(Y, newIndx);
fscore = 0;
precision = 0;
recall = 0;
% [fscore,precision,recall] = compute_f(Y, newIndx);
ys = sum(ind2vec(y'), 2);
nCluster = length(unique(y));
[entropy, bal, SDCS, RME] = BalanceEvl(nCluster, ys);

res = [acc; nmi; purity; AR; RI; MI; HI; fscore; precision; recall; entropy; bal; SDCS; RME]';