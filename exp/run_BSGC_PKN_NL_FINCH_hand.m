%
%
%
clear;
clc;
data_path = fullfile(pwd, '..',  filesep, "data_sv", filesep,"select_data",filesep);
% data_path = fullfile(pwd, '..',  filesep,"test_data",filesep);
addpath(data_path);
lib_path = fullfile(pwd, '..',  filesep, "lib", filesep);
addpath(lib_path);
code_path = genpath(fullfile(pwd, '..',  filesep, "BSGC-2025", filesep));
addpath(code_path);


dirop = dir(fullfile(data_path, '*.mat'));
datasetCandi = {dirop.name};

exp_n = 'lambda_hand';
% profile off;
% profile on;
for i1 = 1 : length(datasetCandi)%
    data_name = datasetCandi{i1}(1:end-4);
    disp(data_name);
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
        %**************************************************************************
        % Parameter Configuration
        %**************************************************************************
        nRepeat = 10;
        seed = 50;
        % rng(seed);
        rng(seed,'twister');
        % Generate 50 random seeds
        random_seeds = randi([0, 1000000], 1, nRepeat);
        % Store the original state of the random number generator
        original_rng_state = rng;
        
        k_range = [5,10,15,20];
%         k_range = 20;
        lambda = 10.^[-6:1:6];
        entropy_range = 1;
        nMeasure = 14;
        
        %**************************************************************************
        % Construct As from Ks
        %**************************************************************************
        iParam = 0;
        nParam = length(k_range) * length(entropy_range)* length(lambda);
        BSGC_PKN_NL_FINCH_hand_result = zeros(nParam, 1, nRepeat, nMeasure);
        BSGC_PKN_NL_FINCH_hand_time = zeros(nParam, 1);
        
        for iKnn = 1:length(k_range)
            tic;
            knn_size = k_range(iKnn);
            % S0 = selftuning(X, knn_size);
            S0 = constructW_PKN_du(X', knn_size, 1);
            di = sum(S0, 1).^(-.5);
            Si = (di' .* di) .* S0;
            Si = (Si + Si')/2;
            t0 = toc;
            tic;
            %             % Li = eye(nSmp)-Si;
            Li = diag(sum(Si, 1)) + diag(sum(Si, 2)) - Si - Si';
            Ls = (Li + Li')/2;
            
            %**************************************************************************
            % Initialization Y0
            %**************************************************************************
            S0 = full(S0);
            label0 = finch_c(S0, nCluster);
            t1 = toc;
            
            for iEntropy = 1:length(entropy_range)
                for ilambda = 1:length(lambda)
                    iParam = iParam + 1;
                    disp([exp_n, ' iParam= ', num2str(iParam), ', totalParam= ', num2str(nParam)]);
                    fname3 = fullfile(prefix_mdcs, [data_name, '_12k_', exp_n, '_', num2str(iParam), '.mat']);
                    if exist(fname3, 'file')
                        load(fname3, 'result_11_s', 't0', 't1', 't2');
                        BSGC_PKN_NL_FINCH_hand_time(iParam) = t0 + t1 + t2/nRepeat;
                        for iRepeat = 1:nRepeat
                            BSGC_PKN_NL_FINCH_hand_result(iParam, 1, iRepeat, :) = result_11_s(iRepeat, :);
                        end
                    else
                        result_11_s = zeros(nRepeat, nMeasure);
                        result_all_iter = cell(nRepeat,1);
                        obj_all_iter = cell(nRepeat,1);
                        tic;
                        for iRepeat = 1:nRepeat
                            % label0 = litekmeans(H_normalized, nCluster, 'MaxIter', 50, 'Replicates', 10);
                            % label0 = kmeans(H_normalized, nCluster, 'MaxIter', 50, 'Replicates', 10);
                            % [label0, ~, ~] =  kmeanspp(H_normalized', nCluster);
                            % Restore the original state of the random number generator
                            rng(original_rng_state);
                            % Set the seed for the current iteration
                            rng(random_seeds(iRepeat));
                            label00 = label0;
                            rIdx = randperm(nSmp)';
                            r_ratio = 0.2;
                            label00(rIdx(1:ceil(nSmp*r_ratio))) = randi(nCluster, ceil(nSmp*r_ratio), 1);
                            Y0 = full(ind2vec(label00'))';
                            e_type = 9;
                            [label, objHistory, result_iter] = BSGC_entropy_hand_once(Ls, Y0, e_type, Y,lambda(ilambda));
                            result_all_iter{iRepeat,1}=result_iter;
                            obj_all_iter{iRepeat,1}= objHistory;
                            result_11 = my_eval_y_2025(label, Y);
                            result_11_s(iRepeat, :) = result_11';
                            BSGC_PKN_NL_FINCH_hand_result(iParam, 1, iRepeat, :) = result_11';
                            %      plot_converge_1v4(objHistory, result_iter(:, 1), result_iter(:, 2), result_iter(:, 3), result_iter(:, 5), exp_n, data_name, iParam, iRepeat);
                        end
                        t2 = toc;
                        BSGC_PKN_NL_FINCH_hand_time(iParam) = t0 + t1 + t2/nRepeat;
                        save(fname3, 'result_11_s', 't0', 't2', 't1', 'knn_size', 'e_type','result_all_iter','obj_all_iter');
                    end
                end
            end
            a1 = sum(BSGC_PKN_NL_FINCH_hand_result, 2);
            a3 = sum(a1, 3);
            a4 = reshape(a3, size(BSGC_PKN_NL_FINCH_hand_result,1), size(BSGC_PKN_NL_FINCH_hand_result,4));
            BSGC_PKN_NL_FINCH_hand_grid_result = a4/nRepeat;
            BSGC_PKN_NL_FINCH_hand_result_summary = [max(BSGC_PKN_NL_FINCH_hand_grid_result, [], 1), sum(BSGC_PKN_NL_FINCH_hand_time)/nParam];
            save(fname2, 'BSGC_PKN_NL_FINCH_hand_result', 'BSGC_PKN_NL_FINCH_hand_grid_result', 'BSGC_PKN_NL_FINCH_hand_time', 'BSGC_PKN_NL_FINCH_hand_result_summary','label','result_all_iter','obj_all_iter');
            disp([data_name, ' has been completed!']);
        end
    end
end

rmpath(data_path);
rmpath(lib_path);
rmpath(code_path);

% profile viewer