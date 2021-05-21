function cmap_volcano = class_seroprotein_coersion(cmap_class,class,seroprotein)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

cmap_volcano = zeros(size(seroprotein,1),size(cmap_class,2));
for count = 1:1:size(class,1)
    for count_seroprotein = 1:1:size(seroprotein,1)
        if strcmp(class(count,1),seroprotein(count_seroprotein,1))
            cmap_volcano(count_seroprotein,:) = cmap_class(count,:);
        end
    end
end
