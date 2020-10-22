%elim_dupes

ntc = 0;
for i = 1:size(top_subs,1)
    if ~sum(find(top_subs(i,1)==top_subs(:,2)))
        ntc = ntc + 1;
        new_top_subs(ntc,1) = top_subs(i,1);
        new_top_subs(ntc,2) = top_subs(i,2);
    end
end
top_subs = new_top_subs;