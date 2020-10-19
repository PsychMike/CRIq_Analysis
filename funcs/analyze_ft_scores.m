%% Set parameters %%
num_clusters = 3;

criq_l_scores = extract_scores(:,9:end);

for fold_code = 1
    % criq_l_nanmean = nanmean(criq_l_scores,1);
    
    % diff_scores = criq_l_scores - criq_l_nanmean;
    %
    % figure
    % R = corrplot(diff_scores);
    % R1 = R;
end

%% Plot & output item correlation matrix %%
plot_corr = 0;

if plot_corr == 1
    figure
    R = corrplot(criq_l_scores);
    R2 = R;
end

%% Find best item-to-item matches
clust_length = floor((length(R2)-1)/num_clusters);
clust_matrix = zeros(length(R2),(size(R2,2)-1));
sort_matrix = zeros(length(R2),clust_length+1);

for row = 1:length(R2)
    sorted_row = sort(R2(row,:),'descend');
    best_vals = sorted_row(2:clust_length+1);
    
    for col = 1:size(R2,2)
        if any(best_vals == R2(row,col))
            clust_matrix(row,col) = col;
        end
    end
    
    clust_row = clust_matrix(row,:);
    clust_row(end+1) = row;
    sorted_row = sort(clust_row,'descend');
    trim_sorted_row = sorted_row(1:clust_length+1);
    sort_matrix(row,:) = trim_sorted_row;
end

%% Find best grouping
for row = 1:length(sort_matrix)
    for comp_row = 1:length(sort_matrix)
        if row ~= comp_row
            group_matrix(row,comp_row) = sum(ismember(sort_matrix(row,:),sort_matrix(comp_row,:)));
        else
            group_matrix(row,comp_row) = 0;
        end
    end
end

best_group_val = max(max(group_matrix));
[row,col]=find(group_matrix==8);
group1 = unique(row);

% A = sort_matrix(1,:);
% B = sort_matrix(2,:);
% [ii,jj]=unique(B,'stable');
% n=numel(A);
% pos = zeros(n,1);
% for k = 1:n
%      pos(k)=jj(find(ii == A(k)));
% end