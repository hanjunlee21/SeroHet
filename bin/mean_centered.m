function output = mean_centered(matrix,install_path,version,class)

% SeroHet software version 1.0
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

matrix = log(1+matrix);
reference = readmatrix([install_path '/library/SeroHet.v.' version(1) '.0.matrix.txt'], 'FileType', 'text', 'Delimiter', '\t');
reference = log(1+reference);
type = readmatrix([install_path '/library/SeroHet.v.' version(1) '.0.cancertype.txt'], 'FileType', 'text', 'Delimiter', '\t', 'OutputType', 'string');
reference = reference(:,~strcmp(type,"Healthy Control"));
seroprotein = readmatrix([install_path '/library/SeroHet.v.' version(1) '.0.seroprotein.txt'], 'FileType', 'text', 'Delimiter', '\t', 'OutputType', 'string');

m = mean(reference.').';
sigma = std(reference.').';

output = zeros(size(matrix,1),size(matrix,2));
for x = 1:1:size(matrix,1)
    for y = 1:1:size(matrix,2)
        idx = sum(strcmp(class(x,1),seroprotein).*((1:size(matrix,1)).'));
        output(x,y) = (matrix(x,y)-m(idx,1))/sigma(idx,1);
    end
end