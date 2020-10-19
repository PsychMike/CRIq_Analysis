function norm_vals = normalize_values(vals,normalize)

if normalize
    % Normalizes scores
    for i = 1:length(vals)
        norm_vals(i) = (vals(i) - min(vals))/(max(vals)-min(vals));
    end
else
    norm_vals = vals;
end