[num,raw,txt] = xlsread('CRIq computation.xls');
txt{8,4} = 20;
xlswrite('CRIq computation.xls',txt);