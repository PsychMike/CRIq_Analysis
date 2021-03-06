%% Extracts MRI numbers of associated participants
[worksheet,txt,raw] = xlsread('MRI_nums.xlsx');

mri_nums = zeros(1,length(raw)-1);
behav_nums = zeros(1,length(raw)-1);

for i = 1:length(worksheet)
    i = i + 1;
    extract_cell = raw{i,1};
    if ~isnan(extract_cell)
        if isnumeric(extract_cell(2))
            extract_num = str2num(extract_cell(2:end));
        else
            extract_num = str2num(extract_cell(3:end));
        end
        try
            mri_nums(i-1) = extract_num;
        catch
            keyboard
        end
        extract_cell = raw{i,2};
        if length(extract_cell) > 1
            extract_num = extract_cell(1:3);
            if ~isnumeric(extract_num)
                try
                    new_num = extract_num{1:end};
                    extract_cell = new_num;
                end
            else
                extract_cell = extract_num;
            end
        end
        try
            behav_nums(i-1) = extract_cell;
        catch
            try
                behav_nums(i-1) = str2num(extract_num);
                got_num = 1;
            catch
                got_num = 0;
            end
            if ~got_num
                behav_nums(i-1) = 0;
            end
        end
    else
        behav_nums(i-1) = 0;
    end
end