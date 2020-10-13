%% Only include subs with complete data
mod_wrksht = analysis_matrix;
count = 0;

for i = 1:size(analysis_matrix,1)
    skip_row = 0;
    for j = 1:size(mod_wrksht,2)
        if isnan(mod_wrksht(i,j))
            skip_row = 1;
        end
    end
    if ~skip_row
        count = count + 1;
        complete_subs(count,:) = mod_wrksht(i,:);
    end
end