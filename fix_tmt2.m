for i = 1:size(raw,1)
    
    if ~isempty(raw{i,40})
        try
            TMT_vals1 = str2num(raw{i,40});
        catch
            TMT_vals1 = raw{i,40};
        end
    else
        TMT_vals1 = NaN;
    end
    
    if ~isempty(raw{i,41})
        try
            TMT_vals2 = str2num(raw{i,41});
        catch
            TMT_vals2 = raw{i,41};
        end
    else
        TMT_vals2 = NaN;
    end
    
    if ~isnan(TMT_vals1) & ~isnan(TMT_vals2)
        TMT_vals(i) = 1-(TMT_vals2-TMT_vals1);
%         TMT_vals(i) =  100 - (TMT_vals1 + TMT_vals2);
    else
        TMT_vals(i) = NaN;
    end
    
end