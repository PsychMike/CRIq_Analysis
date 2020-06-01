stand_mat = zeros(size(stand_bins,1),size(stand_bins,2));
for i = 1:size(stand_bins,1)
    max_bin = max(stand_bins(i,:));
    bin_num = find(stand_bins(i,:)==max_bin);
    stand_mat(i,bin_num) = 1;
end

top_scores = zeros(110,4); top_subs = zeros(110,4);
[top_scores,top_subs] = find_top_bins(stand_bins,stand_mat,1,top_scores,top_subs,sub_nums);
[top_scores,top_subs] = find_top_bins(stand_bins,stand_mat,2,top_scores,top_subs,sub_nums);
[top_scores,top_subs] = find_top_bins(stand_bins,stand_mat,3,top_scores,top_subs,sub_nums);
[top_scores,top_subs] = find_top_bins(stand_bins,stand_mat,4,top_scores,top_subs,sub_nums);

for k = 1:size(top_scores,2)
    nonzero_length(k) = sum(top_scores(:,k)~=0);
end

cut_length = max(nonzero_length);
top_scores = top_scores(1:cut_length,:);
top_subs = top_subs(1:cut_length,:);

function [top_scores,top_subs] = find_top_bins(stand_bins,stand_mat,i,top_scores,top_subs,sub_nums)
stand_mat_col = stand_mat(:,i);
stand_bin_col = stand_bins(:,i);
stand_col = stand_bin_col(stand_mat_col==1);
sub_num_col = sub_nums(stand_mat_col==1);
med_bin = median(stand_col);
top_indices = stand_col>=med_bin;
top_sub_nums = sub_num_col(top_indices);
top_bin_scores = stand_col(top_indices);
top_scores(1:length(top_bin_scores),i) = top_bin_scores;
top_subs(1:length(top_sub_nums),i) = top_sub_nums;
end