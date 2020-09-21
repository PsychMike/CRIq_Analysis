%% Split data into upper & lower tiers

global use_vars binning one_col two_col uplow_quart cut_to_samesize elim_outliers anova_all_data more_subs

% Fix & set variables
CRIs_to_use = CRI_ft_vals;
% edu_scores = analysis_matrix(:,3);
am2 = analysis_matrix;
analysis_matrix = analysis_matrix(:,7:end);

% Only include complete datasets
for i = 1:size(analysis_matrix,1)
    if ~sum(isnan(analysis_matrix(i,:)))
        new_analy_matrix(i,:) = analysis_matrix(i,:);
        ages(i,:) = extract_scores(i,1);
        edu_scores(i,:) = am2(i,3);
        flipped_CRIs(i,:) = CRIs_to_use(i);
        good_indices(i) = 1;
    else
        keyboard
        good_indices(i) = 0;
    end
end

flipped_CRIs = flipped_CRIs(good_indices==1,:);
flipped_CRIs = flipped_CRIs';
new_analy_matrix = new_analy_matrix(good_indices==1,:);
analysis_matrix = new_analy_matrix;
sub_nums = sub_nums(good_indices==1);
ages = ages(good_indices==1);
edu_scores = edu_scores(good_indices==1);

if use_vars
    find_binvariances;
    flipped_gi = good_indices';
    stand_bins = stand_bins(flipped_gi==1,:);
    %     stand_bins = stand_bins(var_indices==1,:);
    find_topvars;
end

add_row = 0;
for row = 1:length(flipped_CRIs)
    if ~isnan(flipped_CRIs(row)) && ~isnan(ages(row)) && ~isnan(edu_scores(row))
        add_row = add_row + 1;
        new_ft_vals(add_row) = flipped_CRIs(row);
        new_ages(add_row) = ages(row);
        new_edus(add_row) = edu_scores(row);
    else
        keyboard
    end
end

ages = new_ages;
edu_scores = new_edus;

% mean_ft = mean(new_ft_vals);
% std_ft = std(new_ft_vals);
% stand_fts = (new_ft_vals-mean_ft)/std_ft;
% scaled_fts = stand_fts*15+100;
%
% med_ft = median(scaled_fts);

%% Plot linear regression of age & leisure scores
x = ages;
y = new_ft_vals;
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
title('Linear Regression Relation Between Age & Leisure Scores')
grid on
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
plot(x,yCalc2,'--')
legend('Data','Slope','Slope & Intercept','Location','best');
Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2);
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);

new_ft_vals = new_ft_vals - yCalc2';
% new_ft_vals = yCalc2;
mean_ft = mean(new_ft_vals);
std_ft = std(new_ft_vals);
stand_fts = (new_ft_vals-mean_ft)/std_ft;
scaled_fts = stand_fts*15+100;
med_ft = median(scaled_fts);% Find best & worst subs and their data

%% Plot linear regression of education & leisure scores
x = edu_scores;
y = new_ft_vals;
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

new_ft_vals = new_ft_vals - yCalc2';
% new_ft_vals = yCalc2;
mean_ft = mean(new_ft_vals);
std_ft = std(new_ft_vals);
stand_fts = (new_ft_vals-mean_ft)/std_ft;
scaled_fts = stand_fts*15+100;
med_ft = median(scaled_fts);% Find best & worst subs and their data
%%

best_count = 0;
worst_count = 0;

for i = 1:length(scaled_fts)
    if ~isnan(scaled_fts(i))
        if scaled_fts(i) > med_ft
            best_count = best_count + 1;
            best_fts(best_count) = scaled_fts(i);
            best_is(best_count) = i;
            best_ft_data(best_count,:) = analysis_matrix(best_is(best_count),:);
            best_ft_subs(best_count) = sub_nums(i);
        elseif scaled_fts(i) < med_ft
            worst_count = worst_count + 1;
            worst_fts(worst_count) = scaled_fts(i);
            worst_is(worst_count) = i;
            worst_ft_data(worst_count,:) = analysis_matrix(worst_is(worst_count),:);
            worst_ft_subs(worst_count) = sub_nums(i);
        end
    end
end

%% Find bin data, if binning
if binning
    clear best_ft_subs worst_ft_subs
    one_count = 0; two_count = 0;
    for i = 1:length(sub_nums)
        for j = 1:length(top_subs(:,one_col))
            if sub_nums(i) == top_subs(j,one_col)
                one_count = one_count + 1;
                one_col_data(one_count,:) = analysis_matrix(i,:);
                best_ft_subs(one_count) = sub_nums(i);
            end
            if sub_nums(i) == top_subs(j,two_col)
                two_count = two_count + 1;
                two_col_data(two_count,:) = analysis_matrix(i,:);
                worst_ft_subs(two_count) = sub_nums(i);
            end
        end
    end
    best_ft_data = one_col_data;
    worst_ft_data = two_col_data;
end

%% Eliminate outliers from the datasets
if elim_outliers
    [best_ft_data,best_ft_subs] = find_outliers(best_ft_data,best_ft_subs);
    [worst_ft_data,worst_ft_subs] = find_outliers(worst_ft_data,worst_ft_subs);
end

