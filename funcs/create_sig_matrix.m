sig_p_value = 0.05;
for i = 1:length(p)
    for j = 1:size(p,2)
        if p(i,j) < sig_p_value
            sig_matrix(i,j) = r(i,j);
        else
            sig_matrix(i,j) = NaN;
        end
    end
end
% print_matrix(1,:) = var_names;
% 
% for j = 1:length(sig_matrix)
%     for i = 1:length(sig_matrix)
%         print_matrix{i+1,j} = num2str(sig_matrix(i,j));
%     end
% end
% 
% xlswrite('sig_matrix.xls',print_matrix);

table(sig_matrix(:,1),sig_matrix(:,2),sig_matrix(:,3),sig_matrix(:,4),sig_matrix(:,5),sig_matrix(:,6),sig_matrix(:,7),sig_matrix(:,8),sig_matrix(:,9),sig_matrix(:,10),sig_matrix(:,11),sig_matrix(:,12),'VariableNames',var_names)