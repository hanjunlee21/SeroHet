function class = read_classification(install_path,version)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

class = readmatrix([install_path '/library/SeroHet.v.' version(1) '.0.classification.txt'], 'FileType', 'text', 'Delimiter', '\t', 'OutputType', 'string');
