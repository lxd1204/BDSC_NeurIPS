function [res]= my_eval_y_6_2025(y,Y)

[newIndx] = best_map(Y,y);
acc = mean(Y==newIndx);
nmi = mutual_info(Y,newIndx);
ys = sum(ind2vec(y'), 2);
nCluster = length(unique(y));

[entropy, bal, SDCS, RME] = BalanceEvl(nCluster, ys);
res = [acc, nmi, entropy, bal, SDCS, RME];
end