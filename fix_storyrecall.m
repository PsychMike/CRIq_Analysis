for i = 1:length(story_recall_vals)
    
    try
        if isempty(txt{i+1,38})
            storyrecall_1 = worksheet(i,38);
        else
            storyrecall_1 = str2num(txt{i+1,38});
        end
    end
    try
        if isempty(txt{i+1,39})
            storyrecall_2 = worksheet(i,39);
        else
            storyrecall_2 = str2num(txt{i+1,39});
        end
    end
    
    try
        story_recall_vals(i) =  storyrecall_1 + storyrecall_2;
    catch
        story_recall_vals(i) = NaN;
    end
    
end