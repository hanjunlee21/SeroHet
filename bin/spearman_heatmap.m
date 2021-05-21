function hmap = spearman_heatmap(matrix)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

hmap = zeros(size(matrix,1),size(matrix,1));
for x = 1:1:size(matrix,1)
    for y = 1:1:size(matrix,1)
        hmap(x,y) = corr(matrix(size(matrix,1)+1-x,:).',matrix(y,:).','Type','Spearman','Rows','pairwise');
    end
end
