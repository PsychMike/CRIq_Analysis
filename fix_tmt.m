for i = 1:length(TMT_vals)
    
    try
        if isempty(txt{i+1,40})
            TMT_vals_1 = worksheet(i,40);
        else
            TMT_vals_1 = str2num(txt{i+1,40});
        end
    end
    try
        if isempty(txt{i+1,41})
            TMT_vals_2 = worksheet(i,41);
        else
            TMT_vals_2 = str2num(txt{i+1,41});
        end
    end
    
    try
        TMT_vals(i) =  TMT_vals_1 + TMT_vals_2;
    catch
        TMT_vals(i) = NaN;
    end
    
end