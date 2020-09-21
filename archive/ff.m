%Find Parameters
clear all
fileId = fopen('criq_analysis.m');
file_format = fscanf(fileId, '%c');
% for i = 1:length(file_format)
%     if ~strcmp(file_format(i),'%')
%         new_ff(i) = file_format(i);
%     else
%         break
%     end
% end
wtfisgoingon = {'one_col','two_col','binning','use_vars'};
for j = 1:length(file_format)
    i = j;
    if i > 1
        binning = 1;
        use_vars = 1;
    else
        binning = 0;
        use_vars = 0;
    end
    if i == 1; one_col = 0; two_col = 0;
    elseif i == 2; one_col = 1; two_col = 2;
    elseif i == 3; one_col = 1; two_col = 3;
    elseif i == 4; one_col = 1; two_col = 4;
    elseif i == 5; one_col = 2; two_col = 3;
    elseif i == 6; one_col = 3; two_col = 4;
    end
    j = i;
    for s = 1:length(wtfisgoingon)
        %         if strcmp(file_format(j:j+length(strings{s})-1),strings{s})
        try
            if strcmp(file_format(j:j+length(wtfisgoingon{1})-1),wtfisgoingon{1})
                %             if s == 1
                insert = one_col;
                file_format(length(wtfisgoingon{s})+3) =  insert;
                
            elseif strcmp(file_format(j:j+length(wtfisgoingon{2})-1),wtfisgoingon{2})
                
                %             elseif s == 2
                insert = two_col;
                file_format(length(wtfisgoingon{s})+3) =  insert;
                
                %             elseif s == 3
            elseif strcmp(file_format(j:j+length(wtfisgoingon{3})-1),wtfisgoingon{3})
                
                insert = binning;
                file_format(length(wtfisgoingon{s})+3) =  insert;
                
                %             elseif s == 4
            elseif strcmp(file_format(j:j+length(wtfisgoingon{4})-1),wtfisgoingon{4})
                insert = use_vars;
                file_format(length(wtfisgoingon{s})+3) =  insert;
                
            end
%         catch
%             keyboard
        end
        %         try
        %             file_format(length(strings{s})+3) =  insert;
        %         end
    end
    % end
    %     if strcmp(file_format(j:j+9),'one_col = ')
    %         keyboard
    %     end
    end
    
    % for i = 1:6
    new_ff = fopen('aaff.m','w');
    fclose(new_ff);
    new_ff = fopen('aaff.m','a');
    file_format = string(file_format);
    fprintf(new_ff,'%s',file_format);
    fclose(new_ff);
%     sprintf('%s',new_ff);
    % fprintf('aaff.m',new_ff);
    aaff
% end
% if i == 1; one_col = 0; two_col = 0;
% elseif i == 2; one_col = 1; two_col = 2;
% elseif i == 3; one_col = 1; two_col = 3;
% elseif i == 4; one_col = 1; two_col = 4;
% elseif i == 5; one_col = 2; two_col = 3;
% elseif i == 6; one_col = 3; two_col = 4;
% end