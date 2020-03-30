for i = 1:length(stroop_vals)
    
    try
        if isempty(txt{i+1,44})
            stroop_vals_1 = worksheet(i,44);
        else
            stroop_vals_1 = str2num(txt{i+1,44});
        end
    end
    try
        if isempty(txt{i+1,45})
            stroop_vals_2 = worksheet(i,45);
        else
            stroop_vals_2 = str2num(txt{i+1,45});
        end
    end
    try
        if isempty(txt{i+1,46})
            stroop_vals_3 = worksheet(i,46);
        else
            stroop_vals_3 = str2num(txt{i+1,46});
        end
    end
    
    try
        stroop_vals(i) =  stroop_vals_1 + stroop_vals_2 + stroop_vals_3;
    catch
        stroop_vals(i) = NaN;
    end
    
end