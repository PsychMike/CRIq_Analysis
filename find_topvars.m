% global one_col two_col
%% Find subjects with high variance between bins
n = size(stand_bins,2);
k = 2;
num_comps = factorial(n)/(factorial(k)*factorial(n-k));
comparisons = [{'1,2'},{'1,3'},{'1,4'},{'2,3'},{'2,4'},{'3,4'}];
num_comps = length(comparisons);
wanted_comp = sprintf('%d,%d',one_col,two_col);

% Find diff vals between bins
for i = 1:size(stand_bins,1) %every subject
    for j = 1:num_comps %every comparison
        curr_comp = comparisons(j);
        curr_comp = curr_comp{1};
        one_comp = str2num(curr_comp(1));
        two_comp = str2num(curr_comp(end));
        if strcmp(curr_comp,wanted_comp)
            wanted_one_comp = one_comp;
            wanted_two_comp = two_comp;
            wanted_col = j;
        end
        %         try
        %             sub_var_scores(i,j) = abs(stand_bins(i,one_comp)-(stand_bins(i,two_comp)));
        %         catch
        %             keyboard
        %         end
        sub_var_scores(i,j) = abs(stand_bins(i,one_comp)-(stand_bins(i,two_comp)));
    end
end

% Find highest varying subs
try clear top_sub_vars; end
% for i = 1:size(sub_var_scores,2)
top_count = 0;
%     med_var = median(sub_var_scores(:,i));
med_var = median(sub_var_scores(:,wanted_col));
for j = 1:size(sub_var_scores,1)
    %         if sub_var_scores(j,i) >= med_var
    if sub_var_scores(j,wanted_col) > med_var
        top_count = top_count + 1;
        %             top_sub_vars(top_count,i) = sub_nums(j);
        top_sub_vars(top_count) = sub_nums(j);
    end
end
% end

% Create comparison bins
for i = 1:size(top_sub_vars,1)
    for j = 1:size(top_sub_vars,2)
        curr_sub = top_sub_vars(i,j);
        snum_index = find(top_sub_vars(i,j)==sub_nums);
        %         curr_comp = comparisons(j);
        %         curr_comp = curr_comp{1};
        curr_comp = wanted_comp;
        one_comp = str2num(curr_comp(1));
        two_comp = str2num(curr_comp(end));
        try
            if stand_bins(snum_index,one_comp) > stand_bins(snum_index,two_comp)
                sub_varbin(i,j) = one_comp;
                if one_comp == wanted_one_comp
                    want_subs(i,j) = one_comp;
                end
            else
                sub_varbin(i,j) = two_comp;
                if two_comp == wanted_two_comp
                    want_subs(i,j) = two_comp;
                end
            end
        catch
            keyboard
        end
    end
end

% Create comparison columns with wanted comparison
try clear top_subs; end
one_comp_count = 0; two_comp_count = 0;
% wanted_col = 6;
% sub_varbin = want_subs;
for i = 1:length(sub_varbin)
%     length(sub_varbin(:,wanted_col))
    %     wanted_sub = top_sub_vars(i,wanted_col);
    wanted_sub = top_sub_vars(i);
    right_col = sub_varbin(i);
    if right_col == wanted_one_comp
        one_comp_count = one_comp_count + 1;
        comp_count = one_comp_count;
    elseif right_col == wanted_two_comp
        two_comp_count = two_comp_count + 1;
        comp_count = two_comp_count;
    else
        keyboard
    end
    top_subs(comp_count,right_col) = wanted_sub;
end
