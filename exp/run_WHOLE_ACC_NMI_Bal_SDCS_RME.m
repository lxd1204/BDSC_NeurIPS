%
%
%
clear;
clc;
data_path = fullfile(pwd,filesep, "selected_data_Sample_iter_5.14", filesep);
addpath(data_path);

dirop = dir(fullfile(data_path, '*.mat'));
datasetCandi = {dirop.name};

exp_n = '5.14_obj_ACC_NMI_SDCS';
nRepeat = 10;
for i1 =1 : length(datasetCandi)
    data_name = datasetCandi{i1}(1:end-4);
    dir_name = [pwd, filesep, exp_n, filesep, data_name];
    create_dir(dir_name);
    load(strcat(data_path, datasetCandi{i1}));
    
    
    hold off;
    
    for iRepeat =1 : nRepeat
        iterations = length(obj_whole_iter{iRepeat});
        x = [0:iterations-1]';
%         x =x -1;
        % plot_data objective function on the left axis
        objective_color = [0 0.4470 0.7410]; % A sharp blue
        acc_color = [0.8500 0.3250 0.0980];  % A vibrant orange
        %
        %         marker_obj = 'o'; % Circle markers for objective function
        %         marker_acc = 's'; % Square markers for ACC
        
        yyaxis left;
        plot(x, obj_whole_iter{iRepeat},  '-o','Color', objective_color, ...
            'LineWidth', 2.5, 'MarkerSize', 6.5,'MarkerFaceColor', 'none');
        %         plot(x, obj_whole_iter{iRepeat},'Color', objective_color, ...
        %             'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        % 设置 X 轴范围
        xlim([0, max(x)]);
        ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
        set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
        % 获取当前坐标轴对象
        ax = gca;
        ax.YAxis(1).Exponent = 3; % 设置左侧 Y 轴的指数显示
        
        % 设置左侧 Y 轴的刻度线和字体
        ax.YAxis(1).LineWidth = 3;
        ax.YAxis(1).FontWeight = 'bold';
        ax.YAxis(1).FontSize = 15;
        
        
        % plot_data ACC on the right axis
        yyaxis right;
        %         plot(x, result_all_iter{iRepeat}(:,1), 'Color', acc_color, ...
        %             'Marker', marker_acc, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        plot(x, res_whole_iter{iRepeat}(:,1),'--s','Color', acc_color, ...
            'LineWidth', 2.5, 'MarkerSize', 6.5,'MarkerFaceColor', 'none');
        xlim([0, max(x)]);
        %         ylim([0,1]);
        ylabel('ACC', 'Color', acc_color); % Right Y-axis
        set(gca, 'YColor', acc_color); % Set the right Y-axis color to match
        % 获取当前坐标轴对象
        ax = gca;
        
        % 设置右侧 Y 轴的刻度线和字体
        ax.YAxis(2).LineWidth = 3;
        ax.YAxis(2).FontWeight = 'bold';
        ax.YAxis(2).FontSize = 15;
        
        % 设置 X 轴的刻度线和字体
        ax.XAxis.LineWidth = 3;
        ax.XAxis.FontWeight = 'bold';
        ax.XAxis.FontSize = 15;
        
        % 设置边框线和网格线
        ax.LineWidth = 2.5; % 边框线宽度
        ax.BoxStyle = 'full'; % 确保边框线显示
        grid on;
        %     ax.GridLineWidth = 2; % 网格线宽度
        set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色
        set(gca, 'GridAlpha', 0.5); % 网格线透明度
        
        % 其他设置
        xlabel('Number of Iterations','FontSize', 15,'FontWeight' , 'bold');
        legend({'Obj', 'ACC'}, ...
            'Location', 'southeast', 'AutoUpdate','off'); % Custom legend  
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
        x = [0:iterations-1]';
        objective_color = [0 0.4470 0.7410]; % A sharp blue
        nmi_color = [0.4660 0.6740 0.1880]; % A bright green
        
        %         marker_obj = 'o'; % Circle markers for objective function
        %         marker_nmi = 'd'; % Diamond markers for NMI
        
        % plot_data objective function on the left axis
        yyaxis left;
        %                 plot(x, obj_whole_iter{iRepeat}, 'Color', objective_color, ...
        %                     'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        plot(x, obj_whole_iter{iRepeat}, '-o','Color', objective_color, ...
            'LineWidth', 2.5, 'MarkerSize', 6.5,'MarkerFaceColor', 'none');
        % 设置 X 轴范围
        xlim([0, max(x)]);
        ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
        set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
        % 获取当前坐标轴对象
        ax = gca;
        ax.YAxis(1).Exponent = 3; % 设置左侧 Y 轴的指数显示
        
        % 设置左侧 Y 轴的刻度线和字体
        ax.YAxis(1).LineWidth = 3;
        ax.YAxis(1).FontWeight = 'bold';
        ax.YAxis(1).FontSize = 15;
        
        % plot_data NMI on the right axis
        yyaxis right;
        %         plot(x, result_all_iter{iRepeat}(:,2),'Color', nmi_color, ...
        %             'Marker', marker_nmi, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        plot(x, res_whole_iter{iRepeat}(:,2),':d', 'Color', nmi_color, ...
            'LineWidth', 2.5, 'MarkerSize', 6.5,'MarkerFaceColor', 'none');
        xlim([0, max(x)]);
        %         ylim([0,1]);
        ylabel('NMI', 'Color', nmi_color); % Right Y-axis
        set(gca, 'YColor', nmi_color); % Set the right Y-axis color to match
        % 获取当前坐标轴对象
        ax = gca;
        
        % 设置右侧 Y 轴的刻度线和字体
        ax.YAxis(2).LineWidth = 3;
        ax.YAxis(2).FontWeight = 'bold';
        ax.YAxis(2).FontSize = 15;
        
        % 设置 X 轴的刻度线和字体
        ax.XAxis.LineWidth = 3;
        ax.XAxis.FontWeight = 'bold';
        ax.XAxis.FontSize = 15;
        
        % 设置边框线和网格线
        ax.LineWidth = 2.5; % 边框线宽度
        ax.BoxStyle = 'full'; % 确保边框线显示
        grid on;
        %     ax.GridLineWidth = 2; % 网格线宽度
        set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色
        set(gca, 'GridAlpha', 0.5); % 网格线透明度
        
        % 其他设置
        xlabel('Number of Iterations','FontSize', 15,'FontWeight' , 'bold');
        legend({'Obj', 'NMI'}, ...
            'Location','southeast', 'AutoUpdate','off'); % Custom legend
        
        % Ensure the box is on for both axes
        box on;
        
        % Overall adjustments
        set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
        %         hold off;
        pdf_dir = [exp_n, filesep, data_name];
        save2pdf(fullfile(pdf_dir, [data_name,'_NMI ', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
    end
%     for iRepeat =1 : nRepeat
%         iterations = length(obj_whole_iter{iRepeat});
%         x = [1:iterations]';
%         objective_color = [0 0.4470 0.7410]; % A sharp blue
%         bal_color = [0.4940 0.1840 0.5560];  % A deep purple
%         
%         % plot_data objective function on the left axis
%         yyaxis left;
%         
%         plot(x, obj_whole_iter{iRepeat},'-o', 'Color', objective_color, ...
%             'LineWidth', 2.5, 'MarkerSize', 6.5,'MarkerFaceColor', 'none');
%         % 设置 X 轴范围
%         xlim([1, length(x)]);
%         ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
%         set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
%         % 获取当前坐标轴对象
%         ax = gca;
%         ax.YAxis(1).Exponent = 1; % 设置左侧 Y 轴的指数显示
%         
%         % 设置左侧 Y 轴的刻度线和字体
%         ax.YAxis(1).LineWidth = 3;
%         ax.YAxis(1).FontWeight = 'bold';
%         ax.YAxis(1).FontSize = 15;
%         
%         yyaxis right;
%         %         plot(x, result_all_iter{iRepeat}(:,4), 'Color', bal_color, ...
%         %             'Marker', marker_bal, 'LineWidth', 1.5, 'MarkerSize', 1.5);
%         plot(x, res_whole_iter{iRepeat}(:,4),'-.v', 'Color', bal_color, ...
%             'LineWidth', 2.5, 'MarkerSize', 6.5,'MarkerFaceColor', 'none');
%         xlim([1, length(x)]);
%         %         ylim([0,1]);
%         ylabel('Bal', 'Color', bal_color); % Right Y-axis
%         set(gca, 'YColor', bal_color); % Set the right Y-axis color to match
%         % 获取当前坐标轴对象
%         ax = gca;
%         
%         % 设置右侧 Y 轴的刻度线和字体
%         ax.YAxis(2).LineWidth = 3;
%         ax.YAxis(2).FontWeight = 'bold';
%         ax.YAxis(2).FontSize = 15;
%         
%         % 设置 X 轴的刻度线和字体
%         ax.XAxis.LineWidth = 3;
%         ax.XAxis.FontWeight = 'bold';
%         ax.XAxis.FontSize = 15;
%         
%         % 设置边框线和网格线
%         ax.LineWidth = 2.5; % 边框线宽度
%         ax.BoxStyle = 'full'; % 确保边框线显示
%         grid on;
%         %     ax.GridLineWidth = 2; % 网格线宽度
%         set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色
%         set(gca, 'GridAlpha', 0.5); % 网格线透明度
%         
%         % 其他设置
%         xlabel('Number of Iterations','FontSize', 15,'FontWeight' , 'bold');
%         legend({'Obj', 'Bal'}, ...
%             'Location', 'northeast', 'AutoUpdate','off'); % Custom legend
%         
%         % Ensure the box is on for both axes
%         box on;
%         
%         % Overall adjustments
%         set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
%         %         hold off;
%         pdf_dir = [exp_n, filesep, data_name];
%         save2pdf(fullfile(pdf_dir, [data_name,'_BAL', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
%     end
    
%     for iRepeat = 1:nRepeat
%         iterations = length(obj_whole_iter{iRepeat});
%         x = (1:iterations)';
%         objective_color = [0 0.4470 0.7410]; % A sharp blue
%         sdcs_color = [0 0.5 0.5]; % A bright green
%         
%         % 左侧 Y 轴
%         yyaxis left;
%         plot(x, obj_whole_iter{iRepeat}, '-o', 'Color', objective_color, ...
%             'LineWidth', 2.5, 'MarkerSize', 6.5, 'MarkerFaceColor', 'none');
%         xlim([1, length(x)]);
%         ylabel('Objective Function Value', 'Color', objective_color);
%         set(gca, 'YColor', objective_color);
%         
%         % 获取当前坐标轴对象
%         ax = gca;
%         ax.YAxis(1).Exponent = 1; % 设置左侧 Y 轴的指数显示
%         
%         % 设置左侧 Y 轴的刻度线和字体
%         ax.YAxis(1).LineWidth = 3;
%         ax.YAxis(1).FontWeight = 'bold';
%         ax.YAxis(1).FontSize = 15;
%         
%         % 右侧 Y 轴
%         yyaxis right;
%         plot(x, res_whole_iter{iRepeat}(:, 5), ':x', 'Color', sdcs_color, ...
%             'LineWidth', 2.5, 'MarkerSize', 6.5, 'MarkerFaceColor', 'none');
%         xlim([1, length(x)]);
%         ylabel('SDCS', 'Color', sdcs_color);
%         set(gca, 'YColor', sdcs_color);
%         
%         % 获取当前坐标轴对象
%         ax = gca;
%         
%         % 设置右侧 Y 轴的刻度线和字体
%         ax.YAxis(2).LineWidth = 3;
%         ax.YAxis(2).FontWeight = 'bold';
%         ax.YAxis(2).FontSize = 15;
%         
%         % 设置 X 轴的刻度线和字体
%         ax.XAxis.LineWidth = 3;
%         ax.XAxis.FontWeight = 'bold';
%         ax.XAxis.FontSize = 15;
%         
%         % 设置边框线和网格线
%         ax.LineWidth = 2.5; % 边框线宽度
%         ax.BoxStyle = 'full'; % 确保边框线显示
%         grid on;
%         %     ax.GridLineWidth = 2; % 网格线宽度
%         set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色
%         set(gca, 'GridAlpha', 0.5); % 网格线透明度
%         
%         % 其他设置
%         xlabel('Number of Iterations','FontSize', 15,'FontWeight' , 'bold');
%         legend({'Obj', 'SDCS'}, 'Location', 'northeast', 'AutoUpdate', 'off');
%         box on;
%         set(gcf, 'Color', 'w'); % 设置图形背景为白色
%         
%         % 保存为 PDF
%         pdf_dir = [exp_n, filesep, data_name];
%         save2pdf(fullfile(pdf_dir, [data_name, '_SDCS ', '_Repeat_ ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
%     end
%     for iRepeat =1 : nRepeat
%         iterations = length(obj_whole_iter{iRepeat});
%         x = [1:iterations]';
%         objective_color = [0 0.4470 0.7410]; % A sharp blue
%         rme_color = [0.9290 0.6940 0.1250];  % A deep purple
%         
%         %         marker_obj = 'o'; % Circle markers for objective function
%         %         marker_bal = 'v';  % Triangle markers for NE
%         
%         % plot_data objective function on the left axis
%         yyaxis left;
%         %                 plot(x, obj_whole_iter{iRepeat}, 'Color', objective_color, ...
%         %                     'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
%         plot(x, obj_whole_iter{iRepeat},'-o', 'Color', objective_color, ...
%             'LineWidth', 2.5, 'MarkerSize', 5.5,'MarkerFaceColor', 'none');
%         % 设置 X 轴范围
%         xlim([1, length(x)]);
%         ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
%         set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
%         % 获取当前坐标轴对象
%         ax = gca;
%         ax.YAxis(1).Exponent = 1; % 设置左侧 Y 轴的指数显示
%         
%         % 设置左侧 Y 轴的刻度线和字体
%         ax.YAxis(1).LineWidth = 3;
%         ax.YAxis(1).FontWeight = 'bold';
%         ax.YAxis(1).FontSize = 15;
%         
%         
%         yyaxis right;
%         %         plot(x, result_all_iter{iRepeat}(:,4), 'Color', bal_color, ...
%         %             'Marker', marker_bal, 'LineWidth', 1.5, 'MarkerSize', 1.5);
%         plot(x, res_whole_iter{iRepeat}(:,6),'-.+', 'Color', rme_color, ...
%             'LineWidth', 2.5, 'MarkerSize', 6.5,'MarkerFaceColor', 'none');
%         xlim([1, length(x)]);
%         %         ylim([0,1]);
%         ylabel('RME', 'Color', rme_color); % Right Y-axis
%         set(gca, 'YColor', rme_color); % Set the right Y-axis color to match
%         
%         % 获取当前坐标轴对象
%         ax = gca;
%         
%         % 设置右侧 Y 轴的刻度线和字体
%         ax.YAxis(2).LineWidth = 3;
%         ax.YAxis(2).FontWeight = 'bold';
%         ax.YAxis(2).FontSize = 15;
%         
%         % 设置 X 轴的刻度线和字体
%         ax.XAxis.LineWidth = 3;
%         ax.XAxis.FontWeight = 'bold';
%         ax.XAxis.FontSize = 15;
%         
%         % 设置边框线和网格线
%         ax.LineWidth = 2.5; % 边框线宽度
%         ax.BoxStyle = 'full'; % 确保边框线显示
%         grid on;
%         %     ax.GridLineWidth = 2; % 网格线宽度
%         set(gca, 'GridColor', [0.8 0.85 0.9]); % 网格线颜色
%         set(gca, 'GridAlpha', 0.5); % 网格线透明度
%         
%         % 其他设置
%         xlabel('Number of Iterations','FontSize', 15,'FontWeight' , 'bold');
%         legend({'Obj', 'RME'}, ...
%             'Location', 'northeast', 'AutoUpdate','off'); % Custom legend
%         
%         % Ensure the box is on for both axes
%         box on;
%         
%         % Overall adjustments
%         set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
%         % hold off;
%         pdf_dir = [exp_n, filesep, data_name];
%         save2pdf(fullfile(pdf_dir, [data_name,'_RME', '_Repeat_ ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
%     end
%     
    
    disp([data_name, ' has been completed!']);
end

rmpath(data_path);



