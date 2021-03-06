function [m_ft_data,m_ft_subs,m_fts] = find_outliers(ft_data,ft_subs,fts)

%% Find outliers
for i = 1:size(ft_data,2)
    
    %Order data least to greatest
    sorted_ft = sort(ft_data(:,i));
    
    %Find the median
    med_sft = median(sorted_ft);
    
    %Calculate median of lower & upper half of data
    up = sorted_ft(length(sorted_ft)/2+1:end);
    low = sorted_ft(1:length(sorted_ft)/2);
    
    up_med = median(up)
    low_med = median(low)
    
    %Calculate the difference
    IQR = up_med - low_med;
    
    %Define outlier values
    up_outlier = med_sft + (IQR * 1.5);
    down_outlier = med_sft - (IQR * 1.5);
    
    %Find outlier values
    outliers{i} = sorted_ft(sorted_ft > up_outlier | sorted_ft < down_outlier);
end

%% Remove outlier data
try clear m_ft_data; end
new_ft_data = zeros(size(ft_data));
for i = 1:size(ft_data,2)
    outlier_vals = outliers{i};
    for j = 1:size(ft_data,1)
        if ~any(ft_data(j,i)==outlier_vals)
            new_ft_data(j,i) = ft_data(j,i);
        else
            new_ft_data(j,i) = NaN;
        end
    end
end
count = 0;
for j = 1:size(new_ft_data,1)
    if ~sum(isnan(new_ft_data(j,:)))
        count = count + 1;
        m_ft_data(count,:) = new_ft_data(j,:);
        try
        m_ft_subs(count) = ft_subs(j);
        m_fts(count) = fts(j);
        catch
            keyboard
        end
    end
end

end