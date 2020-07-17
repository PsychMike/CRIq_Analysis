add = 0;
if best
    for i = 1:size(best_ft_data,1)
       sums(i) = sum(best_ft_data(i,:)); 
    end
    sorted_sums = sort(sums,'descend');
    sorted_sums = sort(sums);
    sorted_sums = sorted_sums(1:length(worst_ft_data));
    for i = 1:size(best_ft_data,1)
        data_sum = sum(best_ft_data(i,:));
        for j = 1:length(sorted_sums)
            if data_sum == sorted_sums(j)
                add = add + 1;
                bestbests(add) = i;
            end
        end
    end
else
    for i = 1:size(worst_ft_data,1)
       sums(i) = sum(worst_ft_data(i,:)); 
    end
    sorted_sums = sort(sums);
    sorted_sums = sort(sums,'descend');
    sorted_sums = sorted_sums(1:length(best_ft_data));
    for i = 1:size(worst_ft_data,1)
        data_sum = sum(worst_ft_data(i,:));
        for j = 1:length(sorted_sums)
            if data_sum == sorted_sums(j)
                add = add + 1;
                worstworsts(add) = i;
            end
        end
    end
end