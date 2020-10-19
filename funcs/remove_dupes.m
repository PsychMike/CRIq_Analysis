%% Removes duplicately binned subjects from top score matrices

% Create list of uniquely (& non-uniquely) binned subs
try clear all_subs; end
all_subs = [top1_subs;top2_subs;top3_subs;top4_subs];
% o=length(all_subs)
% p=length(all_subs) - length(unique(all_subs))
% p/o*100
% keyboard
subcount_mat = zeros(max(all_subs),2);
subcount_mat(:,2) = 1:length(subcount_mat);
for i = 1:length(all_subs)
    subcount_mat(all_subs(i),1) = subcount_mat(all_subs(i),1) + 1;
end

try clear uniq_subs; end
count = 0; count2 = 0;
for i = 1:length(all_subs)
    if subcount_mat(all_subs(i),1) == 1
        count = count + 1;
        uniq_subs(count) = subcount_mat(all_subs(i),2);
    elseif subcount_mat(all_subs(i),1) > 1
        count2 = count2 + 1;
        nonuniq_subs(count2) = subcount_mat(all_subs(i),2);
    end
end

% Find uniquely binned subs using list
for top_num = 1:4
    eval(sprintf('uniq%d_subs = find_uniqs(top%d_subs,uniq_subs)',top_num,top_num));
end

function new_uniq_subs = find_uniqs(subs,uniq_subs)
new_uniq_subs = zeros(length(uniq_subs),1);
subs(end+(length(uniq_subs)-length(subs)))=0;
for i = 1:length(uniq_subs)
    c = intersect(uniq_subs(i),subs);
    if c
        new_uniq_subs(i) = subs(i);
    end
end
new_uniq_subs = new_uniq_subs(new_uniq_subs~=0);
end
