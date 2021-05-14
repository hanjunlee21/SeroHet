function sorted_signature = sort_signature(signature)

% SeroHet software version 1.0
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

count = cellfun(@(x)sscanf(x,"Signature %d"), signature);
[~,idx] = sort(count);
sorted_signature = signature(idx);