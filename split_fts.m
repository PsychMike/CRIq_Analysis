clear all
criq_analysis;

med_ft = median(CRI_ft_vals(~isnan(CRI_ft_vals)));
mean_ft = mean(CRI_ft_vals(~isnan(CRI_ft_vals)));
best_count = 0;
worst_count = 0;

% try
%     clear best_fts
%     clear worst_fts
%     clear best_ft_data
% end

for i = 1:length(CRI_ft_vals)
    if ~isnan(CRI_ft_vals(i))
        if CRI_ft_vals(i) >= med_ft
            best_count = best_count + 1;
            best_fts(best_count) = CRI_ft_vals(i);
            best_is(best_count) = i;
            best_ft_data(best_count,:) = analysis_matrix(best_is(best_count),:);
            best_ft_subs(best_count) = sub_nums(i);
        else
            worst_count = worst_count + 1;
            worst_fts(worst_count) = CRI_ft_vals(i);
            worst_is(worst_count) = i;
            worst_ft_data(worst_count,:) = analysis_matrix(worst_is(worst_count),:);
            worst_ft_subs(worst_count) = sub_nums(i);
        end
    end
end

length(best_fts)
length(worst_fts)

fBest_ft_data = best_ft_data(~isnan(best_ft_data));
fWorst_ft_data = worst_ft_data(~isnan(worst_ft_data));

mean_fBest_ft = nanmedian(best_ft_data);
% mean(fBest_ft_data);
mean_fWorst_ft = nanmedian(worst_ft_data);
% mean(fWorst_ft_data);

plot_ft = 0;
if plot_ft
    close all
    figure
    plot(mean_fBest_ft);
    hold on
    plot(mean_fWorst_ft);
    xticks(1:12);
    xticklabels(var_names);
    xlim([0 13]);
    legend(sprintf('n = %d',length(best_ft_data)),sprintf('n = %d',length(worst_ft_data)))
    % avg_ft = avg(CRI_ft_vals(~isnan(CRI_ft_vals)))
end


m_best_ft_data = best_ft_data(:,6:end);
m_worst_ft_data = worst_ft_data(:,6:end);

for a = 1:2
    %     b = [m_best_ft_data;m_worst_ft_data];
    %     mod_wrksht = b(a);
    if a == 1
        mod_wrksht = m_best_ft_data;
    else
        mod_wrksht = m_worst_ft_data;
    end
    count = 0;
    for i = 1:length(mod_wrksht)
        skip_row = 0;
        for j = 1:size(mod_wrksht,2)
            if isnan(mod_wrksht(i,j))
                skip_row = 1;
            end
        end
        if ~skip_row
            count = count + 1;
            if a == 1
                nonan_best_fts(count,:) = mod_wrksht(i,:);
            else
                nonan_worst_fts(count,:) = mod_wrksht(i,:);
            end
        end
    end
end

count = 0; sub_count = 0;
anova_matrix = zeros((length(nonan_best_fts)+length(nonan_worst_fts)),4);
for i = 1:length(nonan_best_fts)
    sub_count = sub_count + 1;
    for j = 1:size(nonan_best_fts,2)
        count = count + 1;
        anova_matrix(count,:) = [nonan_best_fts(i,j) 1 j sub_count];
    end
end
for i = 1:length(nonan_worst_fts)
    sub_count = sub_count + 1;
    for j = 1:size(nonan_worst_fts,2)
        count = count + 1;
        anova_matrix(count,:) = [nonan_worst_fts(i,j) 2 j sub_count];
        %         anova_matrix(count,:) = [randi(100) 2 j sub_count];
        %         anova_matrix(count,:) = [nonan_best_fts(i,j)-2 2 j sub_count];
        
    end
end

run_anova = 0;
if run_anova
BWAOV2(anova_matrix)
end

read_studysheet