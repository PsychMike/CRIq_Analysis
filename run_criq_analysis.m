clear all
global one_col two_col use_indivs

binning = 1;

use_indivs = 0;

% comps1 = [1;1;1;2;2;3];
% comps2 = [2;3;4;3;4;4];

comps1 = 0;
comps2 = 0;

if use_indivs
    indiv = 17;
else
    indiv = 1;
end

signif_count = 0;
for c = 1:length(comps1)
    signif = 0;
    one_col = comps1(c);
    two_col = comps2(c);
    %     for indiv = 1:indiv
    criq_analysis;
    if signif
        try load signifs.mat; end
        signif_count = signif_count + 1;
        signifs(signif_count,1) = c;
        signifs(signif_count,2:length(signif_points)+1) = signif_points;
        save('signifs.mat','signif*');
    end
    %     end
    if length(comps1) > 1
        load ANOVA_Tnametemp.mat
        load Tnames.mat
        T_names{c} = ANOVA_Tname;
        save('Tnames.mat','T_names');
    end
end
if length(comps1) > 1
    load Tnames.mat
    for t = 1:length(T_names)
        iT=readtable(T_names{t});
        gT(t,:)=iT;
    end
end
try gT; end
% keyboard