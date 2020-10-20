%% Split data into upper & lower tiers

% Fix & set variables
CRIs_to_use = CRI_leis_vals;
am2 = analysis_matrix;
analysis_matrix = analysis_matrix(:,7:end);
med_analymat = mean(analysis_matrix)


% Only include complete datasets
for i = 1:size(analysis_matrix,1)
    if ~sum(isnan(analysis_matrix(i,:)))
        new_analy_matrix(i,:) = analysis_matrix(i,:);
        ages(i,:) = extract_scores(i,1);
        edu_scores(i,:) = am2(i,3);
        work_scores(i,:) = am2(i,4);
        flipped_CRIs(i) = CRIs_to_use(i);
        good_indices(i) = 1;
    else
        keyboard
        good_indices(i) = 0;
    end
end

flipped_CRIs = flipped_CRIs(good_indices==1);
% flipped_CRIs = flipped_CRIs';
new_analy_matrix = new_analy_matrix(good_indices==1,:);
analysis_matrix = new_analy_matrix;
sub_nums = sub_nums(good_indices==1);
ages = ages(good_indices==1);
edu_scores = edu_scores(good_indices==1);
work_scores = work_scores(good_indices==1);

% if use_vars
%     find_binvariances;
%     flipped_gi = good_indices';
%     stand_bins = stand_bins(flipped_gi==1,:);
%     stand_bins = stand_bins(var_indices==1,:);
%     find_topvars;
% end

new_leis_vals = flipped_CRIs;
add_row = 0;
for row = 1:length(flipped_CRIs)
    if ~isnan(flipped_CRIs(row)) && ~isnan(ages(row)) && ~isnan(edu_scores(row)) && ~isnan(work_scores(row))
        add_row = add_row + 1;
        %         new_leis_vals(add_row) = flipped_CRIs(row);
        new_ages(add_row) = ages(row);
        new_edus(add_row) = edu_scores(row);
        new_works(add_row) = work_scores(row);
    else
        keyboard
    end
end

ages = new_ages;
edu_scores = new_edus;
work_scores = new_works;

% mean_ft = mean(new_leis_vals);
% std_ft = std(new_leis_vals);
% stand_fts = (new_leis_vals-mean_ft)/std_ft;
% scaled_fts = stand_fts*15+100;
%
% med_ft = median(scaled_fts);

%% Plot linear regression of age & leisure scores
x = ages;
y = new_leis_vals;
% y = scaled_fts;
x = x';
y = y';
format long
b1 = x\y;

close all
figure
yCalc1 = b1*x;
try
    scatter(x,y)
catch
    keyboard
end
hold on
plot(x,yCalc1)
xlabel('Age')
ylabel('Leisure Scores')
title('Linear Regression Relation Between Age & Leisure Scores')
grid on
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
plot(x,yCalc2,'--')
legend('Data','Slope','Slope & Intercept','Location','best');
Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2);
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);

new_leis_vals = new_leis_vals - yCalc2';
% new_leis_vals = yCalc2;
mean_ft = mean(new_leis_vals);
std_ft = std(new_leis_vals);
stand_fts = (new_leis_vals-mean_ft)/std_ft;
scaled_fts = stand_fts*15+100;
med_ft = median(scaled_fts)% Find best & worst subs and their data

%% Plot linear regression of education & leisure scores
regress_edu = 1;
if regress_edu
    x = edu_scores;
    y = new_leis_vals;
    % y = scaled_fts;
    x = x';
    y = y';
    format long
    b1 = x\y;
    
    close all
    figure
    yCalc1 = b1*x;
    scatter(x,y)
    hold on
    plot(x,yCalc1)
    xlabel('Age')
    ylabel('Leisure Scores')
    title('Linear Regression Relation Between Education & Leisure Scores')
    grid on
    X = [ones(length(x),1) x];
    b = X\y;
    yCalc2 = X*b;
    plot(x,yCalc2,'--')
    legend('Data','Slope','Slope & Intercept','Location','best');
    Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2);
    Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
    
    new_leis_vals = new_leis_vals - yCalc2';
    % new_leis_vals = yCalc2;
    mean_ft = mean(new_leis_vals);
    std_ft = std(new_leis_vals);
    stand_fts = (new_leis_vals-mean_ft)/std_ft;
    scaled_fts = stand_fts*15+100;
    med_ft = median(scaled_fts)% Find best & worst subs and their data
