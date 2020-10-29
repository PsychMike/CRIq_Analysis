function [new_ft_data] = remove_outliers(mean_ft_data)

%Order data least to greatest
sorted_ft = sort(mean_ft_data);

%Find the median
med_sft = median(sorted_ft);

%Calculate median of lower & upper half of data
half_length = floor(length(sorted_ft/2));
up = sorted_ft(half_length+1:end);
low = sorted_ft(1:half_length);

up_med = median(up);
low_med = median(low);

%Calculate the difference
IQR = up_med - low_med;

%Define outlier values
up_outlier = med_sft + (IQR * 1.5);
down_outlier = med_sft - (IQR * 1.5);

%Find outlier values
outliers = sorted_ft(sorted_ft > up_outlier | sorted_ft < down_outlier);

new_count = 0;
if sum(outliers) ~= 0
    for i = 1:length(mean_ft_data)
        bad_out = 0;
        for o = 1:length(outliers)
            if mean_ft_data(i) == outliers(o)
                bad_out = 1;
            end
        end
        if bad_out == 0
            new_count = new_count + 1;
            new_ft_data(new_count,:) = mean_ft_data(i);
        end
    end
else
    new_ft_data = mean_ft_data;
end
end
