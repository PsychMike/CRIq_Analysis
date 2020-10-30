function [new_scores scaled_fts med_ft] = regress_scores(old_scores,regress_var,binning,use_indivs)
x = regress_var;
if binning && ~use_indivs
    new_scores = mean(old_scores,2);
else
    new_scores = old_scores;
end
y = new_scores;
format long
b1 = x\y;
yCalc1 = b1*x;
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2);
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
new_scores = new_scores - yCalc2;
mean_ft = mean(new_scores);
std_ft = std(new_scores);
stand_fts = (new_scores-mean_ft)/std_ft;
if ~binning
    scaled_fts = stand_fts*15+100;
else
    scaled_fts = stand_fts;
end
med_ft = median(scaled_fts);
end