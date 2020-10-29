%% Split data into upper & lower tiers

% Fix & set variables
am2 = analysis_matrix;
analysis_matrix = analysis_matrix(:,7:end);
edu_scores = analysis_matrix(:,3);
work_scores = analysis_matrix(:,4);

%% Plot linear regression of age & leisure scores
regress_age = 1;
if regress_age
    x = ages';
    y = CRI_leis_vals;
    x = x';
    y = y';
    format long
    b1 = x\y;
    if plot_ft == 2
        close all
        figure
    end
    yCalc1 = b1*x;
    if plot_ft == 2
        scatter(x,y)
        hold on
        plot(x,yCalc1)
        xlabel('Age')
        ylabel('Leisure Scores')
        title('Linear Regression Relation Between Age & Leisure Scores')
        grid on
    end
    X = [ones(length(x),1) x];
    b = X\y;
    yCalc2 = X*b;
    if plot_ft == 2
        plot(x,yCalc2,'--')
        legend('Data','Slope','Slope & Intercept','Location','best');
    end
    CRI_leis_vals = CRI_leis_vals - yCalc2';
    mean_ft = mean(CRI_leis_vals);
    std_ft = std(CRI_leis_vals);
    stand_fts = (CRI_leis_vals-mean_ft)/std_ft;
    scaled_fts = stand_fts*15+100;
    med_ft = median(scaled_fts); % Find best & worst subs and their data
end

%% Plot linear regression of education & leisure scores
regress_edu = 0;
if regress_edu
    x = edu_scores';
    y = CRI_leis_vals;
    x = x';
    y = y';
    format long
    b1 = x\y;
    if plot_ft == 2
        figure
    end
    yCalc1 = b1*x;
    if plot_ft == 2
        scatter(x,y)
        hold on
        plot(x,yCalc1)
        xlabel('Age')
        ylabel('Leisure Scores')
        title('Linear Regression Relation Between Education & Leisure Scores')
        grid on
    end
    X = [ones(length(x),1) x];
    b = X\y;
    yCalc2 = X*b;
    if plot_ft == 2
        plot(x,yCalc2,'--')
        legend('Data','Slope','Slope & Intercept','Location','best');
    end
    CRI_leis_vals = CRI_leis_vals - yCalc2';
    mean_ft = mean(CRI_leis_vals);
    std_ft = std(CRI_leis_vals);
    stand_fts = (CRI_leis_vals-mean_ft)/std_ft;
    scaled_fts = stand_fts*15+100;
    med_ft = median(scaled_fts); % Find best & worst subs and their data
end
%% Plot linear regression of work & leisure scores
regress_work = 0;
if regress_work
    x = work_scores';
    y = CRI_leis_vals;
    x = x';
    y = y';
    format long
    b1 = x\y;
    if plot_ft == 2
        figure
    end
    yCalc1 = b1*x;
    if plot_ft == 2
        scatter(x,y)
        hold on
        plot(x,yCalc1)
        xlabel('Age')
        ylabel('Leisure Scores')
        title('Linear Regression Relation Between Education & Leisure Scores')
        grid on
    end
    X = [ones(length(x),1) x];
    b = X\y;
    yCalc2 = X*b;
    if plot_ft == 2
        plot(x,yCalc2,'--')
        legend('Data','Slope','Slope & Intercept','Location','best');
    end
    CRI_leis_vals = CRI_leis_vals - yCalc2';
    mean_ft = mean(CRI_leis_vals);
    std_ft = std(CRI_leis_vals);
    stand_fts = (CRI_leis_vals-mean_ft)/std_ft;
    scaled_fts = stand_fts*15+100;
    med_ft = median(scaled_fts);% Find best & worst subs and their data
end
if ~regress_age && ~regress_edu && ~regress_work
    scaled_fts = CRI_leis_vals;
    med_ft = median(scaled_fts);
end

%% Find best and worst data
best_count = 0;
worst_count = 0;

if binning == 0
    for i = 1:length(scaled_fts)
        if ~isnan(scaled_fts(i))
            if scaled_fts(i) > med_ft
                best_count = best_count + 1;
                best_fts(best_count) = scaled_fts(i);
                best_leis_data(best_count,:) = analysis_matrix(i,:);
                best_leis_subs(best_count) = sub_nums(i);
            elseif scaled_fts(i) < med_ft
                worst_count = worst_count + 1;
                worst_fts(worst_count) = scaled_fts(i);
                worst_leis_data(worst_count,:) = analysis_matrix(i,:);
                worst_leis_subs(worst_count) = sub_nums(i);
            end
        end
    end
    
    %% Find bin data, if binning
else
    clear best_leis_subs worst_leis_subs one_col_data two_col_data worst_fts best_fts
    one_count = 0; two_count = 0;
    elim_dupes
    for i = 1:length(sub_nums)
        for j = 1:length(top_subs(:,1))
            if sub_nums(i) == top_subs(j,1)
                one_count = one_count + 1;
                one_col_data(one_count,:) = analysis_matrix(i,:);
                best_fts(one_count) = scaled_fts(i);
                best_leis_subs(one_count) = sub_nums(i);
            elseif sub_nums(i) == top_subs(j,2)
                two_count = two_count + 1;
                two_col_data(two_count,:) = analysis_matrix(i,:);
                worst_fts(two_count) = scaled_fts(i);
                worst_leis_subs(two_count) = sub_nums(i);
            end
        end
    end
    best_leis_data = one_col_data;
    worst_leis_data = two_col_data;
