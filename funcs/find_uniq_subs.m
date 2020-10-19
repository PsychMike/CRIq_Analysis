%% Find unique subject numbers in top scores

top_subs;
all_subs = [top_subs(:,1);top_subs(:,2);top_subs(:,3);top_subs(:,4)];

orig_subs = zeros(1,max(all_subs));
all_subs = all_subs(all_subs~=0);
for i = 1:length(all_subs)
    orig_subs(all_subs(i)) = orig_subs(all_subs(i)) + 1;
end

orig_subs;
orig_subs=find(orig_subs==1);

try clear new_all_subs; end
count_array = zeros(1,4);
for i = 1:length(orig_subs)
    a = any(top_subs==orig_subs(i));
    col = find(a==1);
    count_array(col) = count_array(col) + 1;
    new_all_subs(count_array(col),col) = orig_subs(i);
end

uniq1_subs = new_all_subs(:,1);
uniq2_subs = new_all_subs(:,2);
uniq3_subs = new_all_subs(:,3);
uniq4_subs = new_all_subs(:,4);

%% Find scores of unique subjects


