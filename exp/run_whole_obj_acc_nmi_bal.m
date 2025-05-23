%
%
%
clear;
clc;
data_path = fullfile(pwd,filesep, "selected_OBJ", filesep);
addpath(data_path);

dirop = dir(fullfile(data_path, '*.mat'));
datasetCandi = {dirop.name};

exp_n = 'plot_WHOLE_ACC_NMI_OBJ_a';
nRepeat = 10;
for i1 =1 : length(datasetCandi)
    data_name = datasetCandi{i1}(1:end-4);
    dir_name = [pwd, filesep, exp_n, filesep, data_name];
    create_dir(dir_name);
    load(strcat(data_path, datasetCandi{i1}));
    
    
    hold off;
%     iterations = length(plot_data{1,1});
%     x = [1:iterations]';
    
    % Define custom colors and markers
%     objective_color = [0 0.4470 0.7410]; % A sharp blue
%     acc_color = [0.8500 0.3250 0.0980];  % A vibrant orange
%     nmi_color = [0.4660 0.6740 0.1880]; % A bright green
%     ne_color = [0.4940 0.1840 0.5560];  % A deep purple
%     rme_color = [0.9290 0.6940 0.1250]; % A bright yellow
%     marker_obj = 'o'; % Circle markers for objective function
%     marker_acc = 's'; % Square markers for ACC
%     marker_nmi = 'd'; % Diamond markers for NMI
%     marker_ne = 'v';  % Triangle markers for NE
%     marker_rme = '^'; % Triangle (up) markers for rme
    
    %     for iRepeat =1 : nRepeat
    %         % plot_data objective function on the left axis
    %         yyaxis left;
    %         plot_data(x, plot_data{iRepeat,5}, 'Color', objective_color, ...
    %             'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
    %         % 设置 X 轴范围
    %         xlim([1, length(x)]);
    %         ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
    %         set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
    %
    %         % plot_data ACC on the right axis
    %         yyaxis right;
    %         plot_data(x, plot_data{iRepeat,1}, 'Color', acc_color, ...
    %             'Marker', marker_acc, 'LineWidth', 1.5, 'MarkerSize', 1.5);
    %         xlim([1, length(x)]);
    %         ylim([0,1]);
    %         ylabel('ACC (%)', 'Color', acc_color); % Right Y-axis
    %         set(gca, 'YColor', acc_color); % Set the right Y-axis color to match
    %
    %         % Add additional plot_datas for NMI, NE, and rme on the right axis
    %         hold on; % Keep the previous plot_datas
    %         plot_data(x, plot_data{iRepeat,2}, 'Color', nmi_color, ...
    %             'Marker', marker_nmi, 'LineWidth', 1.5, 'MarkerSize', 1.5);
    %         xlim([1, length(x)]);
    %         plot_data(x, plot_data{iRepeat,3}, 'Color', ne_color, ...
    %             'Marker', marker_ne, 'LineWidth', 1.5, 'MarkerSize', 1.5);
    %         xlim([1, length(x)]);
    %         plot_data(x, plot_data{iRepeat,4}, 'Color', rme_color, ...
    %             'Marker', marker_rme, 'LineWidth', 1.5, 'MarkerSize', 1.5);
    %         xlim([1, length(x)]);
    %         % Common labels and settings
    %         xlabel('Number of Iterations');
    %         legend({'Objective Function', 'ACC', 'NMI', 'NE', 'RME'}, ...
    %             'Location', 'best', 'AutoUpdate','off'); % Custom legend
    %
    %         % Ensure the box is on for both axes
    %         box on;
    %
    %         % Overall adjustments
    %         set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
    %         hold off;
    %         pdf_dir = [exp_n, filesep, data_name];
    %         save2pdf(fullfile(pdf_dir, [data_name,'_ACC ', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
    %     end
    for iRepeat =1 : nRepeat
        iterations = length(obj_whole_iter{iRepeat});
        x = [1:iterations]';
        % plot_data objective function on the left axis
        objective_color = [0 0.4470 0.7410]; % A sharp blue
        acc_color = [0.8500 0.3250 0.0980];  % A vibrant orange
%         
%         marker_obj = 'o'; % Circle markers for objective function
%         marker_acc = 's'; % Square markers for ACC
    
        yyaxis left;
        plot(x, obj_whole_iter{iRepeat},  '-o','Color', objective_color, ...
             'LineWidth', 1.5, 'MarkerSize', 4,'MarkerFaceColor', 'none');
%         plot(x, obj_whole_iter{iRepeat},'Color', objective_color, ...
%             'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        % 设置 X 轴范围
        xlim([1, length(x)]);
        ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
        set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
       ax = gca;
       ax.YAxis(1).Exponent = 3;
        
        
        % plot_data ACC on the right axis
        yyaxis right;
%         plot(x, result_all_iter{iRepeat}(:,1), 'Color', acc_color, ...
%             'Marker', marker_acc, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        plot(x, res_whole_iter{iRepeat}(:,1),'--s','Color', acc_color, ...
             'LineWidth', 1.5, 'MarkerSize', 4,'MarkerFaceColor', 'none');
        xlim([1, length(x)]);
%         ylim([0,1]);
        ylabel('ACC', 'Color', acc_color); % Right Y-axis
        set(gca, 'YColor', acc_color); % Set the right Y-axis color to match
       
        grid on;
        % 设置网格样式
        set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色为灰色
        set(gca, 'GridAlpha', 0.5); % 网格线透明度为 0.5 
        % 设置网格线为十字格
        set(gca, 'XGrid', 'on', 'YGrid', 'on');
        
        
        % Common labels and settings
        xlabel('Number of Iterations');
        legend({'Obj', 'ACC'}, ...
            'Location', 'northeast', 'AutoUpdate','off'); % Custom legend
        
        % Ensure the box is on for both axes
        box on;
        
        % Overall adjustments
        set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
%         hold off;
        pdf_dir = [exp_n, filesep, data_name];
        save2pdf(fullfile(pdf_dir, [data_name,'_ACC ', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
    end
    for iRepeat =1 : nRepeat
        iterations = length(obj_whole_iter{iRepeat});
        x = [1:iterations]';
        objective_color = [0 0.4470 0.7410]; % A sharp blue
        nmi_color = [0.4660 0.6740 0.1880]; % A bright green
        
%         marker_obj = 'o'; % Circle markers for objective function 
%         marker_nmi = 'd'; % Diamond markers for NMI
        
        % plot_data objective function on the left axis
        yyaxis left;
%                 plot(x, obj_whole_iter{iRepeat}, 'Color', objective_color, ...
%                     'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
       plot(x, obj_whole_iter{iRepeat}, '-o','Color', objective_color, ...
             'LineWidth', 1.5, 'MarkerSize', 4,'MarkerFaceColor', 'none');
        % 设置 X 轴范围
        xlim([1, length(x)]);
        ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
        set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
        ax = gca;
       ax.YAxis(1).Exponent = 3;
        
        % plot_data NMI on the right axis
        yyaxis right;
%         plot(x, result_all_iter{iRepeat}(:,2),'Color', nmi_color, ...
%             'Marker', marker_nmi, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        plot(x, res_whole_iter{iRepeat}(:,2),':d', 'Color', nmi_color, ...
           'LineWidth', 1.5, 'MarkerSize', 4,'MarkerFaceColor', 'none');
        xlim([1, length(x)]);
%         ylim([0,1]);
        ylabel('NMI', 'Color', nmi_color); % Right Y-axis
        set(gca, 'YColor', nmi_color); % Set the right Y-axis color to match
        
        grid on;
        % 设置网格样式
        set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色为灰色
        set(gca, 'GridAlpha', 0.5); % 网格线透明度为 0.5 
        % 设置网格线为十字格
        set(gca, 'XGrid', 'on', 'YGrid', 'on');
        
        % Common labels and settings
        xlabel('Number of Iterations');
        legend({'Obj', 'NMI'}, ...
            'Location','northeast', 'AutoUpdate','off'); % Custom legend
        
        % Ensure the box is on for both axes
        box on;
        
        % Overall adjustments
        set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
%         hold off;
        pdf_dir = [exp_n, filesep, data_name];
        save2pdf(fullfile(pdf_dir, [data_name,'_NMI ', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
    end
    for iRepeat =1 : nRepeat
        iterations = length(obj_whole_iter{iRepeat});
        x = [1:iterations]';
        objective_color = [0 0.4470 0.7410]; % A sharp blue
        bal_color = [0.4940 0.1840 0.5560];  % A deep purple
        
%         marker_obj = 'o'; % Circle markers for objective function
%         marker_bal = 'v';  % Triangle markers for NE
    
        % plot_data objective function on the left axis
        yyaxis left;
%                 plot(x, obj_whole_iter{iRepeat}, 'Color', objective_color, ...
%                     'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
         plot(x, obj_whole_iter{iRepeat},'-o', 'Color', objective_color, ...
             'LineWidth', 1.5, 'MarkerSize', 4,'MarkerFaceColor', 'none');
        % 设置 X 轴范围
        xlim([1, length(x)]);
        ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
        set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
        ax = gca;
        ax.YAxis(1).Exponent = 3;
       
        yyaxis right;
%         plot(x, result_all_iter{iRepeat}(:,4), 'Color', bal_color, ...
%             'Marker', marker_bal, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        plot(x, res_whole_iter{iRepeat}(:,4),'-.v', 'Color', bal_color, ...
            'LineWidth', 1.5, 'MarkerSize', 4,'MarkerFaceColor', 'none');
        xlim([1, length(x)]);
%         ylim([0,1]);
        ylabel('Bal', 'Color', bal_color); % Right Y-axis
        set(gca, 'YColor', bal_color); % Set the right Y-axis color to match
        
        grid on;
        % 设置网格样式
        set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色为灰色
        set(gca, 'GridAlpha', 0.5); % 网格线透明度为 0.5 
        % 设置网格线为十字格
        set(gca, 'XGrid', 'on', 'YGrid', 'on');
        
        xlabel('Number of Iterations');
        legend({'Obj', 'Bal'}, ...
            'Location', 'northeast', 'AutoUpdate','off'); % Custom legend
        
        % Ensure the box is on for both axes
        box on;
        
        % Overall adjustments
        set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
%         hold off;
        pdf_dir = [exp_n, filesep, data_name];
        save2pdf(fullfile(pdf_dir, [data_name,'_BAL', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
    end
%     for iRepeat =1 : nRepeat
%         objective_color = [0 0.4470 0.7410]; % A sharp blue
%         rme_color = [0.9290 0.6940 0.1250]; % A bright yellow
%         marker_obj = 'o'; % Circle markers for objective function
%         marker_rme = '^'; % Triangle (up) markers for rme
%         % plot_data objective function on the left axis
%         yyaxis left;
%         plot(x, plot_data{iRepeat,5}, 'Color', objective_color, ...
%             'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
%         % 设置 X 轴范围
%         xlim([1, length(x)]);
%         ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
%         set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
%         
%         yyaxis right;
%         plot(x, plot_data{iRepeat,4}, 'Color', rme_color, ...
%             'Marker', marker_rme, 'LineWidth', 1.5, 'MarkerSize', 1.5);
%         xlim([1, length(x)]);
% %         ylim([0,1]);
%         ylabel('RME (%)', 'Color', rme_color); % Right Y-axis
%         set(gca, 'YColor', rme_color); % Set the right Y-axis color to match
%         
%         
%         
%         % Common labels and settings
%         xlabel('Number of Iterations');
%         legend({'Objective Function','RME'}, ...
%             'Location', 'best', 'AutoUpdate','off'); % Custom legend
%         
%         % Ensure the box is on for both axes
%         box on;
%         
%         % Overall adjustments
%         set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
% %         hold off;
%         pdf_dir = [exp_n, filesep, data_name];
%         save2pdf(fullfile(pdf_dir, [data_name,'_RME ', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
%     end
    
    disp([data_name, ' has been completed!']);
end

rmpath(data_path);



