for i = 1:size(raw,1)
    
    if ~isempty(raw{i,40})
        try
            TMT_vals_1 = str2num(raw{i,40});
        catch
            TMT_vals_1 = raw{i,40};
        end
    else
        TMT_vals_1 = NaN;
    end
    
    if ~isempty(raw{i,41})
        try
            TMT_vals_2 = str2num(raw{i,41});
        catch
            TMT_vals_2 = raw{i,41};
        end
    else
        TMT_vals_2 = NaN;
    end
    
    if ~isnan(TMT_vals_1) & ~isnan(TMT_vals_2)
        TMT_vals(i) =  100 - (TMT_vals_1 + TMT_vals_2);
    else
        TMT_vals(i) = NaN;
    end
    
end