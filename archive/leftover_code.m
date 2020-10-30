% From bin_cluster_subs.m

for row = 1:length(bin2_scores)
    %     for col = 1:size(bin2_scores,2)
    %         try
    %             bin2_scores_m(row,col) = bin2_scores{row,col};
    %         catch
    %             bin2_scores_m(row,col) = str2num(bin2_scores{row,col});
    %         end
    %     end
end

mean_bin2 = mean(bin2_scores_m,2);
std_bin2 = std(mean_bin2);
stand_bin2 = (mean_bin2-mean(mean_bin2))/std_bin2;
sort_bin2 = sort(stand_bin2,'descend');
stand_bin2 = sort_bin2(1:floor(length(stand_bin2)/divid_num));

med_sbin2 = median(stand_bin2);
top_indices = stand_bin2>=med_sbin2;
top_bin2_scores = stand_bin2(top_indices);
top2_scores = analysis_matrix(top_indices,:);
top2_subs = sub_nums(top_indices);

for row = 1:length(bin3_scores)
    %     for col = 1:size(bin3_scores,2)
    %         try
    %             bin3_scores_m(row,col) = bin3_scores{row,col};
    %         catch
    %             bin3_scores_m(row,col) = str2num(bin3_scores{row,col});
    %         end
    %     end
end

mean_bin3 = mean(bin3_scores_m,2);
std_bin3 = std(mean_bin3);
stand_bin3 = (mean_bin3-mean(mean_bin3))/std_bin3;
sort_bin3 = sort(stand_bin3,'descend');
stand_bin3 = sort_bin3(1:floor(length(stand_bin3)/divid_num));

med_sbin3 = median(stand_bin3);
top_indices = stand_bin3>=med_sbin3;
top_bin3_scores = stand_bin3(top_indices);
top3_scores = analysis_matrix(top_indices,:);
top3_subs = sub_nums(top_indices);

for row = 1:length(bin4_scores)
    %     for col = 1:size(bin4_scores,2)
    %         try
    %             bin4_scores_m(row,col) = bin4_scores{row,col};
    %         catch
    %             bin4_scores_m(row,col) = str2num(bin4_scores{row,col});
    %         end
    %     end
end

mean_bin4 = mean(bin4_scores_m,2);
std_bin4 = std(mean_bin4);
stand_bin4 = (mean_bin4-mean(mean_bin4))/std_bin4;
sort_bin4 = sort(stand_bin4,'descend');
stand_bin4 = sort_bin4(1:floor(length(stand_bin4)/divid_num));

med_sbin4 = median(stand_bin4);
top_indices = stand_bin4>=med_sbin4;
top_bin4_scores = stand_bin4(top_indices);
top4_scores = analysis_matrix(top_indices,:);
top4_subs = sub_nums(top_indices);

for fold_code = 1
    % for row = 1:length(bin1_scores)
    %     for col = 1:size(bin1_scores,2)
    %         if isnumeric(bin1_scores{row,col})
    %             bin1_scores_m(row,col) = bin1_scores{row,col};
    %         else
    %             bin1_scores_m(row,col) = str2num(bin1_scores{row,col});
    %         end
    %     end
    % end
    
    % mean_ft = mean(new_ft_vals);
    % std_ft = std(new_ft_vals);
    % stand_fts = (new_ft_vals-mean_ft)/std_ft;
    % scaled_fts = stand_fts*15+100;
    % bin1_med = median(bin1_scores);
end

% top_subs = zeros(63,4);
% top_subs(1:length(top1_subs),1) = top1_subs;
% top_subs(1:length(top2_subs),2) = top2_subs;
% top_subs(1:length(top3_subs),3) = top3_subs;
% top_subs(1:length(top4_subs),4) = top4_subs;

% try
%     clear any_vals any_vals2 sub_score_mat sub_bin_mat
% end

% count = 0;
% for i = 1:length(sub_nums)
%     sub_num = sub_nums(i);
%     if sum(sum(top_subs==sub_num)) == 1
%         for col = 1:4
%             any_vals = any(top_subs==sub_num);
%             if any_vals(col)
%                 eval(sprintf('any_vals2 = any(top%d_subs==sub_num,2);',col));
%                 eval(sprintf('sub_score_mat(sub_num,%d) = top%d_scores(any_vals2);',col,col));
%             end
%         end
%         if max(sub_score_mat(sub_num,:)) > 0
%             count = count + 1;
%             bin = find(sub_score_mat(sub_num,:) == max(sub_score_mat(sub_num,:)));
%             sub_bin_mat(count,1) = sub_num;
%             try
%                 sub_bin_mat(count,2) = bin;
%             catch
%                 sub_bin_mat(count,2) = 0;
%             end
%         end
%     end
% end

