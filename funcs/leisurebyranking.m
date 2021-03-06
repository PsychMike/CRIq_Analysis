%Orders leisure activities by cognitive rankings
[worksheet,txt,raw] = xlsread('rankleis2.csv');

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
rank_labels2 = rank_labels(index_mat);

end_point = 8;
best_leis = rank_labels2(1:end_point);
worst_leis = rank_labels2(end-end_point+1:end);
