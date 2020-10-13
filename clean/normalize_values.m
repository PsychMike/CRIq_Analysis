function norm_vals = normalize_values(vals,norm_score_vals)

% global norm_score_vals

if norm_score_vals
    % Normalizes scores
    for i = 1:length(vals)
        norm_vals(i) = (vals(i) - min(vals))/(max(vals)-min(vals));
    end
else
    norm_vals = vals;
end