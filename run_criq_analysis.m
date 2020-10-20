                        %% Runs CRIq analysis %%
clear vars
addpath tables funcs
%% Set analysis parameters

%Write subject MRI pathnames to file?
write2table = 1;

%Eliminate outliers?
elim_outliers = 1;

%Normalize scores? (keep set at 1)
normalize = 1;

%Use the upper and lower quartile scores?
uplow_quart = 1;

%Include (~333%) more subs in each group?
more_subs = 1;
perc_include = .95

%Cut sub nums to be equal between comparison groups?
cut_to_samesize = 1;

%Bin leis act types?
binning = 0;
if binning;use_vars=1;uplow_quart=0;else;use_vars=0;end %if binning, use subjects who vary between compared bins

%Bin leis individually?
use_indivs = 0;
if use_indivs
    indiv_num = 17;
else
    indiv_num = 1;
end

%Use cog effort rankings to bin?
use_ranks = 0;
if use_indivs; use_ranks = 0; end

%Bin by social/intellectual?
socog_binning = 0; %formerly all_labels, value flipped
if use_indivs || use_ranks
    socog_binning = 0;
end

%Run all comparisons?
all_comps = 1;
if ~binning || socog_binning || use_indivs || use_ranks; all_comps = 0; end
acomps1 = [1;1;1;2;2;3];
acomps2 = [2;3;4;3;4;4];
if all_comps
    binning = 1; use_vars = 1;
    comps1 = acomps1;
    comps2 = acomps2;
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

%% Find available MRI data
read_studysheet2

%% Run analysis
signif_count = 0;
for c = 1:length(comps1)
    
    %Clean up old files/variables
    clear vars
    copyfile('tables/Tnames.mat',sprintf('%s/clean/Tnames.mat',pwd));
    
    if c == 1
        delete('output/*.xls*');
        delete('output/*.mat');
    end
    copyfile(sprintf('%s/clean/Tnames.mat',pwd),'tables/Tnames.mat');
    
    signif = 0;
    one_col = comps1(c);
    two_col = comps2(c);
    for indiv = 1:indiv_num
        criq_analysis;
        if signif
            try load tables/signifs.mat; end
            signif_count = signif_count + 1;
            signifs(signif_count,1) = c;
            signifs(signif_count,2:length(signif_points)+1) = signif_points;
            save('tables/signifs.mat','signif*');
        end
        if length(comps1) > 1
            load tables/ANOVA_Tnametemp.mat
            load tables/Tnames.mat
            T_names{c} = ANOVA_Tname;
            save('tables/Tnames.mat','T_names');
        end
    end
end
if length(comps1) > 1
    load tables/Tnames.mat
    for t = 1:length(T_names)
        iT=readtable(T_names{t});
        gT(t,:)=iT;
    end
end

%% If all_comps, output ANOVA results for every comparison
if all_comps
    gT
end