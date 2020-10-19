%% Change worksheet SCWT values into usable values
for i = 1:length(stroop_vals)
    
    try
        if isempty(txt{i+1,44})
            w_score = worksheet(i,44);
        else
            w_score = str2num(txt{i+1,44});
        end
    end
    try
        if isempty(txt{i+1,45})
            c_score = worksheet(i,45);
        else
            c_score = str2num(txt{i+1,45});
        end
    end
    try
        if isempty(txt{i+1,46})
            cw_score = worksheet(i,46);
        else
            cw_score = str2num(txt{i+1,46});
        end
    end
    
    try
        stroop_vals(i) =  (c_score+w_score)/2-cw_score;
    catch
        stroop_vals(i) = NaN;
    end
    
end
