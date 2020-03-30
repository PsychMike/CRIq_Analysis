for i = 1:CRI_all_vals
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
    end
    try
        wms_tot_nVals(i) = wms_een_nVals(i) + wms_twee_nVals(i);
    end
end