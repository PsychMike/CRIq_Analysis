flipped_CRIs = CRI_ft_vals';
ages = extract_scores(:,2);
analysis_matrix = analysis_matrix(:,7:end);

add_row = 0;
for row = 1:length(flipped_CRIs)
    if ~isnan(flipped_CRIs(row)) && ~isnan(ages(row))
        %         && CRI_ft_vals(row) < 200
        add_row = add_row + 1;
        new_ft_vals(add_row) = flipped_CRIs(row);
        new_ages(add_row) = ages(row);
    end
end

ages = new_ages;

mean_ft = mean(new_ft_vals);
std_ft = std(new_ft_vals);
stand_fts = (new_ft_vals-mean_ft)/std_ft;
scaled_fts = stand_fts*15+100;

med_ft = median(scaled_fts);
% med_ft = median(CRI_ft_vals(~isnan(CRI_ft_vals)));

x = ages;
y = new_ft_vals;
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
b = X\y
yCalc2 = X*b;
plot(x,yCalc2,'--')
legend('Data','Slope','Slope & Intercept','Location','best');
Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2)
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)

% mean_ft = mean(CRI_ft_vals(~isnan(CRI_ft_vals)));
best_count = 0;
worst_count = 0;

for i = 1:length(scaled_fts)
    if ~isnan(scaled_fts(i))
        if scaled_fts(i) >= med_ft
            best_count = best_count + 1;
            best_fts(best_count) = scaled_fts(i);
            best_is(best_count) = i;
            best_ft_data(best_count,:) = analysis_matrix(best_is(best_count),:);
            best_ft_subs(best_count) = sub_nums(i);
        else
            worst_count = worst_count + 1;
            worst_fts(worst_count) = scaled_fts(i);
            worst_is(worst_count) = i;
            worst_ft_data(worst_count,:) = analysis_matrix(worst_is(worst_count),:);
            worst_ft_subs(worst_count) = sub_nums(i);
        end
    end
end

length(best_fts)
length(worst_fts)

fBest_ft_data = best_ft_data(~isnan(best_ft_data));
fWorst_ft_data = worst_ft_data(~isnan(worst_ft_data));

mean_fBest_ft = nanmedian(best_ft_data);
% mean(fBest_ft_data);
mean_fWorst_ft = nanmedian(worst_ft_data);
% mean(fWorst_ft_data);

plot_ft = 1;
if plot_ft
    close all
    figure
    plot(mean_fBest_ft);
    hold on
    plot(mean_fWorst_ft);
    xticks(1:size(best_ft_data,2)+1);
    xticklabels(var_names(end-size(best_ft_data,2)+1:end));
    xlim([0 size(best_ft_data,2)+1]);
    legend(sprintf('n = %d',length(best_ft_data)),sprintf('n = %d',length(worst_ft_data)))
    % avg_ft = avg(CRI_ft_vals(~isnan(CRI_ft_vals)))
end

Ps = zeros(1,size(best_ft_data,2));
for start_point = 1:size(best_ft_data,2)
% start_point = 1;
end_point = start_point;
m_best_ft_data = best_ft_data(:,start_point:end_point);
m_worst_ft_data = worst_ft_data(:,start_point:end_point);

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
    P1 = BWAOV2(anova_matrix)
    Ps(start_point) = P1;
end

% keyboard
end
Ps = round(Ps,2,'decimal');
table(Ps(1),Ps(2),Ps(3),Ps(4),Ps(5),Ps(6),Ps(7),'VariableNames',{'SR','TMT','WMS','Stroop','Mem','MOCA','RUWE'})
% [d,p] = manova1([manova_matrix(:,1) manova_matrix(:,2) manova_matrix(:,3) ...
%     manova_matrix(:,4) manova_matrix(:,5) manova_matrix(:,6)],origin)

read_studysheet