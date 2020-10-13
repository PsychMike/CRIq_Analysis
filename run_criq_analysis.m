                    %% Runs CRIq analysis %%

%% Clean up old files/variables
clear vars
delete('output/*.mat','output/*.xls*','*.mat')

%% Set analysis parameters
%Write subject MRI pathnames to file?
write2table = 1;

%Eliminate outliers?
elim_outliers = 0;

%Normalize scores? (keep set at 1)
normalize = 1;

%Use the upper and lower quartile scores?
uplow_quart = 1;

%Include more subs in each group?
more_subs = 0;

%Cut sub nums to be equal between comparison groups?
cut_to_samesize = 0;

%Bin leis act types?
binning = 0;
if binning;use_vars=1;else;use_vars=0;end %if binning, use subjects who vary between compared bins

%Bin leis individually?
use_indivs = 0;
if use_indivs
    indiv_num = 17;
else
    indiv_num = 1;
end

%Use cog effort rankings to bin?
use_ranks = 0;

%Bin by social/intellectual?
socog_binning = 1; %formerly all_labels, value flipped
if use_indivs || use_ranks
    socog_binning = 0;
end

%Run all comparisons?
all_comps = 0;
if all_comps
    comps1 = [1;1;1;2;2;3];
    comps2 = [2;3;4;3;4;4];
else
    if binning
        comps1 = 3;
        comps2 = 4;
    else
        comps1 = 0;
        comps2 = 0;
    end
end

%Set to correct bins based on parameters
if use_ranks || socog_binning
    comps1 = 3;
    comps2 = 4;
elseif use_indivs
    comps1 = 1;
    comps2 = 2;
end

%% Run analysis
signif_count = 0;
for c = 1:length(comps1)
    signif = 0;
    one_col = comps1(c);
    two_col = comps2(c);
    for indiv = 1:indiv_num
        criq_analysis;
        if signif
            try load signifs.mat; end
            signif_count = signif_count + 1;
            signifs(signif_count,1) = c;
            signifs(signif_count,2:length(signif_points)+1) = signif_points;
            save('signifs.mat','signif*');
        end
        if length(comps1) > 1
            load ANOVA_Tnametemp.mat
            load Tnames.mat
            T_names{c} = ANOVA_Tname;
            save('Tnames.mat','T_names');
        end
    end
end
if length(comps1) > 1
    load Tnames.mat
    for t = 1:length(T_names)
        iT=readtable(T_names{t});
        gT(t,:)=iT;
    end
end

%% If all_comps, output ANOVA results for every comparison
if all_comps
    gT
end