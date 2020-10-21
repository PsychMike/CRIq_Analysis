function norm_vals = normalize_values(vals,normalize)

if normalize % normalizes scores
    %%
    sorted_ft = sort(vals);
    med_sft = median(sorted_ft);
    %Calculate median of lower & upper half of data
    up = sorted_ft(length(sorted_ft)/2+1:end);
    low = sorted_ft(1:length(sorted_ft)/2);
    
    up_med = median(up);
    low_med = median(low);
    
    %Calculate the difference
    IQR = up_med - low_med;
    
    %Define outlier values
    up_outlier = med_sft + (IQR * 1.5);
    down_outlier = med_sft - (IQR * 1.5);
    
    %Find outlier values
    outliers = sorted_ft(sorted_ft > up_outlier | sorted_ft < down_outlier);
    
    load sub_nums
    if elim_subouts && sum(outliers) ~= 0
        bad_count = bad_count + 1;
        bad_sub_i = (vals > up_outlier | vals < down_outlier);
        bad_sub_i = find(bad_sub_i==1);
        try
            bad_subs(bad_count:bad_count+length(bad_sub_i)-1) = sub_nums(bad_sub_i)'
        catch
            keyboard
        end
    end
    
    sorted_ft = sorted_ft(length(outliers)+1:end);
    %%
    %     min_val = min(vals);
    %     max_val = max(vals);
    min_val = min(sorted_ft);
    max_val = max(sorted_ft);
    diff_val = max_val - min_val;
    for i = 1:length(vals)
        curr_val = vals(i);
        norm_vals(i) = (curr_val - min_val)/diff_val;
    end
else
    norm_vals = vals;
end
if elim_subouts
save('sub_nums.mat','sub_nums','elim_subouts','bad_count','bad_subs');
end
end
% Example Data
% x = sample(-100:100, 50)
%
% %Normalized Data
% normalized = (x-min(x))/(max(x)-min(x))

% Histogram of example data and normalized data
% par(mfrow=c(1,2))
% hist(x,          breaks=10, xlab="Data",            col="lightblue", main="")
% hist(normalized, breaks=10, xlab="Normalized Data", col="lightblue", main="")