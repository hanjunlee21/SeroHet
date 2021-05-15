function cmap_class = cmap_seroprotein(cmap,signature,class)

% SeroHet software version 1.1
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

cmap_class = zeros(size(class,1),3);
for count = 1:1:size(class,1)
    cmap_class(count,:) = cmap(sum(strcmp(signature,class(count,2)).*((1:size(signature,1)).')),:);
end