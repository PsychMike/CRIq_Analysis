close all

rng('default');  % For reproducibility
X = [gallery('uniformdata',[10 3],12); ...
    gallery('uniformdata',[10 3],13)+1.2; ...
    gallery('uniformdata',[10 3],14)+2.5];
y = [ones(10,1);2*(ones(10,1));3*(ones(10,1))]; % Actual classes

S = repmat([50,50,50],numel(X(:,1))/3,1);
C = repmat([1,2,3],numel(X(:,1))/3,1);
s = S(:);
c = C(:);

b_val = 0.75;
h=scatter3(X(:,1),X(:,2),X(:,3),s,c,'filled','o','MarkerEdgeColor',[b_val b_val b_val]);
%100,y,'filled')
view(40,35)
title('Leisure Activity Clusters','fontsize',18);