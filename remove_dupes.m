%% Removes duplicately binned subjects from top score matrices

% Create list of uniquely binned subs
all_subs = [top1_subs;top2_subs;top3_subs;top4_subs];
uniq_subs = unique(all_subs);

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
