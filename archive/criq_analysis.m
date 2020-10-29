%% Runs all analyses using CRIq data
if ~exist('all_comps');run_criq_analysis;end

%% Add stats folder %%
addpath('StatsFunctions');

%% Change to the correct directory %%
D = dir;
C = D.folder;
if ~strcmp(C,'M:\ThesisWork\CRIq_Analysis')
    cd ('M:\ThesisWork\CRIq_Analysis')
end

%% Load in worksheet & parse columns %%
[worksheet,txt,raw] = xlsread('tables/CRIq_dataworksheet_m_2.xlsx');
worksheet = worksheet(:,1:52);

col_names = txt(1,:);
sub_nums = worksheet(:,1);
ages = worksheet(:,2);
educations = worksheet(:,3:4);
works = worksheet(:,5:9);
weeklies = worksheet(:,10:14);
monthlies = worksheet(:,15:20);
annualies = worksheet(:,21:23);
fixeds = worksheet(:,24:26);

free_time = [weeklies monthlies annualies fixeds];

edu_sd = 4.750;
edu_intrcpt = 21.169;
edu_coeff = -0.164;

work_sd = 40.21979;
work_intrcpt = -2.082;
work_coeff = 1.124;

leis_sd = 80.24101;
leis_intrcpt = 2.68;
leis_coeff = 3.754;

record_CRIq = worksheet(:,36);
record_CRIq = record_CRIq(1:length(ages));
record_CRIq = record_CRIq';

%% Calculate CRI %%
for current_sub = 1:sum(~isnan(worksheet(:,1)))
    
    minus_space = current_sub - 1;
    e_tier_count = 0;
    w_tier_count = 0;
    edu_tier_order = [];
    w_tier_order = [];
    CRI_e_record = worksheet(current_sub,33);
    CRI_w_record = worksheet(current_sub,34);
    CRI_ft_record = worksheet(current_sub,35);
    
    for col = 1:length(worksheet(1,:))
        current_col = worksheet(current_sub,col);
    end
    if ~isnan(educations(current_sub,:))
        sub_edu_total = sum(educations(current_sub,:));
    end
    if ~isnan(works(current_sub,:))
        sub_work_total = sum(works(current_sub,:));
    end
    if ~isnan(free_time(current_sub,:))
        sub_ft_total = sum(free_time(current_sub,:));
    end
    
    current_edu = educations(current_sub,:);
    current_work = works(current_sub,:);
    
    edu_total = sum(current_edu);
    if ~isnan(edu_total)
        exp_edu_CRI = ages(current_sub) * edu_coeff + edu_intrcpt;
        CRI_edu_curr_val = (edu_total-exp_edu_CRI)/edu_sd;
        e = 1;
    else
        CRI_edu_vals(current_sub) = CRI_e_record;
        e = 0;
    end
    
    if sub_work_total > 0
        if ~isnan(current_work)
            for i = 1:length(current_work)
                work_tier_vals(i) = current_work(i) * i;
            end
            
            for i = 1:length(work_tier_vals)
                j = length(work_tier_vals) + 1 - i;
                if work_tier_vals(j) ~= 0 && length(w_tier_order) < 3
                    w_tier_count = w_tier_count + 1;
                    w_tier_order(w_tier_count) = work_tier_vals(j);
                end
            end
            
            work_vals(current_sub,1) = max(w_tier_order);
            work_vals(current_sub,2) = (sum(w_tier_order)-max(w_tier_order))/(length(w_tier_order));
            work_curr = work_vals(current_sub,:);
            work_total = sum(work_curr(~isnan(work_curr)));
            exp_work_CRI = ages(current_sub) * work_coeff + work_intrcpt;
            CRI_work_curr_val = (work_total-exp_work_CRI)/work_sd;
            w = 1;
        else
            CRI_work_vals(current_sub) = CRI_w_record;
            w = 0;
        end
    else
        CRI_work_vals(current_sub) = 0;
    end
    
    if ~isnan(free_time(current_sub,:))
        children_val = free_time(current_sub,end-2);
        ft_total = sum(free_time(current_sub,:)) - children_val;
        exp_ft_CRI = ages(current_sub) * leis_coeff + leis_intrcpt;
        if children_val > 0
            children_val = 5*children_val+10;
        end
        ft_total = ft_total + children_val;
        CRI_ft_curr_val = (ft_total-exp_ft_CRI)/leis_sd;
        ft = 1;
    else
        CRI_leis_vals(current_sub) = CRI_ft_record;
        ft = 0;
    end
    
    if e == 1
        CRI_edu_vals(current_sub) = round(CRI_edu_curr_val*15+100);
    end
    if w == 1
        CRI_work_vals(current_sub) = round(CRI_work_curr_val*15+100);
    end
    if ft == 1
        CRI_leis_vals(current_sub) = round(CRI_ft_curr_val*15+100);
    end
    
    if isnan(CRI_edu_vals(current_sub))
        CRI_edu_vals(current_sub) = CRI_e_record;
    end
    if isnan(CRI_work_vals(current_sub))
        CRI_work_vals(current_sub) = CRI_w_record;
    end
    if isnan(CRI_leis_vals(current_sub))
        CRI_leis_vals(current_sub) = CRI_ft_record;
    end
    
    CRI_total_vals(current_sub) = round(mean([CRI_edu_vals(current_sub) CRI_work_vals(current_sub) CRI_leis_vals(current_sub)] - 100)/11.32277*15+100);