end
%% Plot linear regression of work & leisure scores
regress_work = 1;
if regress_work
    x = work_scores;
    y = new_leis_vals;
    % y = scaled_fts;
    x = x';
    y = y';
    format long
    b1 = x\y;
    
    close all
    figure
    yCalc1 = b1*x;
    scatter(x,y)
    hold on
    plot(x,yCalc1)
    xlabel('Age')
    ylabel('Leisure Scores')
    title('Linear Regression Relation Between Education & Leisure Scores')
    grid on
    X = [ones(length(x),1) x];
    b = X\y;
    yCalc2 = X*b;
    plot(x,yCalc2,'--')
    legend('Data','Slope','Slope & Intercept','Location','best');
    Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2);
    Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
    
    new_leis_vals = new_leis_vals - yCalc2';
    % new_leis_vals = yCalc2;
    mean_ft = mean(new_leis_vals);
    std_ft = std(new_leis_vals);
    stand_fts = (new_leis_vals-mean_ft)/std_ft;
    scaled_fts = stand_fts*15+100;
    med_ft = median(scaled_fts)% Find best & worst subs and their data
end
%% Find best and worst data
best_count = 0;
worst_count = 0;

if binning == 0
    for i = 1:length(scaled_fts)
        if ~isnan(scaled_fts(i))
            if scaled_fts(i) >= med_ft
                best_count = best_count + 1;
                best_fts(best_count) = scaled_fts(i);
                best_is(best_count) = i;
                best_leis_data(best_count,:) = analysis_matrix(best_is(best_count),:);
                best_leis_subs(best_count) = sub_nums(i);
            elseif scaled_fts(i) < med_ft
                worst_count = worst_count + 1;
                worst_fts(worst_count) = scaled_fts(i);
                worst_is(worst_count) = i;
                worst_leis_data(worst_count,:) = analysis_matrix(worst_is(worst_count),:);
                worst_leis_subs(worst_count) = sub_nums(i);
            end
        end
    end
    
    %% Find bin data, if binning
else
    clear best_leis_subs worst_leis_subs one_col_data two_col_data worst_fts best_fts
    one_count = 0; two_count = 0;
    for i = 1:length(sub_nums)
        for j = 1:length(top_subs(:,one_col))
%             if ~use_indivs
            if sub_nums(i) == top_subs(j,one_col)
                one_count = one_count + 1;
                one_col_data(one_count,:) = analysis_matrix(i,:);
                best_fts(one_count) = scaled_fts(i);
                best_leis_subs(one_count) = sub_nums(i);
            elseif sub_nums(i) == top_subs(j,two_col)
                two_count = two_count + 1;
                two_col_data(two_count,:) = analysis_matrix(i,:);
                worst_fts(two_count) = scaled_fts(i);
                worst_leis_subs(two_count) = sub_nums(i);
            end
%             else
%                 try
%                     if sub_nums(i) == top1_subs(j)
%                         one_count = one_count + 1;
%                         one_col_data(one_count,:) = analysis_matrix(i,:);
%                         best_fts(one_count) = scaled_fts(i);
%                         best_leis_subs(one_count) = sub_nums(i);
%                     elseif sub_nums(i) == bot1_subs(j)
%                         two_count = two_count + 1;
%                         two_col_data(two_count,:) = analysis_matrix(i,:);
%                         worst_fts(two_count) = scaled_fts(i);
%                         worst_leis_subs(two_count) = sub_nums(i);
%                     end
%                 end
%             end
        end
    end
    best_leis_data = one_col_data;
    worst_leis_data = two_col_data;
end

%% Eliminate outliers from the datasets
if elim_outliers
        [best_leis_data,best_leis_subs,best_fts] = find_outliers2(best_leis_data,best_leis_subs,best_fts);
        [worst_leis_data,worst_leis_subs,worst_fts] = find_outliers2(worst_leis_data,worst_leis_subs,worst_fts);
end

