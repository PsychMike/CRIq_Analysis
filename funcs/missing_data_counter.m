mod_wrksht = analysis_matrix;
% count = 0;
try
clear zero_matrix
end
zero_matrix = zeros(size(analysis_matrix));

for i = 1:current_sub
    skip_row = 0;
    for j = 1:size(mod_wrksht,2)
        if isnan(mod_wrksht(i,j))
            zero_matrix(i,j) = zero_matrix(i,j) + 1;
%             skip_row = 1;
        end
    end
%     if ~skip_row
%         count = count + 1;
%         complete_subs(count,:) = mod_wrksht(i,:);
%     end
end

zero_matrix(end+1,:) = sum(zero_matrix);

sum(zero_matrix)