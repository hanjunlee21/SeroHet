function output = logistic_transformation(matrix,mismatch)

% SeroHet software version 1.1
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

output = exp(matrix)./(1+exp(matrix));

for x = 1:1:size(matrix,1)
    if mismatch(x, 1) == 1
        for y = 1:1:size(matrix,2)
            output(x,y) = 0;
        end
    end
end