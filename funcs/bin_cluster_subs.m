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
all_bins = item_labels;

if use_indivs
    bin1 = all_bins(indiv)
    %     bin2 = all_bins(indiv)
    if indiv == 1
        bin2 = all_bins(2:end);
    else
        bin2 = all_bins(1:length(all_bins)~=indiv);
    end
%     bin2 = all_bins(all_bins~=bin1);
else
    bin1 = {'newspaper','driving','garden','reading','concerts','cinema'};
    bin2 = {'chores','account','social','grandchildren','journeys','pets'};
end
if use_ranks
    leisurebyranking;
    bin3 = best_leis(1:end);
    bin4 = worst_leis(1:end);
else
    if socog_binning
        bin3 = {'art','children','volunteer'};
        bin4 = {'new_tech','leisure_acts'};
    else
        bin3 = {'newspaper','chores','driving','new_tech','garden','art','reading','account'};
        bin4 = {'social','grandchildren','children'};
    end
end

% Find item indices
ibin1=zeros(1,length(bin1));ibin2=zeros(1,length(bin2));
ibin3=zeros(1,length(bin3));ibin4=zeros(1,length(bin4));
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
% ages = criq_scores(:,1);
ageless_scores = criq_scores(:,2:end);

% Change CRIq score matrix to numeric
for row = 1:length(ageless_scores)
    for col = 1:size(ageless_scores,2)
        if isnumeric(ageless_scores{row,col})
            num_scores(row,col) = ageless_scores{row,col};
        else
            num_scores(row,col) = str2num(ageless_scores{row,col});
        end
    end
end
num_scores2 = num_scores(:,8:end);
bin1_scores = num_scores2(:,ibin1);
bin2_scores = num_scores2(:,ibin2);
bin3_scores = num_scores2(:,ibin3);
bin4_scores = num_scores2(:,ibin4);

stand_count = 0;
[top1_scores,top1_subs,bot1_scores,bot1_subs,stand_bins,stand_count] = find_bw_scores(bin1_scores,analysis_matrix,sub_nums,stand_count);
[top2_scores,top2_subs,bot2_scores,bot2_subs,stand_bins,stand_count] = find_bw_scores(bin2_scores,analysis_matrix,sub_nums,stand_count,stand_bins);
[top3_scores,top3_subs,bot3_scores,bot3_subs,stand_bins,stand_count] = find_bw_scores(bin3_scores,analysis_matrix,sub_nums,stand_count,stand_bins);
[top4_scores,top4_subs,bot4_scores,bot4_subs,stand_bins,stand_count] = find_bw_scores(bin4_scores,analysis_matrix,sub_nums,stand_count,stand_bins);
%% Bin subjects

if use_vars
    find_topvars;
else
    find_best_bin;
end

function [top_scores,top_subs,bot_scores,bot_subs,stand_bins,stand_count] = find_bw_scores(bin_scores_m,analysis_matrix,sub_nums,stand_count,stand_bins)
mean_bin = mean(bin_scores_m,2);
std_bin1 = std(mean_bin);
stand_bin1 = (mean_bin-mean(mean_bin))/std_bin1;
stand_count = stand_count + 1;
stand_bins(:,stand_count) = stand_bin1;

med_sbin1 = median(stand_bin1);
top_indices = stand_bin1>=med_sbin1;
top_bin1_scores = stand_bin1(top_indices);
bot_indices = stand_bin1<med_sbin1;
bot_bin1_scores = stand_bin1(bot_indices);

med_sbin1 = median(top_bin1_scores);
top_indices = stand_bin1>=med_sbin1;
top_bin1_scores = stand_bin1(top_indices);

med_sbin2 = median(bot_bin1_scores);
bot_indices = stand_bin1<=med_sbin2;
bot_bin1_scores = stand_bin1(bot_indices);

top_scores = analysis_matrix(top_indices,:);
top_subs = sub_nums(top_indices);
bot_scores = analysis_matrix(bot_indices,:);
bot_subs = sub_nums(bot_indices);
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