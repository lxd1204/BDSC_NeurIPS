%
%
%
clear;
clc;
data_path = fullfile(pwd, '..',  filesep, "data_sv", filesep,"select_data",filesep);
addpath(data_path);
lib_path = fullfile(pwd, '..',  filesep, "lib", filesep);
addpath(lib_path);
code_path = genpath(fullfile(pwd, '..',  filesep, "BSGC-2025", filesep));
addpath(code_path);


dirop = dir(fullfile(data_path, '*.mat'));
datasetCandi = {dirop.name};

exp_n = 'Randi_Label_square_1_1';
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
        nRepeat = 50;
        seed = 42;
        % rng(seed);
        rng(seed,'twister');
        % Generate 50 random seeds
        random_seeds = randi([0, 1000000], 1, nRepeat);
        % Store the original state of the random number generator
        original_rng_state = rng;
        
        
        entropy_range = 1;
        nMeasure = 14;
        
        %**************************************************************************
        % Construct As from Ks
        %**************************************************************************
        iParam = 0;
        nParam = length(entropy_range);
        BSGC_PKN_NL_FINCH_auto_result = zeros(nParam, 1, nRepeat, nMeasure);
        BSGC_PKN_NL_FINCH_auto_time = zeros(nParam, 1);
        
        tic;
        
            % S0 = selftuning(X, knn_size);
        S0 = constructW_PKN_du(X', 10, 1);
        di = sum(S0, 1).^(-.5);
        Si = (di' .* di) .* S0;
        Si = (Si + Si')/2;
        t0 = toc;
        tic;
        Li = eye(nSmp)-Si;
        Ls = (Li + Li')/2;
        
        %**************************************************************************
        % Initialization Y0
        %**************************************************************************
%         label0 = randi([1, nCluster], [nSmp, 1]);
        label0 = kmeans(X, nCluster, 'MaxIter', 50, 'Replicates', 10);
        t1 = toc;
        
        for iEntropy = 1:length(entropy_range)
            iParam = iParam + 1;
            disp([exp_n, ' iParam= ', num2str(iParam), ', totalParam= ', num2str(nParam)]);
            fname3 = fullfile(prefix_mdcs, [data_name, '_', exp_n, '_', num2str(iParam), '.mat']);
            if exist(fname3, 'file')
                load(fname3, 'result_11_s', 't0', 't1', 't2');
                BSGC_PKN_NL_FINCH_auto_time(iParam) = t0 + t1 + t2/nRepeat;
                for iRepeat = 1:nRepeat
                    BSGC_PKN_NL_FINCH_auto_result(iParam, 1, iRepeat, :) = result_11_s(iRepeat, :);
                end
            else
                result_11_s = zeros(nRepeat, nMeasure);
                result_all_iter = cell(nRepeat,1);
                obj_all_iter = cell(nRepeat,1);
                obj_whole_iter = cell(nRepeat,1);
                res_whole_iter = cell(nRepeat,1);
                tic;
                for iRepeat = 1:nRepeat
                    % label0 = litekmeans(H_normalized, nCluster, 'MaxIter', 50, 'Replicates', 10);
                    % label0 = kmeans(H_normalized, nCluster, 'MaxIter', 50, 'Replicates', 10);
                    % [label0, ~, ~] =  kmeanspp(H_normalized', nCluster);
                    % Restore the original state of the random number generator
                    rng(original_rng_state);
                    % Set the seed for the current iteration
                    rng(random_seeds(iRepeat));
                    Y0 = full(ind2vec(label0'))';
                    e_type = 9;
                    [label, objHistory, result_iter,objHistory_whole,res_whole_aio] = BSGC_entropy_auto_once(Ls, Y0, e_type, Y);
                    result_all_iter{iRepeat,1}=result_iter;
                    obj_all_iter{iRepeat,1}= objHistory;
                    obj_whole_iter{iRepeat,1}= objHistory_whole;
                    res_whole_iter{iRepeat,1}= res_whole_aio;
                    result_11 = my_eval_y_2025(label, Y);
                    result_11_s(iRepeat, :) = result_11';
                    BSGC_PKN_NL_FINCH_auto_result(iParam, 1, iRepeat, :) = result_11';
                    %                         plot_converge_1v4(objHistory, result_iter(:, 1), result_iter(:, 2), result_iter(:, 3), result_iter(:, 5), exp_n, data_name, iParam, iRepeat);
                end
                t2 = toc;
                BSGC_PKN_NL_FINCH_auto_time(iParam) = t0 + t1 + t2/nRepeat;
                save(fname3, 'result_11_s', 't0', 't2', 't1','e_type','obj_all_iter','obj_whole_iter','res_whole_iter');
            
            end
        end
    else
        continue;
    end
    a1 = sum(BSGC_PKN_NL_FINCH_auto_result, 2);
    a3 = sum(a1, 3);
    a4 = reshape(a3, size(BSGC_PKN_NL_FINCH_auto_result,1), size(BSGC_PKN_NL_FINCH_auto_result,4));
    BSGC_PKN_NL_FINCH_auto_grid_result = a4/nRepeat;
    BSGC_PKN_NL_FINCH_auto_result_summary = [max(BSGC_PKN_NL_FINCH_auto_grid_result, [], 1), sum(BSGC_PKN_NL_FINCH_auto_time)/nParam];
    save(fname2, 'BSGC_PKN_NL_FINCH_auto_result', 'BSGC_PKN_NL_FINCH_auto_grid_result', 'BSGC_PKN_NL_FINCH_auto_time', 'BSGC_PKN_NL_FINCH_auto_result_summary','label','result_all_iter','obj_all_iter','res_whole_iter');
    disp([data_name, ' has been completed!']);
end


rmpath(data_path);
rmpath(lib_path);
rmpath(code_path);

% profile viewer