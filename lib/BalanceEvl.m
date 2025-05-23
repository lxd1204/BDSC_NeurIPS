%% Normalized Entropy

% Evaluate the balance of the distribution of the clustering

function [entropy,bal ,stDev, RME] = BalanceEvl(k, N_cluster)

aa = [];
bb = [];
for i=1:k
    N = sum(N_cluster);
    Ni = N_cluster(i)+eps;
    a = Ni/N * log(Ni/N);
    aa(i) = a;
    b = (Ni-N/k)^2;
    bb(i) = b;
end
entropy = -1/(log(k)) * sum(aa);    % Entropy of the cluster distribution; (0,1)
stDev = (1/(k-1)*sum(bb))^(1/2);  % Standard deviation in cluster size (SDCS)
bal = min(N_cluster)/max(N_cluster);
RME = (min(N_cluster))/(N/k);     % ratio of minimum to expected (RME); (0,1)
end