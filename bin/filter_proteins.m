function [out_matrix,mismatch] = filter_proteins(matrix,seroprotein,class)

% SeroHet software version 1.0
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

out_matrix = zeros(size(class,1),size(matrix,2));
mismatch = zeros(size(class,1),1);

for count = 1:1:size(class,1)
    hasmatch = 0;
    for inputcount = 1:1:size(seroprotein,1)
        if strcmp(class(count,1),seroprotein(inputcount,1))
            hasmatch = 1;
            out_matrix(count,:) = matrix(inputcount,:);
        end
    end
    if hasmatch == 0
        mismatch(count,1) = 1;
    end
end

if sum(mismatch) == size(mismatch,1)
    error('None of the proteins match the nomenclature in library/SeroHet.v.1.0.seroprotein.txt');
end