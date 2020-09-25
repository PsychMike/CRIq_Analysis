%Orders leisure activities by cognitive rankings
% clear all
[worksheet,txt,raw] = xlsread('rankleis2.csv');

% labels = txt{1,:};
% for i = 1:length(labels)
%     if strcmp(labels(i),',')
%         labstartpoint = i+1;
%         break
%     end
% end
% for i = labstartpoints:length(labels)
%
% end

start_pts = zeros(size(txt,1),size(txt,2));
for i = 2:size(txt,1)
    txt2 = txt{i};
    for j = 1:size(txt2,2)
        txt3 = txt2;
        curr_spot = txt3(j);
        if strcmp(curr_spot,',') && start_pts(i) == 0
            start_pts(i) = j+1;
        end
    end
end

rank_mat = zeros(size(txt,1)-1,size(txt,2));
for i = 2:size(txt,1)
    col = 0;
    txt2 = txt{i};
    for j = 1:size(txt2,2)
        txt3 = txt2(j);
        curr_spot = txt3;
        if j >= start_pts(i)
            %             if ~strcmp(curr_spot,',') && ~strcmp(curr_spot,'/') && ~strcmp(curr_spot,' ')
            if ~isempty(str2num(curr_spot))
                col = col + 1;
                try
                    rank_mat(i-1,col) = str2num(curr_spot);
                catch
                    keyboard
                end
            end
        end
    end
end
rank_labels = {'newspaper','chores','driving','leisure_acts','new_tech','social','cinema', ...
    'garden','grandchildren','volunteer','art','concerts','journeys','reading','children', ...
    'pets','account'};
mean_ranks = mean(rank_mat);
index_row = 1:length(rank_labels);
new_rank_mat(1,:) = index_row;
new_rank_mat(2,:) = mean_ranks;
[sort_ranks,index_mat] = sort(mean_ranks,'descend');
rank_labels2 = rank_labels(index_mat)
med_rank = median(sort_ranks);
best_ranks = sum(sort_ranks>=med_rank);
best_leis = rank_labels2(1:best_ranks);
worst_ranks = sum(sort_ranks<med_rank);
worst_leis = rank_labels2(best_ranks+1:end);

% best_leis = best_leis(1:end);
% worst_leis = worst_leis(1:end);

% new = 0;
% for i = 1:length(sort_rank_mat)
%     curr_rank = sort_rank_mat(i);
%     for j = 1:size(new_rank_mat,2)
%         try
%             if new_rank_mat(j) == curr_rank
%                 new = new + 1;
%                 best2worst_leis{new} = rank_labels(1,j);
%             end
%         catch
%             keyboard
%         end
%     end
% end