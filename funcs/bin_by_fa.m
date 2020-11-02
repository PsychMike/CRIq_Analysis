%bin_by_fa
[worksheet,txt,raw] = xlsread('tables/component_activities.xlsx');

clear bins bin1 bin2 bin3 bin4
for b = 1:4
bins{1,b} = '';
bin1{1,1} = '';
bin2{1,1} = '';
bin3{1,1} = '';
bin4{1,1} = '';
end
for row = 1:size(worksheet,1)
    max_col = max(worksheet(row,:));
    for col = 1:size(worksheet,2)
        if worksheet(row,col) == max_col
            bins{end+1,col} = txt(row);
        end
    end
end
bins = bins(2:end,:);

for bin = 1:size(bins,1)
    for bin_col = 1:size(bins,2)
        if ~isempty(bins{bin,bin_col})
            switch bin_col
                case 1
                    bin1{end+1,1} = bins{bin,bin_col};
                case 2
                    bin2{end+1,1} = bins{bin,bin_col};
                case 3
                    bin3{end+1,1} = bins{bin,bin_col};
                case 4
                    bin4{end+1,1} = bins{bin,bin_col};
            end
        end
    end
end
bin1 = bin1(2:end,1);
bin2 = bin2(2:end,1);
bin3 = bin3(2:end,1);
bin4 = bin4(2:end,1);
% keyboard