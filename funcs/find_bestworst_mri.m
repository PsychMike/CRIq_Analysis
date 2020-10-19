%% Find the corresponding MRI filenames

try
    clear best_mri_names worst_mri_names
end

b_mri_count = 0;
for i = 1:length(best_leis_subs)
    if sum(find(behav_nums==best_leis_subs(i)))
        index = find(behav_nums==best_leis_subs(i));
        b_mri_count = b_mri_count + 1;
        best_mri_nums(b_mri_count) = mri_nums(index);
        best_behav_nums(b_mri_count) = behav_nums(index);
        [file_num] = create_file_num(best_mri_nums,b_mri_count);
        best_mri_names{b_mri_count} = sprintf('/project/3015046.06/bids/sub-%s/anat/sub-%s_acq-MPRAGE_rec-norm_run-1_T1w.nii.gz',file_num,file_num);
    end
end

best_mri_nums = best_mri_nums(best_mri_nums>0);

w_mri_count = 0;

for i = 1:length(worst_leis_subs)
    if sum(find(behav_nums==worst_leis_subs(i)))
        index = find(behav_nums==worst_leis_subs(i));
        w_mri_count = w_mri_count + 1;
        worst_mri_nums(w_mri_count) = mri_nums(index);
        worst_behav_nums(w_mri_count) = behav_nums(index);
        [file_num] = create_file_num(worst_mri_nums,w_mri_count);
        worst_mri_names{w_mri_count} = sprintf('/project/3015046.06/bids/sub-%s/anat/sub-%s_acq-MPRAGE_rec-norm_run-1_T1w.nii.gz',file_num,file_num);
    end
end

worst_mri_nums = worst_mri_nums(worst_mri_nums>0);

%% Create Excel sheet of best/worst ft names

% Trim group subj nums to be equal
if length(best_mri_names) > length(worst_mri_names)
    best_mri_names = best_mri_names(1:length(worst_mri_names));
else
    worst_mri_names = worst_mri_names(1:length(best_mri_names));
end

T = table(best_mri_names',worst_mri_names','VariableNames',{'Best_FTs','Worst_FTs'});
Best_FTs = best_mri_names';
Worst_FTs = worst_mri_names';
rand_num = randi(99999999);

if write2table
    best = 'B';
    table_name = sprintf('output/%sb%dc%d%du%de%dm%di%d.mat',best,binning,one_col,two_col,uplow_quart,elim_outliers,more_subs,indiv);
    if exist(table_name,'file') 
        delete(table_name);
    end
    save(table_name,'Best_FTs');
    best = 'W';
    table_name = sprintf('output/%sb%dc%d%du%de%dm%di%d.mat',best,binning,one_col,two_col,uplow_quart,elim_outliers,more_subs,indiv);
    if exist(table_name,'file') 
        delete(table_name);
    end
    save(table_name,'Worst_FTs');
end
clear best_leis_data best_leis_subs best_fts best_is worst_leis_data worst_leis_subs worst_fts worst_is