function [m_ft_data,m_ft_subs,m_fts] = find_outliers2(ft_data,ft_subs,fts)

%% Find outliers
for i = 1:size(ft_data,1)
    mean_ft_data(i) = mean(ft_data(i,:));
end

%Order data least to greatest
sorted_ft = sort(mean_ft_data);

%Find the median
med_sft = median(sorted_ft);

%Calculate median of lower & upper half of data
up = sorted_ft(round(length(sorted_ft)/2)+1:end);
low = sorted_ft(1:round(length(sorted_ft)/2));

up_med = median(up);
low_med = median(low);

%Calculate the difference
IQR = up_med - low_med;

%Define outlier values
up_outlier = med_sft + (IQR * 1.5);
down_outlier = med_sft - (IQR * 1.5);

%Find outlier values
outliers = sorted_ft(sorted_ft > up_outlier | sorted_ft < down_outlier);

%% Remove outlier data
m_count = 0;
for i = 1:size(ft_data,1)
    if any(mean(ft_data(i,:))==outliers)
    else
        m_count = m_count + 1;
        m_ft_data(m_count,:) = ft_data(i,:);
        m_ft_subs(m_count) = ft_subs(i);
        m_fts(m_count) = fts(i);
    end
end

end