%% Find upper & lower quartile data
if uplow_quart && ~binning
    b_med = median(best_fts);
    w_med = median(worst_fts);
    
    if more_subs
        sort_bfts = sort(best_fts,'descend');
        sort_wfts = sort(worst_fts);
        bbot = sort_bfts(1:round(length(sort_bfts)*perc_include));
        wbot = sort_wfts(1:round(length(sort_wfts)*perc_include));
        b_med = min(bbot);
        w_med = max(wbot);
    end
    
    comb_subs = [best_leis_subs worst_leis_subs];
    clear best_fts bestis best_leis_data best_leis_subs worst_fts worst_is worst_leis_data worst_leis_subs
    best_count = 0; worst_count = 0; b2_count = 0; w2_count = 0;
    for i = 1:length(scaled_fts)
        if ~isnan(scaled_fts(i)) && sum(any(sub_nums(i)==comb_subs)) 
%             && sum(any(sub_nums(i)==avail_nums))
            if scaled_fts(i) >= b_med
                best_count = best_count + 1;
                best_fts(best_count) = scaled_fts(i);
                best_is(best_count) = i;
                best_leis_data(best_count,:) = analysis_matrix(best_is(best_count),:);
                best_leis_subs(best_count) = sub_nums(i);
            elseif scaled_fts(i) <= w_med
                worst_count = worst_count + 1;
                worst_fts(worst_count) = scaled_fts(i);
                worst_is(worst_count) = i;
                worst_leis_data(worst_count,:) = analysis_matrix(worst_is(worst_count),:);
                worst_leis_subs(worst_count) = sub_nums(i);
            end
        end
    end
end

% if elim_outliers
%     try
%         [best_leis_data,best_leis_subs,best_fts] = find_outliers(best_leis_data,best_leis_subs,best_fts);
%         [worst_leis_data,worst_leis_subs,worst_fts] = find_outliers(worst_leis_data,worst_leis_subs,worst_fts);
%     catch
%         keyboard
%     end
% end

%% Cut datasets to same size if needed
randomize_data = 0;
if cut_to_samesize
    if size(best_leis_data,1) > size(worst_leis_data,1)
        best = 1;
        if randomize_data
            shuff_Is = randperm(length(best_leis_data));
            best_leis_data = best_leis_data(shuff_Is(1:length(worst_leis_data)),:);
        else
            if binning
                best_fts = best_fts(1:length(worst_leis_data));
                best_leis_data = best_leis_data(1:length(worst_leis_data),:);
            end
        end
    elseif size(worst_leis_data,1) > size(best_leis_data,1)
        best = 0;
        if randomize_data
            shuff_Is = randperm(length(worst_leis_data));
            worst_leis_data = worst_leis_data(shuff_Is(1:length(best_leis_data)),:);
        else
            if binning
                worst_fts = worst_fts(1:length(best_leis_data));
                worst_leis_data = worst_leis_data(1:length(best_leis_data),:);
            end
        end
    end
    
    if ~binning
        if length(best_fts)>length(worst_fts)
            [sort_fts,sort_i] = sort(best_fts,'descend');
            ss_i = sort(sort_i(1:length(worst_fts)));
            best_fts = best_fts(ss_i);
            best_leis_data = best_leis_data(ss_i,:);
        elseif length(worst_fts)>length(best_fts)
            [sort_fts,sort_i] = sort(worst_fts);
            ss_i = sort(sort_i(1:length(best_fts)));
            worst_fts = worst_fts(ss_i);
            worst_leis_data = worst_leis_data(ss_i,:);
        end
    end
end
% fBest_leis_data = best_leis_data(~isnan(best_leis_data));
% fWorst_leis_data = worst_leis_data(~isnan(worst_leis_data));

med_fBest_ft = nanmedian(best_leis_data);
med_fWorst_ft = nanmedian(worst_leis_data);

