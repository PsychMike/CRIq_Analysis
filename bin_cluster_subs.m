%% Bin subs by cluster

% Grab leisure item scores
criq_l_scores = extract_scores(:,9:end);

% Leisure questionnaire category indices
weeki = 1:5;
monthi = 6:11;
yeari = 12:14;
fixi = 15:17;

% Set item labels
item_labels = {'newspaper','chores','driving','leisure_acts','new_tech','social','cinema','garden','grandchildren','volunteer','art','concerts','journeys','reading','children','pets','account'};

% Set item labels in bins
bin1 = {'newspaper','account','new_tech','children','driving','chores','garden'};
bin2 = {'cinema','concerts','reading','journeys','art'};
bin3 = {'social','volunteer','leisure_acts'};
bin4 = {'grandchildren','pets'};

% Find item indices
ibin1=zeros(1,length(bin1));ibin2=zeros(1,length(bin2));ibin3=zeros(1,length(bin3));ibin4=zeros(1,length(bin4));
bin1_count = 0;bin2_count = 0;bin3_count = 0;bin4_count = 0;
for i = 1:length(item_labels)
    for j = 1:length(bin1)
        if strcmp(item_labels{i},bin1{j})
            bin1_count = bin1_count + 1;
            ibin1(bin1_count) = i;
        end
    end
    for j = 1:length(bin2)
        if strcmp(item_labels{i},bin2{j})
            bin2_count = bin2_count + 1;
            ibin2(bin2_count) = i;
        end
    end
    for j = 1:length(bin3)
        if strcmp(item_labels{i},bin3{j})
            bin3_count = bin3_count + 1;
            ibin3(bin3_count) = i;
        end
    end
    for j = 1:length(bin4)
        if strcmp(item_labels{i},bin4{j})
            bin4_count = bin4_count + 1;
            ibin4(bin4_count) = i;
        end
    end
end

%% Find CRIq bin scores
ages = criq_scores(:,1);
ageless_scores = criq_scores(:,2:end);
numerize_scores

bin1_scores = num_scores(:,ibin1);
bin2_scores = num_scores(:,ibin2);
bin3_scores = num_scores(:,ibin3);
bin4_scores = num_scores(:,ibin4);

bin1_scores_m = bin1_scores;
bin2_scores_m = bin2_scores;
bin3_scores_m = bin3_scores;
bin4_scores_m = bin4_scores;

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

mean_bin1 = mean(bin1_scores_m,2);
std_bin1 = std(mean_bin1);
stand_bin1 = (mean_bin1-mean(mean_bin1))/std_bin1;

med_sbin1 = median(stand_bin1);
top_indices = stand_bin1>=med_sbin1;
top_bin1_scores = stand_bin1(top_indices);
top1_scores = analysis_matrix(top_indices,:);
top1_subs = sub_nums(top_indices);

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

med_sbin4 = median(stand_bin4);
top_indices = stand_bin4>=med_sbin4;
top_bin4_scores = stand_bin4(top_indices);
top4_scores = analysis_matrix(top_indices,:);
top4_subs = sub_nums(top_indices);

top_subs = zeros(63,4);
top_subs(1:length(top1_subs),1) = top1_subs;
top_subs(1:length(top2_subs),2) = top2_subs;
top_subs(1:length(top3_subs),3) = top3_subs;
top_subs(1:length(top4_subs),4) = top4_subs;

%% Bin subjects
try
    clear any_vals any_vals2 sub_score_mat sub_bin_mat
end

count = 0;
for i = 1:length(sub_nums)
    sub_num = sub_nums(i);
    if sum(sum(top_subs==sub_num))
        for col = 1:4
            any_vals = any(top_subs==sub_num);
            if any_vals(col)
                eval(sprintf('any_vals2 = any(top%d_subs==sub_num,2);',col));
                eval(sprintf('sub_score_mat(sub_num,%d) = top_bin%d_scores(any_vals2);',col,col));
            end
        end
        if max(sub_score_mat(sub_num,:)) > 0
            count = count + 1;
            bin = find(sub_score_mat(sub_num,:) == max(sub_score_mat(sub_num,:)));
            sub_bin_mat(count,1) = sub_num;
            sub_bin_mat(count,2) = bin;
        end
    end
end

% Remove duplicate binned subs
remove_dupes

% Include only complete datasets
try clear top1_c_scores top2_c_scores top3_c_scores top4_c_scores; end
for top_num = 1:4
eval(sprintf('count=0;for i = 1:length(uniq%d_scores);if ~sum(sum(isnan(uniq%d_scores(i,:))));count=count+1;top%d_c_scores(count,:) = top%d_scores(i,:);end;end',top_num,top_num,top_num,top_num));
end

% Find subs' behavioral data & bin it
try clear anova_matrix; end
for top_num = 1:4
eval(sprintf('count=0;sub_count=0;for i = 1:length(top%d_c_scores);sub_count = sub_count + 1;for j = 1:size(top%d_c_scores,2);count = count + 1;anova_matrix(count,:) = [top%d_c_scores(i,j) %d j sub_count];end;end',top_num,top_num,top_num,top_num));
end

BWAOV2(anova_matrix)

% for i = 1:length(nonan_best_fts)
%     sub_count = sub_count + 1;
%     for j = 1:size(nonan_best_fts,2)
%         count = count + 1;
%         anova_matrix(count,:) = [nonan_best_fts(i,j) 1 j sub_count];
%     end
% end
