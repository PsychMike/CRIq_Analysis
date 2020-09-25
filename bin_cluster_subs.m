%% Bin subs by cluster

global use_vars all_labels use_ranks use_indivs indiv
% binning one_col two_col

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
% if ~all_labels
%     bin1 = {'newspaper','account','new_tech','children','driving','chores','garden'};
%     bin2 = {'cinema','concerts','reading','journeys','art'};
%     %     bin3 = {'social','volunteer','leisure_acts'};
%     %     bin4 = {'grandchildren','pets'};
%     % else
%     % Set bin labels for cognitive activities(CA) & social activities(SA)
%     %     bin1 = {'newspaper','chores','driving','new_tech','garden','art','reading','account'};
%     %     bin2 = {'social','grandchildren','concerts','children'};
%     %strict cogn
%     %     bin3 = {'newspaper','chores','driving','new_tech','garden','art','reading','account','leisure_acts','journeys','cinema'};
%     %incl cogn
%     %     bin3 = {'newspaper','chores','driving','new_tech','garden','art','reading','account','leisure_acts','journeys','cinema','volunteer','pets'};
%     %     bin4 = {'social','grandchildren','concerts','children'};
%     bin3 = {'newspaper','chores','driving','new_tech','garden','art','reading','account'};
%     bin4 = {'social','grandchildren','children'};
%     %     bin1 = {'volunteer','pets'};
%     %     bin2 = {'leisure_acts','cinema','volunteer','journeys','pets'};
% end
all_bins = item_labels;
% all_bins = {'newspaper','account','new_tech','children','driving','chores','garden', ...
%     'cinema','concerts','reading','journeys','art','social','volunteer','leisure_acts', ...
%     'grandchildren','pets'};

if use_indivs
    bin1 = all_bins(indiv);
    if indiv == 1
        bin2 = all_bins(2:end);
    else
        bin2 = all_bins(1:length(all_bins)~=indiv);
    end
else
    bin1 = {'newspaper','driving','garden','reading','concerts','cinema'};
    bin2 = {'chores','account','social','grandchildren','journeys','pets'};
end
if use_ranks
    leisurebyranking;
    bin3 = best_leis;
    bin4 = worst_leis;
else
    if all_labels
        bin3 = {'art','children','volunteer'};
        bin4 = {'new_tech','leisure_acts'};
    else
        bin3 = {'newspaper','chores','driving','new_tech','garden','art','reading','account'};
        bin4 = {'social','grandchildren','children'};
    end
end

% Find item indices
ibin1=zeros(1,length(bin1));ibin2=zeros(1,length(bin2));
% if all_labels
ibin3=zeros(1,length(bin3));ibin4=zeros(1,length(bin4));
% end
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
    %     if all_labels
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
    %     end
end

%% Find CRIq bin scores
% ages = criq_scores(:,1);
ageless_scores = criq_scores(:,2:end);
numerize_scores;

bin1_scores = num_scores(:,ibin1);
bin2_scores = num_scores(:,ibin2);
% if all_labels
bin3_scores = num_scores(:,ibin3);
bin4_scores = num_scores(:,ibin4);
% end
stand_count = 0;
[top1_scores,top1_subs,stand_bins,stand_count] = find_best_scores(bin1_scores,analysis_matrix,sub_nums,stand_count);
[top2_scores,top2_subs,stand_bins,stand_count] = find_best_scores(bin2_scores,analysis_matrix,sub_nums,stand_count,stand_bins);
% if all_labels
[top3_scores,top3_subs,stand_bins,stand_count] = find_best_scores(bin3_scores,analysis_matrix,sub_nums,stand_count,stand_bins);
[top4_scores,top4_subs,stand_bins,stand_count] = find_best_scores(bin4_scores,analysis_matrix,sub_nums,stand_count,stand_bins);
% end
%% Bin subjects

if use_vars
    find_topvars;
else
    find_best_bin;
end

function [top_scores,top_subs,stand_bins,stand_count] = find_best_scores(bin_scores_m,analysis_matrix,sub_nums,stand_count,stand_bins)
mean_bin = mean(bin_scores_m,2);
std_bin1 = std(mean_bin);
stand_bin1 = (mean_bin-mean(mean_bin))/std_bin1;
stand_count = stand_count + 1;
stand_bins(:,stand_count) = stand_bin1;

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