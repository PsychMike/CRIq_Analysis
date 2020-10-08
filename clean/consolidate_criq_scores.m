for i = 1:length(CRI_total_vals)
    if ~isnan(CRI_total_vals(i))
        CRI_all_vals(i) = CRI_total_vals(i);
    else
        CRI_all_vals(i) = worksheet(i,36);
    end
end