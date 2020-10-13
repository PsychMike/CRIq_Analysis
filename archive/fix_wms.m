%% Sums WMS-R scores
for i = 1:length(CRI_all_vals)
    r_num = round(worksheet(i,42));
    deci_vals(i) = r_num - worksheet(i,42);
    deci_vals = deci_vals * 10;
    if ~isnan(deci_vals(i))
        if deci_vals(i) < 1
            wms_een_nVals(i) = abs(deci_vals(i)) + r_num;
        else
            deci_vals(i) = abs(deci_vals(i) - 10);
            wms_een_nVals(i) = deci_vals(i) + r_num - 1;
        end
    else
        wms_een_nVals(i) = NaN;
    end
    
    r_num = round(worksheet(i,43));
    deci_vals(i) = r_num - worksheet(i,43);
    deci_vals = deci_vals * 10;
    if ~isnan(deci_vals(i))
        if deci_vals(i) < 1
            wms_twee_nVals(i) = abs(deci_vals(i)) + r_num;
        else
            deci_vals(i) = abs(deci_vals(i) - 10);
            wms_twee_nVals(i) = deci_vals(i) + r_num - 1;
        end
    else
        wms_twee_nVals(i) = NaN;
    end
    try
        wms_tot_nVals(i) = round(wms_een_nVals(i)) + round(wms_twee_nVals(i));
    end
end
