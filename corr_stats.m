function corr_stats(wrkshtcol1,wkrshtcol2)

corrcoef(wrkshtcol1(~isnan(wrkshtcol1)&~isnan(wkrshtcol2)),wkrshtcol2(~isnan(wrkshtcol1)&~isnan(wkrshtcol2)))
% sprintf('%s%% correlated',num2str(corrcoef(wrkshtcol1(~isnan(wrkshtcol1)&~isnan(wkrshtcol2)),wkrshtcol2(~isnan(wrkshtcol1)&~isnan(wkrshtcol2)))*100))

end