add = 0;
if size(best_ft_data,1) > size(worst_ft_data,1)
    for i = 1:size(worst_ft_data,1)
       sums(i) = sum(best_ft_data(i,:)); 
    end
    sorted_sums = sort(sums,'descend');
%     sorted_sums = sort(sums);
    sorted_sums = sorted_sums(1:size(worst_ft_data,1));
    for i = 1:size(best_ft_data,1)
        data_sum = sum(best_ft_data(i,:));
        for j = 1:size(sorted_sums,2)
            if data_sum == sorted_sums(j)
                add = add + 1;
                bestbests(add) = i;
            end
        end
    end
    best_ft_data = best_ft_data(bestbests,:);
elseif size(best_ft_data,1) < size(worst_ft_data,1)
    for i = 1:size(best_ft_data,1)
       sums(i) = sum(worst_ft_data(i,:)); 
    end
    sorted_sums = sort(sums);
%     sorted_sums = sort(sums,'descend');
    sorted_sums = sorted_sums(1:size(best_ft_data,1));
    for i = 1:size(worst_ft_data,1)
        data_sum = sum(worst_ft_data(i,:));
        for j = 1:length(sorted_sums)
            if data_sum == sorted_sums(j)
                add = add + 1;
                worstworsts(add) = i;
            end
        end
    end
    worst_ft_data = worst_ft_data(worstworsts,:);
end