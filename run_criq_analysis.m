clear all
global one_col two_col
binning = 1;

% comps1 = [1;1;1;2;2;3];
% comps2 = [2;3;4;3;4;4];

comps1 = 1;
comps2 = 2;

signif_count = 0;
for c = 1:length(comps1)
    signif = 0;
    one_col = comps1(c);
    two_col = comps2(c);
    for indiv = 1:17
        criq_analysis;
        if signif
            signif_count = signif_count + 1;
            signifs(signif_count,1) = c;
            signifs(signif_count,2:length(signif_points)+1) = signif_points;
        end
    end
end
% keyboard