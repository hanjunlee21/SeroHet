function entire_path = full_path(path,install_path)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

if strcmp(path(2),':')
    entire_path = path;
else
    entire_path = [install_path path];
end
