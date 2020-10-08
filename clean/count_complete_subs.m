% mod_wrksht = worksheet(:,(2:26));
% mod_wrksht(:,end+1:end+4) = worksheet(:,33:36);
% mod_wrksht(:,end+1:end+11) = worksheet(:,37:47);
% mod_wrksht(:,end+1:end+3) = worksheet(:,50:52);
% mod_wrksht = mod_wrksht(1:length(current_sub),:);

mod_wrksht = analysis_matrix;
count = 0;

for i = 1:size(analysis_matrix,1)
    skip_row = 0;
    for j = 1:size(mod_wrksht,2)
        if isnan(mod_wrksht(i,j))
            skip_row = 1;
        end
    end
    if ~skip_row
        count = count + 1;
        complete_subs(count,:) = mod_wrksht(i,:);
    end
end