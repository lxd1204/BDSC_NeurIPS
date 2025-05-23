%
%
%
clear;
clc;
data_path = fullfile(pwd, '..',  filesep, "data_sv", filesep,"select_data",filesep);
addpath(data_path);
lib_path = fullfile(pwd, '..',  filesep, "lib", filesep);
addpath(lib_path);
% code_path = fullfile(pwd, '..',  filesep, "BSGC", filesep);
% addpath(code_path);


dirop = dir(fullfile(data_path, '*.mat'));
datasetCandi = {dirop.name};

% datasetCandi = {'FACS_v2_Trachea-counts_1013n_13741d_7c_uni.mat','hitech_2301n_22498d_6c_tfidf_uni.mat',...
%     'k1b_2340n_21839d_6c_tfidf_uni.mat','FACS_v2_Large_Intestine-counts_3362n_16418d_15c_uni.mat',...
%     'FACS_v2_Fat_3618n_15492d_9c_uni.mat',   'MNIST_4000n_784d_10c_uni.mat',...
%     'Macosko_6418n_8608d_39c_uni.mat','caltech101_silhouettes_8671n_784d_101c_28_uni.mat'};
exp_n = 'Spctral_randi_label';
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
        % Construct Si
        %**************************************************************************
        iParam = 0;
        nParam = length(entropy_range);
        agtBMKC12_result = zeros(nParam, 1, nRepeat, nMeasure);
        agtBMKC12_time = zeros(nParam, 1);
        
        
        
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
        % label0 = randi([1, nCluster], [nSmp, 1]);
        label0 = kmeans(X, nCluster, 'MaxIter', 50, 'Replicates', 10);
        t1 = toc;
        
        
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
            result_all_iter = cell(nRepeat,1);
            obj_all_iter = cell(nRepeat,1);
            tic;
            for iRepeat = 1:nRepeat
                rng(original_rng_state);
                % Set the seed for the current iteration
                rng(random_seeds(iRepeat));
                Y0 = full(ind2vec(label0'))';
                e_type = 15;
                label = litekmeans(Y0, nCluster, 'MaxIter', 50, 'Replicates', 10);
                result_11 = my_eval_y_2025(label, Y);
                result_11_s(iRepeat, :) = result_11';
                agtBMKC12_result(iParam, 1, iRepeat, :) = result_11';
                
            end
            t2 = toc;
            agtBMKC12_time(iParam) = t0 + t1 + t2/nRepeat;
            save(fname3, 'result_11_s', 't0', 't2', 't1');
        end
    else
        continue;
    end
    
    a1 = sum(agtBMKC12_result, 2);
    a3 = sum(a1, 3);
    a4 = reshape(a3, size(agtBMKC12_result,1), size(agtBMKC12_result,4));
    agtBMKC12_grid_result = a4/nRepeat;
    agtBMKC12_result_summary = [max(agtBMKC12_grid_result, [], 1), sum(agtBMKC12_time)/nParam];
    save(fname2, 'agtBMKC12_result', 'agtBMKC12_grid_result', 'agtBMKC12_time', 'agtBMKC12_result_summary','label','result_all_iter','obj_all_iter');
    disp([data_name, ' has been completed!']);
end
rmpath(data_path);
rmpath(lib_path);
% rmpath(code_path);

% profile viewer