end

% Use only complete datasets
comp_sub_indices = (~isnan(CRI_edu_vals)&~isnan(CRI_work_vals)&~isnan(CRI_leis_vals));
CRI_edu_vals = CRI_edu_vals(comp_sub_indices);
CRI_work_vals = CRI_work_vals(comp_sub_indices);
CRI_leis_vals = CRI_leis_vals(comp_sub_indices);
CRI_total_vals = CRI_total_vals(comp_sub_indices);

sub_nums = sub_nums(comp_sub_indices);
ages = ages(comp_sub_indices);
worksheet = worksheet(comp_sub_indices,:);
new_raw = raw(2:end,:);
raw = new_raw(comp_sub_indices,1:52);

%Make list of CRIq scores, computed or recorded
for i = 1:length(CRI_total_vals)
    if ~isnan(CRI_total_vals(i))
        CRI_all_vals(i) = CRI_total_vals(i);
    else
        CRI_all_vals(i) = worksheet(i,36);
    end
end

%% Fix behavioral scores for analysis

for i = 1:size(worksheet,1)
   srv1 = raw{i,38}; try srv1 = str2num(srv1); end
   srv2 = raw{i,39}; try srv2 = str2num(srv2); end
   story_recall_vals(i) = srv1 + srv2;
end
if normalize; story_recall_vals = normalize_values(story_recall_vals,normalize); end

fix_tmt2;
if normalize; TMT_vals = normalize_values(TMT_vals,normalize); end

fix_wms;
WMS_vals = wms_tot_nVals;
if normalize; WMS_vals = normalize_values(WMS_vals,normalize); end

c_score = worksheet(:,44);
w_score = worksheet(:,45);
cw_score = worksheet(:,46);
stroop_vals = ((c_score+w_score)/2) - cw_score;
fix_stroop;
if normalize; stroop_vals = normalize_values(stroop_vals,normalize); end

mem_vals = worksheet(:,47);
mem_vals = -mem_vals;
if normalize; mem_vals = normalize_values(mem_vals,normalize); end %"remembering to do things"

srp_vals = worksheet(:,50);
if normalize; srp_vals = normalize_values(srp_vals,normalize); end

moca_vals = worksheet(:,51);
if normalize; moca_vals = normalize_values(moca_vals,normalize); end

read_vals = worksheet(:,52);
if normalize; read_vals = normalize_values(read_vals,normalize); end

story_recall_vals = flip_data(story_recall_vals);
TMT_vals = flip_data(TMT_vals);
WMS_vals = flip_data(WMS_vals);
stroop_vals = flip_data(stroop_vals);
mem_vals = flip_data(mem_vals);
moca_vals = flip_data(moca_vals);
read_vals = flip_data(read_vals);

analysis_matrix = ([sub_nums ages CRI_edu_vals' CRI_work_vals' ...
    CRI_leis_vals' CRI_all_vals' story_recall_vals TMT_vals ...
    WMS_vals stroop_vals mem_vals  moca_vals read_vals]);

skip_point = 5;
start_point = 6;

count_complete_subs;

[r,p,rlo,rup]=corrcoef(complete_subs);

var_names = [{'Age'},{'Education'},{'Work'},{'Leisure'},{'CRIq'},{'SRT'},{'TMT'},{'WMSR'},{'SCWT'},{'PRMQ'},{'MoCA'},{'DART'}];

var_names = [var_names(1:skip_point) var_names(start_point:end)];

%% Create correlation matrix
eco_toolbox = 0;
if eco_toolbox
    complete_subs = complete_subs(:,2:end);
    R = corrplot(complete_subs,'varNames',var_names);
    
    % Regress out age
    age_corrs = R(:,1);
    R_one = age_corrs * age_corrs';
    R_one2 = R - R_one;
    
    x = complete_subs(:,1); %ages
    y = complete_subs(:,4); %leisure scores
    format long
    b1 = x\y;
    yCalc1 = b1*x;a
    scatter(x,y)
    hold on
    plot(x,yCalc1)
    xlabel('Ages')
    ylabel('Leisure Scores')
    title('Linear Regression Relation Between Ages & Leisure Score')
    grid on
    
    X = [ones(length(x),1) x];
    b = X\y;
    yCalc2 = X*b;
    plot(x,yCalc2,'--')
    legend('Data','Slope','Slope & Intercept','Location','best');
end

%% Create Excel sheet w/calculated values
criq_scores = raw(1:length(sub_nums),2:26);

for i = 1:length(criq_scores)
    for j = 1:size(criq_scores,2)
        try
            extract_scores(i,j) = criq_scores{i,j};
        catch
            try
                extract_scores(i,j) = str2num(criq_scores{i,j});
            catch
                extract_scores(i,j) = NaN;
            end
        end
    end
end

xlswrite('tables/extract_scores.xlsx',extract_scores);

%% Main functions
bin_cluster_subs;
split_fts;
read_studysheet;
find_bestworst_mri;