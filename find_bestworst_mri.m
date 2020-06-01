b_mri_count = 0;

try
    clear best_mri_names worst_mri_names
end

for i = 1:length(best_ft_subs)
    if sum(find(behav_nums==best_ft_subs(i)))
        index = find(behav_nums==best_ft_subs(i));
        b_mri_count = b_mri_count + 1;
        best_mri_nums(b_mri_count) = mri_nums(index);
        best_behav_nums(b_mri_count) = behav_nums(index);
        [file_num] = create_file_num(best_mri_nums,b_mri_count);
        best_mri_names{b_mri_count} = sprintf('/project/3015046.06/bids/sub-%s/anat/sub-%s_acq-MPRAGE_rec-norm_run-1_T1w.nii.gz',file_num,file_num);
    end
end

best_mri_nums = best_mri_nums(best_mri_nums>0);

w_mri_count = 0;

for i = 1:length(worst_ft_subs)
    if sum(find(behav_nums==worst_ft_subs(i)))
        index = find(behav_nums==worst_ft_subs(i));
        w_mri_count = w_mri_count + 1;
        worst_mri_nums(w_mri_count) = mri_nums(index);
        worst_behav_nums(w_mri_count) = behav_nums(index);
        [file_num] = create_file_num(worst_mri_nums,w_mri_count);
        worst_mri_names{w_mri_count} = sprintf('/project/3015046.06/bids/sub-%s/anat/sub-%s_acq-MPRAGE_rec-norm_run-1_T1w.nii.gz',file_num,file_num);
    end
end

worst_mri_nums = worst_mri_nums(worst_mri_nums>0);

%% Create Excel sheet of best/worst ft names
for i = 1:(length(best_mri_names)-length(worst_mri_names))
    worst_mri_names{end+1} = 'NaN';
end
for i = 1:(length(worst_mri_names)-length(best_mri_names))
    best_mri_names{end+1} = 'NaN';
end
T = table(best_mri_names',worst_mri_names','VariableNames',{'Best_FTs','Worst_FTs'});
% for i = 1:length(best_mri_names)
%     T.best_mri_names(i) = best_mri_names(i);
% end
rand_num = randi(99999999);
writetable(T,sprintf('output/%d_best_worst_fts.xls',rand_num));