%Find Parameters
clear all
fileId = fopen('criq_analysis.m');
file_format = fscanf(fileId, '%c');
for i = 1:length(file_format)
    if ~strcmp(file_format(i),'%')
        new_ff(i) = file_format(i);
    else
        break
    end
end
sprintf('%s',new_ff)