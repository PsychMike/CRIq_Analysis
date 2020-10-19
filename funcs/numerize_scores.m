%% Change CRIq score matrix to numeric
for row = 1:length(ageless_scores)
    for col = 1:size(ageless_scores,2)
        if isnumeric(ageless_scores{row,col})
            num_scores(row,col) = ageless_scores{row,col};
        else
            num_scores(row,col) = str2num(ageless_scores{row,col});
        end
    end
end