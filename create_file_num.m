function [file_num] = create_file_num(in_mri_nums,in_mri_count)

ph_num = '000';
str_num = num2str(in_mri_nums(in_mri_count));

m = 3 - length(str_num) + 1;
ph_num(m:end) = str_num;
file_num = ph_num;

end