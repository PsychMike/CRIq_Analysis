clearvars score_bin1 score_bin2 score_diffs ps
test_names = {'SRT','TMT','WMSR','SCWT','PRMQ','MoCA','DART'};

num_perms = 1000;

for i = 1:length(test_names)
    ps{1,i} = test_names{i};
end
% round_int = 5;
for col = 1:size(best_leis_data,2)
    % col = 3;
    b_scores = best_leis_data(:,col);
    w_scores = worst_leis_data(:,col);
    mean_b_score = mean(b_scores);
    mean_w_score = mean(w_scores);
    
    diff_score = abs(mean_b_score-mean_w_score);
    
    all_scores = [b_scores' w_scores'];
    
    score_length = length(all_scores);
    for p = 1:num_perms
        %         mat1 = [ones(score_length/2,1)' zeros(score_length/2,1)'];
        %         rand_mat1 = randperm(length(mat1));
        %         for r = 1:length(rand_mat1)
        %             shuff_mat1(r) = mod(rand_mat1(r),2);
        %         end
        %         mat2 = [ones(score_length/2,1)' zeros(score_length/2,1)'];
        %         rand_mat2 = randperm(length(mat2));
        %         b_randperm = randperm(score_length);
        %         w_randperm = randperm(score_length);
        both_randperm = randperm(score_length);
        %         b_randperm = randi(score_length,1,score_length);
        %         w_randperm = randi(score_length,1,score_length);
        b1_count=0;b2_count=0;w1_count=0;w2_count=0;
        %     for r = 1:length(rand_mat2)
        %         shuff_mat2(r) = mod(rand_mat2(r),2);
        %     end
        for row = 1:size(all_scores,2)
            if mod(row,2)
                b1_count = b1_count + 1;
                score_bin1(b1_count) = all_scores(both_randperm(row));
            else
                w1_count = w1_count + 1;
                score_bin2(w1_count) = all_scores(both_randperm(row));
            end
            %         score_bin1(row) = all_scores(randi(length(all_scores)));
            %         score_bin2(row) = all_scores(randi(length(all_scores)));
            %                 p1 = shuff_mat1(row);
            %                 p2 = shuff_mat2(row);
            %                 if p1
            %                     b1_count = b1_count + 1;
            %                     score_bin1(row) = b_scores(b_randperm(b1_count));
            %                 else
            %                     w1_count = w1_count + 1;
            %                     score_bin1(row) = w_scores(w_randperm(w1_count));
            %                 end
            %                 if p2
            %                     b2_count = b2_count + 1;
            %                     score_bin2(row) = b_scores(b_randperm(b2_count));
            %                 else
            %                     w2_count = w2_count + 1;
            %                     score_bin2(row) = w_scores(w_randperm(w2_count));
            %                 end
        end
        %     score_means(p) = round(mean([(score_bin1) (score_bin2)]),2);
        score_diffs(p) = abs(mean(score_bin1) - mean(score_bin2));
    end
    % mean_b_scores = round(mean(b_scores),2);
    % mean_w_scores = round(mean(w_scores),2);
    % chance_of_b = sum(any(score_means==mean_b_scores))/num_perms*100;
    % chance_of_w = sum(any(score_means==mean_w_scores))/num_perms*100;
    chance_of_diff = sum(score_diffs>=diff_score)/num_perms;
    ps{2,col} = num2str(chance_of_diff);
    % sprintf('p = %s',num2str(chance_of_diff))
end
ps
% keyboard
% count = 0;
% for i = 1:length(score_bin1)
%     count = count + 1;
%             anova_matrix(count,:) = [score_bin1(i) 1 1 count];
% end
% for i = 1:length(score_bin2)
%     count = count + 1;
%                 anova_matrix(count,:) = [score_bin2(i) 2 1 count];
% end
% % anova_matrix(count,:) = [nonan_worst_fts(i,j) 2 j sub_count];
%         P1 = BWAOV2(anova_matrix);
%         round(P1,8,'decimal')
% keyboard