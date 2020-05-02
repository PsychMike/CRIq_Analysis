clear all

%% Add stats folder %%
addpath('StatsFunctions');

%% Change to the correct directory %%
% D = dir;
% C = D.folder;
% if ~strcmp(C,'M:\Thesis Work\CRIq_Analysis')
%     cd ('M:\Thesis Work\CRIq_Analysis')
% end

%% Load in worksheet & parse columns %%
[worksheet,txt,raw] = xlsread('CRIq_dataworksheet_m_2.xlsx');

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

ft_sd = 80.24101;
ft_intrcpt = 2.68;
ft_coeff = 3.754;

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
    sub_edu_total = sum(educations(current_sub,:));
    sub_work_total = sum(works(current_sub,:));
    sub_ft_total = sum(free_time(current_sub,:));
    current_edu = educations(current_sub,:);
    current_work = works(current_sub,:);
    
    for fold_old_code = 1
        %     for i = 1:length(current_edu)
        %         edu_tier_vals(i) = current_edu(i) * i;
        %     end
        %
        %     for i = 1:length(edu_tier_vals)
        %         j = length(edu_tier_vals) + 1 - i;
        %         if edu_tier_vals(j) ~= 0 && length(edu_tier_order) < 3
        %             e_tier_count = e_tier_count + 1;
        %             edu_tier_order(e_tier_count) = edu_tier_vals(j);
        %         end
        %     end
        %
        %     edu_vals(current_sub,1) = max(edu_tier_order);
        %     edu_vals(current_sub,2) = (sum(edu_tier_order)-max(edu_tier_order))/(length(edu_tier_order)-1);
        %     edu_curr = edu_vals(current_sub,:);
        %     edu_total = sum(edu_curr(~isnan(edu_curr)));
    end
    
    try
        edu_total = sum(current_edu);
        exp_edu_CRI = ages(current_sub) * edu_coeff + edu_intrcpt;
        CRI_edu_curr_val = (edu_total-exp_edu_CRI)/edu_sd;
        e = 1;
    catch
        CRI_edu_vals(current_sub) = CRI_e_record;
        e = 0;
    end
    
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
    
    try
        work_vals(current_sub,1) = max(w_tier_order);
        work_vals(current_sub,2) = (sum(w_tier_order)-max(w_tier_order))/(length(w_tier_order)-1);
        work_curr = work_vals(current_sub,:);
        work_total = sum(work_curr(~isnan(work_curr)));
        exp_work_CRI = ages(current_sub) * work_coeff + work_intrcpt;
        CRI_work_curr_val = (work_total-exp_work_CRI)/work_sd;
        w = 1;
    catch
        CRI_work_vals(current_sub) = CRI_w_record;
        w = 0;
    end
    
    try
        children_val = free_time(current_sub,end-2);
        ft_total = sum(free_time(current_sub,:)) - children_val;
        exp_ft_CRI = ages(current_sub) * ft_coeff + ft_intrcpt;
        if children_val > 0
            children_val = 5*children_val+10;
        end
        ft_total = ft_total + children_val;
        CRI_ft_curr_val = (ft_total-exp_ft_CRI)/ft_sd;
        ft = 1;
    catch
        CRI_ft_vals(current_sub) = CRI_ft_record;
        ft = 0;
    end
    
    if e == 1
        CRI_edu_vals(current_sub) = round(CRI_edu_curr_val*15+100);
    end
    if w == 1
        CRI_work_vals(current_sub) = round(CRI_work_curr_val*15+100);
    end
    if ft == 1
        CRI_ft_vals(current_sub) = round(CRI_ft_curr_val*15+100);
    end
    
    if isnan(CRI_edu_vals(current_sub))
        CRI_edu_vals(current_sub) = CRI_e_record;
    end
    if isnan(CRI_work_vals(current_sub))
        CRI_work_vals(current_sub) = CRI_w_record;
    end
    if isnan(CRI_ft_vals(current_sub))
        CRI_ft_vals(current_sub) = CRI_ft_record;
    end
    
    CRI_total_vals(current_sub) = round(mean([CRI_edu_vals(current_sub) CRI_work_vals(current_sub) CRI_ft_vals(current_sub)] - 100)/11.32277*15+100);
