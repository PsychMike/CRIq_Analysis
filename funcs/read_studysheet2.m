%% Extracts MRI numbers of associated participants
[worksheet,txt,raw] = xlsread('tables/MRI_nums2.xlsx');

mri_nums = worksheet';
behav_nums = zeros(1,length(raw));

for i = 1:length(raw)
    behav_nums(i) = str2num(raw{i,2});
end