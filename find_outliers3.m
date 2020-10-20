function [m_ft_data,m_ft_subs,m_fts] = find_outliers2(ft_data,ft_subs,fts)

%% Find outliers
% for i = 1:size(ft_data,1)
%     mean_ft_data(i) = mean(ft_data(i,:));
% end
outliers = 0;
m_count = 0;
for i = 1:size(ft_data,2)
    mean_ft_data = ft_data(:,i);
    
    %Order data least to greatest
    sorted_ft = sort(mean_ft_data);
    
    %Find the median
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
    
    %% Remove outlier data
    
    for j = 1:size(ft_data,1)
        m_count = j;
        if isempty(outliers)
%                     m_count = m_count + 1;
%             m_count = j
            try
                m_ft_data(m_count,i) = ft_data(j,i);
                m_ft_subs(m_count) = ft_subs(j);
                m_fts(m_count) = fts(j);
            catch
                keyboard
            end
        else
            o_count = 0;
            for o = 1:length(outliers)
                if ft_data(j,i) == outliers(o)
                    o_count = 1;
                end
            end
            if o_count == 0
%                 m_count = m_count + 1;
                m_ft_data(m_count,i) = ft_data(j,i);
                m_ft_subs(m_count) = ft_subs(j);
                m_fts(m_count) = fts(j);
            end
            %             keyboard
        end
    end
    % if length(outliers)>0
    % ft_data = m_ft_data;
    % ft_subs = m_ft_subs;
    % fts = m_fts;
    % end
    
    % m_count = 0;
    % for i = 1:size(ft_data,1)
    %     if any(mean(ft_data(i,:))==outliers)
    %     else
    %         m_count = m_count + 1;
    %         m_ft_data(m_count,:) = ft_data(i,:);
    %         m_ft_subs(m_count) = ft_subs(i);
    %         m_fts(m_count) = fts(i);
    %     end
    % end
end
mft2_count = 0;
for k = 1:size(ft_data,1)
    bad_sub = 0;
    for m = 1:size(ft_data,2)
        if ft_data(k,m) == 0
            bad_sub = 1;
        end
    end
    if ~bad_sub
        mft2_count = mft2_count+1;
        mft2_data(mft2_count,:) = ft_data(k,:);
        mft2_subs(mft2_count) = ft_subs(k);
        mft2s(mft2_count) = fts(i);
    end
end
m_ft_data = mft2_data;
m_ft_subs = mft2_subs;
m_fts = mft2s;
% keyboard
end