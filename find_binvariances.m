%% Find subjects with highest variances between bin scores
for i = 1:size(stand_bins,1)
    vars(i) = var(stand_bins(i,:));
end

vars = vars(good_indices==1);

med_var = median(vars);
top_count = 0;
for i = 1:length(vars)
    if vars(i) >= med_var
        top_count = top_count + 1;
        top_vars(top_count,1) = vars(i);
        top_vars(top_count,2) = sub_nums(i);
    end
end

var_indices = zeros(length(sub_nums),1);
for i = 1:length(sub_nums)
    for j = 1:size(top_vars,1)
        if sub_nums(i) == top_vars(j,2)
            var_indices(i) = 1;
        end
    end
end
% keyboard
