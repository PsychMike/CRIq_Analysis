%% Bin subs by cluster

% Grab leisure item scores
criq_l_scores = extract_scores(:,9:end);

% Number of cuts to make for choosing best scores
divid_num = 2;

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

[top1_scores,top1_subs] = find_best_scores(bin1_scores_m,analysis_matrix,sub_nums);
[top2_scores,top2_subs] = find_best_scores(bin2_scores_m,analysis_matrix,sub_nums);
[top3_scores,top3_subs] = find_best_scores(bin3_scores_m,analysis_matrix,sub_nums);
[top4_scores,top4_subs] = find_best_scores(bin4_scores_m,analysis_matrix,sub_nums);

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
    if sum(sum(top_subs==sub_num)) == 1
        for col = 1:4
            any_vals = any(top_subs==sub_num);
            if any_vals(col)
                eval(sprintf('any_vals2 = any(top%d_subs==sub_num,2);',col));
                eval(sprintf('sub_score_mat(sub_num,%d) = top%d_scores(any_vals2);',col,col));
            end
        end
        if max(sub_score_mat(sub_num,:)) > 0
            count = count + 1;
            bin = find(sub_score_mat(sub_num,:) == max(sub_score_mat(sub_num,:)));
            sub_bin_mat(count,1) = sub_num;
            try
                sub_bin_mat(count,2) = bin;
            catch
                sub_bin_mat(count,2) = 0;
            end
        end
    end
end

% Remove duplicate binned subs
find_uniq_subs

% Find unique subject scores
comb_matrix = zeros(size(analysis_matrix,1),size(analysis_matrix,2)+1);
comb_matrix(:,1) = sub_nums;
comb_matrix(:,2:end) = analysis_matrix;
uniq1_scores = find_scores(uniq1_subs,analysis_matrix,sub_nums,comb_matrix);
uniq2_scores = find_scores(uniq2_subs,analysis_matrix,sub_nums,comb_matrix);
uniq3_scores = find_scores(uniq3_subs,analysis_matrix,sub_nums,comb_matrix);
uniq4_scores = find_scores(uniq4_subs,analysis_matrix,sub_nums,comb_matrix);
% remove_dupes

% Include only complete datasets
try clear top1_c_scores top2_c_scores top3_c_scores top4_c_scores; end
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

top1_c_scores = uniq1_scores;
top2_c_scores = uniq2_scores;
top3_c_scores = uniq3_scores;
top4_c_scores = uniq4_scores;

% top1_c_scores = top1_c_scores(1:2,:);
% top2_c_scores = top2_c_scores(1:2,:);
% top3_c_scores = top3_c_scores(1:2,:);

% Find subs' behavioral data & bin it
try clear anova_matrix; end
count=0;
for top_num = 1:4
    eval(sprintf('sub_count=0;for i = 1:size(top%d_c_scores,1);sub_count = sub_count + 1;for j = 1:size(top%d_c_scores,2);count = count + 1;anova_matrix(count,:) = [top%d_c_scores(i,j) %d j sub_count];end;end',top_num,top_num,top_num,top_num));
end

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
BWAOV2(anova_matrix)

function [top_scores,top_subs] = find_best_scores(bin_scores_m,analysis_matrix,sub_nums)
mean_bin = mean(bin_scores_m,2);
std_bin1 = std(mean_bin);
stand_bin1 = (mean_bin-mean(mean_bin))/std_bin1;

med_sbin1 = median(stand_bin1);
top_indices = stand_bin1>=med_sbin1;
top_bin1_scores = stand_bin1(top_indices);

med_sbin1 = median(top_bin1_scores);
top_indices = stand_bin1>=med_sbin1;
top_bin1_scores = stand_bin1(top_indices);

top_scores = analysis_matrix(top_indices,:);
top_subs = sub_nums(top_indices);
end

function [bin_scores] = find_scores(binsub_nums,analysis_matrix,sub_nums,comb_matrix)
count = 0;
for i = 1:length(sub_nums)
    if any(binsub_nums==sub_nums(i))
        count = count + 1;
        bin_scores(count,:) = analysis_matrix(i,:);
    end
end

end