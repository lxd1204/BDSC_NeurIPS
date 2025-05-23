%
%
%
clear;
clc;
data_path = fullfile(pwd, '..',  filesep, "data_sv", filesep,"small_data",filesep);
addpath(data_path);
lib_path = fullfile(pwd, '..',  filesep, "lib", filesep);
addpath(lib_path);


dirop = dir(fullfile(data_path, '*.mat'));
datasetCandi = {dirop.name};

% datasetCandi = {'FACS_v2_Trachea-counts_1013n_13741d_7c_uni.mat','hitech_2301n_22498d_6c_tfidf_uni.mat',...
%     'k1b_2340n_21839d_6c_tfidf_uni.mat','FACS_v2_Large_Intestine-counts_3362n_16418d_15c_uni.mat',...
%     'FACS_v2_Fat_3618n_15492d_9c_uni.mat',   'MNIST_4000n_784d_10c_uni.mat',...
%     'Macosko_6418n_8608d_39c_uni.mat','caltech101_silhouettes_8671n_784d_101c_28_uni.mat'};

exp_n = 'ICML_2025_v2_hand_svd_Y';
% profile off;
% profile on;
for i1 = 1 : length(datasetCandi)%
    data_name = datasetCandi{i1}(1:end-4);
    dir_name = [pwd, filesep, exp_n, filesep, data_name];
    try
        if ~exist(dir_name, 'dir')
            mkdir(dir_name);
        end
        prefix_mdcs = dir_name;
    catch
        disp(['create dir: ',dir_name, 'failed, check the authorization']);
    end
    
    clear X y Y;
    load(data_name);
    if exist('y', 'var')
        Y = y;
    end
    if size(X, 1) ~= size(Y, 1)
        Y = Y';
    end
    assert(size(X, 1) == size(Y, 1));
    nSmp = size(X, 1);
    nCluster = length(unique(Y));
    
    %*********************************************************************
    % BMGC
    %*********************************************************************
    fname2 = fullfile(prefix_mdcs, [data_name, '_', exp_n, '.mat']);
    if ~exist(fname2, 'file')
        % X= NormalizeFea(double(X));
        
        %**************************************************************************
        % Parameter Configuration
        %**************************************************************************
        nRepeat = 10;
        k_range = [5,10,15,20];
        lambda = 10.^[-6:1:6];
        entropy_range = 1;
        nMeasure = 14;
        
        %**************************************************************************
        % Construct Si
        %**************************************************************************
        iParam = 0;
        nParam = length(k_range) * length(entropy_range)* length(lambda);
        agtBMKC12_result = zeros(nParam, 1, nRepeat, nMeasure);
        agtBMKC12_time = zeros(nParam, 1);
        
        for iKnn = 1:length(k_range)
            tic;
            knn_size = k_range(iKnn);
            Si = constructW_PKN_du(X', knn_size, 1);
            di = sum(Si, 1).^(-.5);
            Si = (di' .* di) .* Si;
            Si = (Si + Si')/2;
            t0 = toc;
            tic;
            Li = eye(nSmp)-Si;
%             Li = diag(sum(Si, 1)) + diag(sum(Si, 2)) - Si - Si';
            Ls = (Li + Li')/2;
            
            %**************************************************************************
            % Initialization Y0
            %**************************************************************************    
            opt.disp = 0;
            [H, ~] = eigs(Ls, nCluster,'SA',opt);
            H_normalized = H ./ repmat(sqrt(sum(H.^2, 2)), 1,nCluster);
            t1 = toc;
            
            for iEntropy = 1:length(entropy_range)
                for ilambda = 1:length(lambda)
                    iParam = iParam + 1;
                    disp(['BMKC iParam= ', num2str(iParam), ', totalParam= ', num2str(nParam)]);
                    fname3 = fullfile(prefix_mdcs, [data_name, '_12k_', exp_n, '_', num2str(iParam), '.mat']);
                    if exist(fname3, 'file')
                        load(fname3, 'result_11_s', 't0', 't1', 't2');
                        agtBMKC12_time(iParam) = t0 + t1 + t2/nRepeat;
                        for iRepeat = 1:nRepeat
                            agtBMKC12_result(iParam, 1, iRepeat, :) = result_11_s(iRepeat, :);
                        end
                    else
                        result_11_s = zeros(nRepeat, nMeasure);
                        tic;
                        for iRepeat = 1:nRepeat
                            label0 = litekmeans(H_normalized, nCluster, 'MaxIter', 50, 'Replicates', 10);
                            % label0 = kmeans(H_normalized, nCluster, 'MaxIter', 50, 'Replicates', 10);
                            % [label0, ~, ~] =  kmeanspp(H_normalized', nCluster);
                            Y0 = full(ind2vec(label0'))';
                            
                            % e_type = entropy_range(iEntropy);
                            e_type = 15;
                            [label,obj,result_iter] = DBMGC_entropy_lambda_hand(Ls, Y0, e_type,Y,lambda(ilambda));
                            result_11 = my_eval_y(label, Y);
                            unique_labels = unique(label);
                            Num_cluster = zeros(1,nCluster);
                            Num_cluster_1 = histcounts(label, [unique_labels; max(unique_labels)+1]);
                            Num_cluster(1:length(Num_cluster_1)) = Num_cluster_1;
                            [entropy,bal ,stDev, RME] = BalanceEvl(nCluster,Num_cluster);
                            result_11_s(iRepeat, :) = [result_11',entropy,bal ,stDev, RME];
                            agtBMKC12_result(iParam, 1, iRepeat, :) = [result_11',entropy,bal ,stDev, RME];
                        end
                        t2 = toc;
                        agtBMKC12_time(iParam) = t0 + t1 + t2/nRepeat;
                        save(fname3, 'result_11_s', 't0', 't2', 't1', 'knn_size', 'e_type');
                    end
                end
            end
        end
        a1 = sum(agtBMKC12_result, 2);
        a3 = sum(a1, 3);
        a4 = reshape(a3, size(agtBMKC12_result,1), size(agtBMKC12_result,4));
        agtBMKC12_grid_result = a4/nRepeat;
        agtBMKC12_result_summary = [max(agtBMKC12_grid_result, [], 1), sum(agtBMKC12_time)/nParam];
        save(fname2, 'agtBMKC12_result', 'agtBMKC12_grid_result', 'agtBMKC12_time', 'agtBMKC12_result_summary');
        disp([data_name, ' has been completed!']);
    end
end

rmpath(data_path);
rmpath(lib_path);

% profile viewer