%% Cut datasets to same size
randomize_data = 0;
if cut_to_samesize
    if size(best_ft_data,1) > size(worst_ft_data,1)
        best = 1;
        if randomize_data
            shuff_Is = randperm(length(best_ft_data));
            best_ft_data = best_ft_data(shuff_Is(1:length(worst_ft_data)),:);
        else
            find_bw;
            best_ft_data = best_ft_data(bestbests,:);
            %         best_ft_data = best_ft_data(1:length(worst_ft_data),:);
        end
    else
        best = 0;
        if randomize_data
            shuff_Is = randperm(length(worst_ft_data));
            worst_ft_data = worst_ft_data(shuff_Is(1:length(best_ft_data)),:);
        else
            %             index_range = 1:length(best_ft_data);
            %             rand_i = randi([length(best_ft_data)+1 length(worst_ft_data)]);
            %             rand_i2 = randi(length(best_ft_data));
            %             range = 1:length(best_ft_data);
            %             range(rand_i2) = rand_i;
            %         worst_ft_data = worst_ft_data(range,:);
            find_bw;
            worst_ft_data = worst_ft_data(worstworsts,:);
            %         worst_ft_data = worst_ft_data(1:length(best_ft_data),:);
        end
    end
end

%% Find upper & lower quartile data
if uplow_quart && ~binning
    b_med = median(best_fts);
    w_med = median(worst_fts);
    
    if more_subs
        load('b2_med');
        load('w2_med');
        b_med = b2_med;
        w_med = w2_med;
    end
    
    %     clear best_fts bestis best_ft_data best_ft_subs worst_fts worst_is worst_ft_data worst_ft_subs
    best_count = 0; worst_count = 0; b2_count = 0; w2_count = 0;
    for i = 1:length(scaled_fts)
        if ~isnan(scaled_fts(i))
            if scaled_fts(i) >= b_med
                best_count = best_count + 1;
                best_fts(best_count) = scaled_fts(i);
                best_is(best_count) = i;
                best_ft_data(best_count,:) = analysis_matrix(best_is(best_count),:);
                best_ft_subs(best_count) = sub_nums(i);
            elseif scaled_fts(i) <= w_med
                worst_count = worst_count + 1;
                worst_fts(worst_count) = scaled_fts(i);
                worst_is(worst_count) = i;
                worst_ft_data(worst_count,:) = analysis_matrix(worst_is(worst_count),:);
                worst_ft_subs(worst_count) = sub_nums(i);
            elseif scaled_fts(i) >= med_ft
                b2_count = b2_count + 1;
                best_fts2(b2_count) = scaled_fts(i);
            elseif scaled_fts(i) < med_ft
                w2_count = w2_count + 1;
                worst_fts2(w2_count) = scaled_fts(i);
            end
        end
    end
    b2_med=median(best_fts2);w2_med=median(worst_fts2);
end

find_bw;

fBest_ft_data = best_ft_data(~isnan(best_ft_data));
fWorst_ft_data = worst_ft_data(~isnan(worst_ft_data));

med_fBest_ft = nanmedian(best_ft_data);
med_fWorst_ft = nanmedian(worst_ft_data);

% Plot best & worst data
plot_ft = 1;
if plot_ft
    close all
    figure
    plot(med_fBest_ft);
    hold on
    plot(med_fWorst_ft);
    xticks(1:size(best_ft_data,2)+1);
    xticklabels(var_names(end-size(best_ft_data,2)+1:end));
    xlim([0 size(best_ft_data,2)+1]);
    ylim([0.2 1.2]);
    if binning
        comp1 = sprintf('Bin %d',one_col);
        comp2 = sprintf('Bin %d',two_col);
    else
        comp1 = 'Upper';
        comp2 = 'Lower';
    end
    lgd = legend(sprintf('%s n = %d',comp1,length(best_ft_data)),sprintf('%s n = %d',comp2,length(worst_ft_data)));
    lgd.Location = 'northeast';
    title(sprintf('%s - %s Comparison',comp1,comp2));
end

% Choose which variables to include in ANOVA
Ps = zeros(1,size(best_ft_data,2));
anova_all_data = 0;
if anova_all_data
    for_end = 1;
else
    for_end = size(best_ft_data,2);
end
for_end = 7;
for start_point = 1:for_end
    if anova_all_data
        start_point = 1;
        end_point = size(best_ft_data,2);
    else
        end_point = start_point;
    end
    try
        m_best_ft_data = best_ft_data(:,start_point:end_point);
        m_worst_ft_data = worst_ft_data(:,start_point:end_point);
    catch
        keyboard
    end
    for a = 1:2
        if a == 1
            mod_wrksht = m_best_ft_data;
        else
            mod_wrksht = m_worst_ft_data;
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

if ~anova_all_data
    one_col
    two_col
    Ps = round(Ps,5,'decimal');
    ANOVA_T=table(Ps(1),Ps(2),Ps(3),Ps(4),Ps(5),Ps(6),Ps(7),'VariableNames',{'SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'})
    ANOVA_Tname = sprintf('output/%d%d_ANOVAout.xls',one_col,two_col);
    writetable(ANOVA_T,ANOVA_Tname);
    save('ANOVA_Tnametemp.mat','ANOVA_Tname');
end
start_point = 1;
% [d,p] = manova1([manova_matrix(:,1) manova_matrix(:,2) manova_matrix(:,3) ...
%     manova_matrix(:,4) manova_matrix(:,5) manova_matrix(:,6)],origin)