% Plot best & worst data
plot_ft = 1;
if plot_ft
    close all
    figure
    plot(med_fBest_ft);
    hold on
    plot(med_fWorst_ft);
    xticks(1:size(best_leis_data,2)+1);
    xticklabels(var_names(end-size(best_leis_data,2)+1:end));
    xlim([0 size(best_leis_data,2)+1]);
    ylim([0 1]);
    if binning
        if ~socog_binning && ~use_ranks && ~use_indivs
            comp1 = sprintf('Bin %d',one_col);
            comp2 = sprintf('Bin %d',two_col);
        elseif socog_binning
            comp1 = 'CA';
            comp2 = 'SA';
        elseif use_ranks
            comp1 = 'Upper Tier';
            comp2 = 'Lower Tier';
        elseif use_indivs
            comp1 = sprintf('Item %d',indiv);
            comp2 = sprintf('Other Items');
        end
    else
        comp1 = 'Upper Tier';
        comp2 = 'Lower Tier';
    end
    lgd = legend(sprintf('%s n = %d',comp1,length(best_leis_data)),sprintf('%s n = %d',comp2,length(worst_leis_data)));
    lgd.Location = 'northeast';
    title(sprintf('%s - %s Comparison',comp1,comp2));
end

% Choose which variables to include in ANOVA
Ps = zeros(1,size(best_leis_data,2));
anova_all_data = 0;
if anova_all_data
    for_end = 1;
else
    for_end = size(best_leis_data,2);
end

try
    clear nonan_best_fts nonan_worst_fts
end
for start_point = 1:for_end
    if anova_all_data
        start_point = 1;
        end_point = size(best_leis_data,2);
    else
        end_point = start_point;
    end
    try
        m_best_leis_data = best_leis_data(:,start_point:end_point);
        m_worst_leis_data = worst_leis_data(:,start_point:end_point);
    catch
        keyboard
    end
    for a = 1:2
        if a == 1
            mod_wrksht = m_best_leis_data;
        else
            mod_wrksht = m_worst_leis_data;
        end
        
        count = 0;
        for i = 1:length(mod_wrksht)
            skip_row = 0;
            for j = 1:size(mod_wrksht,2)
                if isnan(mod_wrksht(i,j))
                    skip_row = 1;
                end
            end
            if ~skip_row
                count = count + 1;
                if a == 1
                    try
                        nonan_best_fts(count,:) = mod_wrksht(i,:);
                    catch
                        keyboard
                    end
                else
                    nonan_worst_fts(count,:) = mod_wrksht(i,:);
                end
            end
        end
    end
    count = 0; sub_count = 0;
    anova_matrix = zeros((length(nonan_best_fts)+length(nonan_worst_fts)),4);
    for i = 1:length(nonan_best_fts)
        sub_count = sub_count + 1;
        origin(sub_count) = 1;
        for j = 1:size(nonan_best_fts,2)
            count = count + 1;
            anova_matrix(count,:) = [nonan_best_fts(i,j) 1 j sub_count];
            manova_matrix(sub_count,j) = nonan_best_fts(i,j);
        end
    end
    for i = 1:length(nonan_worst_fts)
        sub_count = sub_count + 1;
        origin(sub_count) = 2;
        for j = 1:size(nonan_worst_fts,2)
            count = count + 1;
            anova_matrix(count,:) = [nonan_worst_fts(i,j) 2 j sub_count];
            %         manova_matrix(sub_count,j) = nonan_worst_fts(i,j);
        end
    end
    run_anova = 1;
    if run_anova
        P1 = BWAOV2(anova_matrix);
        if ~anova_all_data
            Ps(start_point) = P1;
            if Ps(start_point) < 0.05
                signif = 1;
                signif_points(start_point) = 1;
            else
                signif_points(start_point) = 0;
            end
        end
    end
end

if ~anova_all_data || use_indivs
    Ps = round(Ps,2,'decimal');
    ANOVA_T=table(Ps(1),Ps(2),Ps(3),Ps(4),Ps(5),Ps(6),Ps(7),'VariableNames',{'SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'})
    ANOVA_Tname = sprintf('output/%d%d_ANOVAout.xls',one_col,two_col);
    if write2table
    writetable(ANOVA_T,ANOVA_Tname);
    end
    save('tables/ANOVA_Tnametemp.mat','ANOVA_Tname');
end
start_point = 1;
% [d,p] = manova1([manova_matrix(:,1) manova_matrix(:,2) manova_matrix(:,3) ...
%     manova_matrix(:,4) manova_matrix(:,5) manova_matrix(:,6)],origin)