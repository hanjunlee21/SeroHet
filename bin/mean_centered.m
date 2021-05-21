function output = mean_centered(matrix,groupID)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

output = zeros(size(matrix,1),size(matrix,2));
matrix = log(1+matrix);
m = mean(matrix(:,~strcmp(groupID,"Healthy Control")).').';
sigma = std(matrix(:,~strcmp(groupID,"Healthy Control")).').';

for x = 1:1:size(matrix,1)
    for y = 1:1:size(matrix,2)
        output(x,y) = (matrix(x,y)-m(x,1))/sigma(x,1);
    end
end