% Remove duplicate binned subs
% find_uniq_subs

% Find unique subject scores
% comb_matrix = zeros(size(analysis_matrix,1),size(analysis_matrix,2)+1);
% comb_matrix(:,1) = sub_nums;
% comb_matrix(:,2:end) = analysis_matrix;
% uniq1_scores = find_scores(uniq1_subs,analysis_matrix,sub_nums,comb_matrix);
% uniq2_scores = find_scores(uniq2_subs,analysis_matrix,sub_nums,comb_matrix);
% uniq3_scores = find_scores(uniq3_subs,analysis_matrix,sub_nums,comb_matrix);
% uniq4_scores = find_scores(uniq4_subs,analysis_matrix,sub_nums,comb_matrix);
% remove_dupes

% Include only complete datasets
% try clear top1_c_scores top2_c_scores top3_c_scores top4_c_scores; end
% for top_num = 1:4
%     eval(sprintf('count=0;for i = 1:size(uniq%d_scores,1);if ~sum(sum(isnan(uniq%d_scores(i,:))));count=count+1;top%d_c_scores(count,:) = top%d_scores(i,:);end;end',top_num,top_num,top_num,top_num));
% end

% count = 0;
% for i = 1:size(uniq1_scores,1)
%     if ~sum(sum(isnan(uniq1_scores(i,:))))
%         count = count + 1;
%         try
%         top1_c_scores(count,:) = top1_scores(i,:);
%         catch
%             keyboard
%         end
%     end
% end

% top1_c_scores = uniq1_scores;
% top2_c_scores = uniq2_scores;
% top3_c_scores = uniq3_scores;
% top4_c_scores = uniq4_scores;

% top1_c_scores = top1_c_scores(1:2,:);
% top2_c_scores = top2_c_scores(1:2,:);
% top3_c_scores = top3_c_scores(1:2,:);

% Find subs' behavioral data & bin it
% try clear anova_matrix; end
% count=0;
% for top_num = 1:4
%     eval(sprintf('sub_count=0;for i = 1:size(top%d_c_scores,1);sub_count = sub_count + 1;for j = 1:size(top%d_c_scores,2);count = count + 1;anova_matrix(count,:) = [top%d_c_scores(i,j) %d j sub_count];end;end',top_num,top_num,top_num,top_num));
% end

% count = 0;
% sub_count = 0;
% for i = 1:size(top1_c_scores,1)
%     sub_count = sub_count + 1;
%     for j = 1:size(top1_c_scores,2)
%         count = count + 1;
%         try
%             anova_matrix(count,:) = [top1_c_scores(i,j) 1 j sub_count];
%         catch
%             keyboard
%         end
%     end
% end

% keyboard
% BWAOV2(anova_matrix)

    x = ages';
    y = CRI_leis_vals;
    x = x';
    y = y';
    format long
    b1 = x\y;
    if plot_ft == 2
        close all
        figure
    end
    yCalc1 = b1*x;
    if plot_ft == 2
        scatter(x,y)
        hold on
        plot(x,yCalc1)
        xlabel('Age')
        ylabel('Leisure Scores')
        title('Linear Regression Relation Between Age & Leisure Scores')
        grid on
    end
    X = [ones(length(x),1) x];
    b = X\y;
    yCalc2 = X*b;
    if plot_ft == 2
        plot(x,yCalc2,'--')
        legend('Data','Slope','Slope & Intercept','Location','best');
    end
    CRI_leis_vals = CRI_leis_vals - yCalc2';
    mean_ft = mean(CRI_leis_vals);
    std_ft = std(CRI_leis_vals);
    stand_fts = (CRI_leis_vals-mean_ft)/std_ft;
    if ~binning
        scaled_fts = stand_fts*15+100;
    else
        scaled_fts = stand_fts;
    end
    med_ft = median(scaled_fts); % Find best & worst subs and their data