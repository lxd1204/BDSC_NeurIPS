%
%
%
clear;
clc;
data_path = fullfile(pwd, '..',  filesep, "data_sv", filesep,"middle_data",filesep);
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

exp_n = 'balance_data_value';
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
    
    fname2 = fullfile(prefix_mdcs, [data_name, '_', exp_n, '.mat']);
    if ~exist(fname2, 'file')
        unique_labels = unique(Y);
        Num_cluster = histcounts(Y, [unique_labels; max(unique_labels)+1]);
        [entropy,bal ,stDev, RME] = BalanceEvl(nCluster,Num_cluster);
        Balance_value = [entropy,bal ,stDev, RME]; 
        save(fname2,'Balance_value');
    end
end


rmpath(data_path);
rmpath(lib_path);
% rmpath(code_path);

% profile viewer