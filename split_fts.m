med_ft = median(CRI_ft_vals(~isnan(CRI_ft_vals)));
mean_ft = mean(CRI_ft_vals(~isnan(CRI_ft_vals)));
best_count = 0;
worst_count = 0;
try
    clear zbest_fts
    clear zworst_fts
end

for i = 1:length(CRI_ft_vals)
    if ~isnan(CRI_ft_vals(i))
        if CRI_ft_vals(i) >= med_ft
            best_count = best_count + 1;
            zbest_fts(best_count) = CRI_ft_vals(i);
        else
            worst_count = worst_count + 1;
            zworst_fts(worst_count) = CRI_ft_vals(i);
        end
    end
end

% avg_ft = avg(CRI_ft_vals(~isnan(CRI_ft_vals)))