for i = 1:length(CRI_ft_vals)
    if isnan(CRI_ft_vals(i))
        CRI_ft_vals(i) = worksheet(i,col_thirtyfive);
    end
end