end

record_CRIq = worksheet(:,36);
record_CRIq = record_CRIq(1:current_sub);
record_CRIq = record_CRIq';

%Make list of CRIq scores, computed or recorded
consolidate_criq_scores;

%% Correlatory Analyses
corr(CRI_all_vals(~isnan(CRI_all_vals)&~isnan(CRI_ft_vals))',CRI_ft_vals(~isnan(CRI_all_vals)&~isnan(CRI_ft_vals))');

col_thirtysix = worksheet(:,36);
col_thirtyfive = worksheet(:,35);
corr(col_thirtysix(~isnan(col_thirtysix)&~isnan(col_thirtyfive)),col_thirtyfive(~isnan(col_thirtysix)&~isnan(col_thirtyfive)));

story_recall_vals = worksheet(:,38) + worksheet(:,39);
story_recall_vals = story_recall_vals(1:current_sub);
fix_storyrecall;

TMT_vals = worksheet(:,40) + worksheet(:,41);
TMT_vals = TMT_vals(1:current_sub);
fix_tmt;

fix_wms;
WMS_vals = wms_tot_nVals;

stroop_vals = worksheet(:,44) + worksheet(:,45) + worksheet(:,46);
stroop_vals = stroop_vals(1:current_sub);
fix_stroop;

mem_vals = worksheet(:,47);
mem_vals = mem_vals(1:current_sub);

srp_vals = worksheet(:,50);
srp_vals = srp_vals(1:current_sub);

moca_vals = worksheet(:,51);
moca_vals = moca_vals(1:current_sub);

ruwe_vals = worksheet(:,52);
ruwe_vals = ruwe_vals(1:current_sub);

analysis_matrix = ([ages(1:current_sub) CRI_edu_vals' CRI_work_vals' ...
    CRI_ft_vals' CRI_all_vals' story_recall_vals TMT_vals ...
    WMS_vals' stroop_vals mem_vals  moca_vals ruwe_vals]);

%srp_vals

skip_point = 7;
start_point = 8;

% analysis_matrix = [analysis_matrix(1:skip_point) analysis_matrix(start_point:end)];

count_complete_subs;

[r,p,rlo,rup]=corrcoef(complete_subs);
% p
var_names = [{'Age'},{'Education'},{'Work'},{'Leisure'},{'CRIq'},{'Story Recall'},{'TMT'},{'WMS'},{'Stroop'},{'Memory'},{'MOCA'},{'RUWE'}];
%{'SRP'},

var_names = [var_names(1:skip_point) var_names(start_point:end)];

%% Create correlation matrix
eco_toolbox = 0;
if eco_toolbox
R = corrplot(complete_subs,'varNames',var_names);

% Regress out age
age_corrs = R(:,1);
R_one = age_corrs * age_corrs';
R_one2 = R - R_one;

x = complete_subs(:,1); %ages
y = complete_subs(:,4); %leisure scores
format long
b1 = x\y;
yCalc1 = b1*x;
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

new_worksheet = raw(1:length(sub_nums),1:36);
criq_scores = raw(2:length(sub_nums)+1,2:26);

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

xlswrite('extract_scores.xlsx',extract_scores);

for insert_vals = 1:length(CRI_total_vals)
    new_worksheet{insert_vals+1,32} = CRI_total_vals(insert_vals);
    new_worksheet{insert_vals+1,33} = CRI_edu_vals(insert_vals);
    new_worksheet{insert_vals+1,35} = CRI_ft_vals(insert_vals);
    new_worksheet{insert_vals+1,34} = CRI_work_vals(insert_vals);
end
xlswrite('CRIq_new_dataworksheet.xlsx',new_worksheet);

%% Other functions
split_fts;
read_studysheet;
find_bestworst_mri;