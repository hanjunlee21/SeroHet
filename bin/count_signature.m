function num_signature = count_signature(signature,class)

% SeroHet software version 1.1
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

num_signature = zeros(size(signature,1),1);
for count = 1:1:size(signature,1)
    num_signature(count,1) = sum(strcmp(signature(count,1),class(:,2)));
end