end

%% Eliminate outliers from the datasets
if elim_outliers
    if outlie_indiv
        [best_leis_data,best_leis_subs,best_fts] = find_outliers3(best_leis_data,best_leis_subs,best_fts);
        [worst_leis_data,worst_leis_subs,worst_fts] = find_outliers3(worst_leis_data,worst_leis_subs,worst_fts);
    else
        [best_leis_data,best_leis_subs,best_fts] = find_outliers2(best_leis_data,best_leis_subs,best_fts);
        [worst_leis_data,worst_leis_subs,worst_fts] = find_outliers2(worst_leis_data,worst_leis_subs,worst_fts);
    end
end

%% Find upper & lower quartile data
if uplow_quart && ~binning
    b_med = median(best_fts);
    w_med = median(worst_fts);
    
    if more_subs
        sort_bfts = sort(best_fts,'descend');
        sort_wfts = sort(worst_fts);
        bbot = sort_bfts(1:floor(length(sort_bfts)*perc_include));
        wbot = sort_wfts(1:floor(length(sort_wfts)*perc_include));
        b_med = min(bbot);
        w_med = max(wbot);
    end
    
    comb_subs = [best_leis_subs worst_leis_subs];
    clear best_fts bestis best_leis_data best_leis_subs worst_fts worst_is worst_leis_data worst_leis_subs
    best_count = 0; worst_count = 0; b2_count = 0; w2_count = 0;
    for i = 1:length(scaled_fts)
        if sum(any(sub_nums(i)==comb_subs))
            if scaled_fts(i) > b_med
                best_count = best_count + 1;
                best_fts(best_count) = scaled_fts(i);
                best_is(best_count) = i;
                best_leis_data(best_count,:) = analysis_matrix(best_is(best_count),:);
                best_leis_subs(best_count) = sub_nums(i);
            elseif scaled_fts(i) < w_med
                worst_count = worst_count + 1;
                worst_fts(worst_count) = scaled_fts(i);
                worst_is(worst_count) = i;
                worst_leis_data(worst_count,:) = analysis_matrix(worst_is(worst_count),:);
                worst_leis_subs(worst_count) = sub_nums(i);
            end
        elseif sum(best_leis_subs==sub_nums(i)) || sum(worst_leis_subs==sub_nums(i))
            keyboard
        end
    end
end

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
            ss_i = sort_i(1:length(worst_fts));
            best_fts = best_fts(ss_i);
            best_leis_data = best_leis_data(ss_i,:);
        elseif length(worst_fts)>length(best_fts)
            [sort_fts,sort_i] = sort(worst_fts);
            ss_i = sort_i(1:length(best_fts));
            worst_fts = worst_fts(ss_i);
            worst_leis_data = worst_leis_data(ss_i,:);
        end
    end
end

% Choose which variables to include in ANOVA
Ps = zeros(1,size(best_leis_data,2));
anova_all_data = 0;
if anova_all_data
    for_end = 1;
else
    for_end = size(best_leis_data,2);
end

if perm
    perm_test
end

if anova
    try clear nonan_best_fts nonan_worst_fts;end
    for start_point = 1:for_end
        if anova_all_data
            start_point = 1;
            end_point = size(best_leis_data,2);
        else
            end_point = start_point;
        end
        m_best_leis_data = best_leis_data(:,start_point:end_point);
        m_worst_leis_data = worst_leis_data(:,start_point:end_point);
        if elim_indiv
            if start_point == 7
                ty = 1;
            end
            [m_best_leis_data] = remove_outliers(m_best_leis_data);
            [m_worst_leis_data] = remove_outliers(m_worst_leis_data);
        end
        mean_plots_b(start_point) = mean(m_best_leis_data);
        mean_plots_w(start_point) = mean(m_worst_leis_data);
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
            end
        end
        for i = 1:length(nonan_worst_fts)
            sub_count = sub_count + 1;
            origin(sub_count) = 2;
            for j = 1:size(nonan_worst_fts,2)
                count = count + 1;
                anova_matrix(count,:) = [nonan_worst_fts(i,j) 2 j sub_count];
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
        Ps = round(Ps,3,'decimal');
        for i = 1:length(Ps)
            if Ps(i) < 0.05
                Ps(i) = Ps(i) + 100;
            end
        end
        if ~use_indivs && ~all_comps
            ANOVA_T=table(Ps(1),Ps(2),Ps(3),Ps(4),Ps(5),Ps(6),Ps(7),'VariableNames',{'SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'})
        else
            ANOVA_T=table(Ps(1),Ps(2),Ps(3),Ps(4),Ps(5),Ps(6),Ps(7),'VariableNames',{'SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'});
        end
        ANOVA_Tname = sprintf('output/%d%d_ANOVAout.xls',one_col,two_col);
    end
    start_point = 1;
end

if perm
    mean_plots_b = median(best_leis_data);
    mean_plots_w = median(worst_leis_data);
end
aa=size(best_leis_data,1);
% Plot best & worst data
if plot_ft
    figure
    plot(mean_plots_b);
    hold on
    plot(mean_plots_w);
    
%     hold on
%     plot(1:7,best_leis_data(:,1:7),'co');
%     hold on
%     plot(1:7,worst_leis_data(:,1:7),'ro');
    
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
