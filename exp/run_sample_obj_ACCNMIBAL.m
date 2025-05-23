%
%
%
clear;
clc;
data_path = fullfile(pwd,filesep, "selected_OBJ", filesep);
addpath(data_path);

dirop = dir(fullfile(data_path, '*.mat'));
datasetCandi = {dirop.name};

exp_n = 'FINAL_SAMPLE_OBJ_ACCNMIOBJRME';
nRepeat = 10;
for i1 =1 : length(datasetCandi)
    data_name = datasetCandi{i1}(1:end-4);
    dir_name = [pwd, filesep, exp_n, filesep, data_name];
    create_dir(dir_name);
    load(strcat(data_path, datasetCandi{i1}));
    
    for iRepeat =1 : nRepeat
        iterations = length(obj_all_iter{iRepeat});
        x = [1:iterations]';
        hold off;
        objective_color = [0 0.4470 0.7410]; % A sharp blue
        acc_color = [0.8500 0.3250 0.0980]; 
        nmi_color = [0.4660 0.6740 0.1880];
        bal_color = [0.4940 0.1840 0.5560];% A vibrant orange
        rme_color = [0.9290 0.6940 0.1250];
        y_right_color = [0.5 0.2 0];
        yyaxis left;
        plot(x, obj_all_iter{iRepeat},  '-','Color', objective_color, ...
             'LineWidth', 2.5, 'MarkerSize', 5.5,'MarkerFaceColor', 'none');
%         plot(x, obj_whole_iter{iRepeat},'Color', objective_color, ...
%             'Marker', marker_obj, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        % 设置 X 轴范围
        xlim([1, length(x)]);
        ylabel('Objective Function Value', 'Color', objective_color); % Left Y-axis
        set(gca, 'YColor', objective_color); % Set the left Y-axis color to match
        ax = gca;
        ax.YAxis(1).Exponent = 3;
        
        % 设置左侧 Y 轴的刻度线和字体
        ax.YAxis(1).LineWidth = 3;
        ax.YAxis(1).FontWeight = 'bold';
        ax.YAxis(1).FontSize = 15;
        
        % plot_data ACC on the right axis
        yyaxis right;
%         plot(x, result_all_iter{iRepeat}(:,1), 'Color', acc_color, ...
%             'Marker', marker_acc, 'LineWidth', 1.5, 'MarkerSize', 1.5);
        plot(x, result_all_iter{iRepeat}(:,1),'--','Color', acc_color, ...
             'LineWidth', 2.5, 'MarkerSize', 5.5 ,'MarkerFaceColor', 'none');
        xlim([1, length(x)]);
%         ylim([0,1]);
        ylabel('ACC/NMI/Bal/RME', 'Color', y_right_color); % Right Y-axis
        set(gca, 'YColor', y_right_color); % Set the right Y-axis color to match
        
        hold on;
        plot(x, result_all_iter{iRepeat}(:,2),':', 'Color', nmi_color, ...
           'LineWidth', 2.5, 'MarkerSize', 5.5,'MarkerFaceColor', 'none');
        xlim([1, length(x)]);
        
        plot(x, result_all_iter{iRepeat}(:,4),'-.', 'Color', bal_color, ...
            'LineWidth', 2.5, 'MarkerSize', 5.5,'MarkerFaceColor', 'none');
        xlim([1, length(x)]);
        
        plot(x, result_all_iter{iRepeat}(:,6),'-.', 'Color', rme_color, ...
            'LineWidth', 2.5, 'MarkerSize', 5.5,'MarkerFaceColor', 'none');
        xlim([1, length(x)]);
        
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
        legend({'Obj', 'ACC','NMI','Bal','RME'}, ...
            'Location', 'northeast', 'AutoUpdate','off'); % Custom legend
        
        % Ensure the box is on for both axes
        box on;
        
        % Overall adjustments
        set(gcf, 'Color', 'w'); % Set figure background to white for a clean look
%         hold off;
        pdf_dir = [exp_n, filesep, data_name];
        save2pdf(fullfile(pdf_dir, [data_name,'_ACCNMIBAL ', '_Repeat ', num2str(iRepeat), '_', exp_n, '_converge.pdf']), gcf, 600);
    end
    
    disp([data_name, ' has been completed!']);
end

rmpath(data_path);



