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