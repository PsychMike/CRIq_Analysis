%% Sums WMS-R scores
for i = 1:size(worksheet,1)
stringnum1 = num2str(worksheet(i,42));
digit1 = str2num(stringnum1(1));
digit2 = str2num(stringnum1(end));
WMS_score1 = digit1 + digit2;
stringnum2 = num2str(worksheet(i,43));
digit1 = str2num(stringnum2(1));
digit2 = str2num(stringnum2(end));
WMS_score2 = digit1 + digit2;
WMS_vals(i) = WMS_score1 + WMS_score2;
end