%% Change to the correct directory %%
clear all
D = dir;
C = D.folder;
if ~strcmp(C,'M:\Thesis Work\CRIq_Analysis')
    cd ('M:\Thesis Work\CRIq_Analysis')
end

%% Load in worksheet & parse columns %%
worksheet = xlsread('CRIq_dataworksheet.xlsx');

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

%% Calculate CRI %%
for current_sub = 1:length(worksheet(:,1))
    e_tier_count = 0;
    w_tier_count = 0;
    edu_tier_order = [];
    w_tier_order = [];
    for col = 1:length(worksheet(1,:))
        current_col = worksheet(current_sub,col);
    end
    sub_edu_total = sum(educations(current_sub,:));
    sub_work_total = sum(works(current_sub,:));
    sub_ft_total = sum(free_time(current_sub,:));
    current_edu = educations(current_sub,:);
    current_work = works(current_sub,:);
    
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

    edu_total = sum(current_edu);
    exp_edu_CRI = ages(current_sub) * edu_coeff + edu_intrcpt;
    CRI_edu = (edu_total-exp_edu_CRI)/edu_sd;
    
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
    work_vals(current_sub,2) = (sum(w_tier_order)-max(w_tier_order))/(length(w_tier_order)-1);
    work_curr = work_vals(current_sub,:);
    work_total = sum(work_curr(~isnan(work_curr)));
    exp_work_CRI = ages(current_sub) * work_coeff + work_intrcpt;
    CRI_work = (work_total-exp_work_CRI)/work_sd;
end
