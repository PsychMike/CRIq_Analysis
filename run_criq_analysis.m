%% Runs CRIq analysis %%
clear all; close all
addpath tables funcs StatsFunctions
%% Set analysis parameters

global perc_include

%Write subject MRI pathnames to file?
write2table = 0;

%Run ANOVA or perm_test?
anova = 1;
perm = 0;

%Plot results?
plot_ft = 1;

%Eliminate outliers?
elim_outliers = 0;
outlie_indiv = 0;
elim_subouts = 0;
elim_indiv = 0;

%Normalize scores? (keep set at 1)
normalize = 1;

%Include more subs in each group?
more_subs = 1;
perc_include = 100;

%Cut sub nums to be equal between comparison groups?
cut_to_samesize = 1;

%Bin leis act types?
binning = 1;

%Bin leis individually?
use_indivs = 0;

%Use cog effort rankings to bin?
use_ranks = 0;

%Bin by social/intellectual?
socog_binning = 0; %formerly all_labels, value flipped

%Run all comparisons?
all_comps = 1;
acomps1 = [1;1;1;2;2;3];
acomps2 = [2;3;4;3;4;4];

%Fix all parameters
fixparameters

%Find available MRI data
read_studysheet2

%Save workspace
save('tables/workspace.mat');

%% Run analysis
for c = 1:length(comps1)
    
    %Clean up old files/variables
    clearvars -except c ANOVA_T comps1 comps2 indiv_num indiv_ANOVA_T
    load('tables/workspace.mat');
    
    if c == 1
        delete('output/*.xls*');
        delete('output/*.mat');
    else
        load('tables/indivANOVA.mat');
    end
    
    one_col = comps1(c);
    two_col = comps2(c);
    for indiv = 1:indiv_num
        criq_analysis;
        if use_indivs
            indiv_ANOVA_T.SRT(indiv) = ANOVA_T.SRT;
            indiv_ANOVA_T.TMT(indiv) = ANOVA_T.TMT;
            indiv_ANOVA_T.WMSR(indiv) = ANOVA_T.WMSR;
            indiv_ANOVA_T.SCWT(indiv) = ANOVA_T.SCWT;
            indiv_ANOVA_T.PRMQ(indiv) = ANOVA_T.PRMQ;
            indiv_ANOVA_T.MoCA(indiv) = ANOVA_T.MoCA;
            indiv_ANOVA_T.DART(indiv) = ANOVA_T.DART;
            save('tables/indivANOVA.mat','indiv_ANOVA_T');
        end
        if length(comps1) > 1
            indiv_ANOVA_T.SRT(c) = ANOVA_T.SRT;
            indiv_ANOVA_T.TMT(c) = ANOVA_T.TMT;
            indiv_ANOVA_T.WMSR(c) = ANOVA_T.WMSR;
            indiv_ANOVA_T.SCWT(c) = ANOVA_T.SCWT;
            indiv_ANOVA_T.PRMQ(c) = ANOVA_T.PRMQ;
            indiv_ANOVA_T.MoCA(c) = ANOVA_T.MoCA;
            indiv_ANOVA_T.DART(c) = ANOVA_T.DART;
            save('tables/indivANOVA.mat','indiv_ANOVA_T');
        end
    end
end

if ~use_indivs && ~all_comps
    %     sprintf('n = %d/%d',length(best_fts),floor(length(sub_nums)/2))
end

%% If all_comps, output ANOVA results for every comparison
if all_comps
    indiv_ANOVA_T
end

%% If use_indivs, output ANOVA results for each category
if use_indivs
    indiv_ANOVA_T
end