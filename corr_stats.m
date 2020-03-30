function corr_stats(wrkshtcol1,wkrshtcol2)

corr(wrkshtcol1(~isnan(wrkshtcol1)&~isnan(wkrshtcol2)),wkrshtcol2(~isnan(wrkshtcol1)&~isnan(wkrshtcol2)))

end