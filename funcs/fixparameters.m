%fix_parameters
global perc_include
perc_include = perc_include *.01;
if sum([use_indivs;use_ranks;socog_binning]) > 1
    error(sprintf('use_indivs:%d,use_ranks:%d,socog_binning:%d',use_indivs,use_ranks,socog_binning))
end
item_labels = {'newspaper','chores','driving','leisure_acts','new_tech','social','cinema','garden','grandchildren','volunteer','art','concerts','journeys','reading','children','pets','account'};
if use_indivs;indiv_num = 17;else;indiv_num = 1;end
if binning;use_vars=1;uplow_quart=0;else;use_vars=0;end %if binning, use subjects who vary between compared bins
if use_indivs;use_vars=0;end
% if use_indivs; use_ranks = 0; end
% if use_indivs || use_ranks;socog_binning = 0;end
if ~binning || socog_binning || use_indivs || use_ranks; all_comps = 0; end
if all_comps;binning = 1; use_vars = 1;comps1 = acomps1;comps2 = acomps2;
else
    if binning
        comps1 = 2;
        comps2 = 3;
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
if use_indivs
    z=zeros(17,1);
    indiv_ANOVA_T=table(item_labels',z,z,z,z,z,z,z,'VariableNames',{'Cat','SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'});
elseif all_comps
    z=zeros(6,1);
    indiv_ANOVA_T=table(comps1,comps2,z,z,z,z,z,z,z,'VariableNames',{'Comp1','Comp2','SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'});
end