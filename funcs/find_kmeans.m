clear k_mat cut_scores

k_count = 0;
cut_scores = extract_scores(:,2:end)./extract_scores(:,1);
for row = 1:length(cut_scores)
    if ~sum(isnan(cut_scores(row,:))) && isnumeric(cut_scores(row,:)) && ~any(cut_scores(row,:)==63)
        k_count = k_count + 1;
        k_mat(k_count,:) = cut_scores(row,:);
    end
end

criq_l_scores = k_mat;

k_count = 0;
cut_range = 1:17;
cut_scores = criq_l_scores(:,cut_range);

clear k_mat
for row = 1:length(cut_scores)
    if ~sum(isnan(cut_scores(row,:))) && isnumeric(cut_scores(row,:)) && ~any(cut_scores(row,:)==63)
        k_count = k_count + 1;
        k_mat(k_count,:) = cut_scores(row,:);
    end
end

close all
run_clust = 1;
if run_clust
    num_clusters = 3;
    [idx3,C,sumdist3] = kmeans(k_mat',num_clusters,'Distance','cityblock','Replicates', ...
        100000,'Options',statset('Display','final'));
    figure
    [silh3,h] = silhouette(k_mat',idx3,'cityblock');
    xlabel('Silhouette Value');
    ylabel('Cluster');
end
clear even_group
grouping = zeros(1,length(criq_l_scores));
grouping(cut_range) = idx3';
for i = 1:num_clusters
    even_group(i) = sum(grouping==i);
end
even_group;
var(even_group);
criq_strings = {'newspaper','chores','driving','leisure_acts','new_tech','social','cinema','garden','grandchildren','volunteer','art','concerts','journeys','reading','children','pets','account'};
% weekly = grouping(1:5);
% monthly = grouping(6:11);
% yearly = grouping(12:14);
% fixeds = grouping(15:17);
grouping(cut_range);
group_count = zeros(1,num_clusters);
clear group_strings
for i = cut_range
    group_count(1,grouping(i)) = group_count(1,grouping(i)) + 1;
    group_strings{grouping(i),group_count(1,grouping(i))} = criq_strings{i};
end
group_strings
