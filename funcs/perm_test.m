clearvars score_bin1 score_bin2 score_diffs ps
test_names = {'SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'};

num_perms = 100000;

for i = 1:length(test_names)
    ps{1,i} = test_names{i};
end

for col = 1:size(best_leis_data,2)
    b_scores = best_leis_data(:,col);
    w_scores = worst_leis_data(:,col);
    mean_b_score = mean(b_scores);
    mean_w_score = mean(w_scores);
    
    diff_score = abs(mean_b_score-mean_w_score);
    
    all_scores = [b_scores' w_scores'];
    
    score_length = length(all_scores);
    for p = 1:num_perms
        both_randperm = randperm(score_length);
        b1_count=0;b2_count=0;w1_count=0;w2_count=0;
        for row = 1:size(all_scores,2)
            if mod(row,2)
                b1_count = b1_count + 1;
                score_bin1(b1_count) = all_scores(both_randperm(row));
            else
                w1_count = w1_count + 1;
                score_bin2(w1_count) = all_scores(both_randperm(row));
            end
        end
        score_diffs(p) = abs(mean(score_bin1) - mean(score_bin2));
    end
    chance_of_diff = sum(score_diffs>=diff_score)/num_perms;
    ps{2,col} = num2str(chance_of_diff);
end
ps