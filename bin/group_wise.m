function [score,errhigh,errlow] = group_wise(matrix,groupID,group)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

score = zeros(size(group,1),size(matrix,1));
errhigh = zeros(size(group,1),size(matrix,1));
errlow = zeros(size(group,1),size(matrix,1));
for count = 1:1:size(group,1)
    data = [];
    for groupIDcount = 1:1:size(groupID,1)
        if strcmp(groupID(groupIDcount,1),group(count,1))
            data = [data; matrix(:,groupIDcount).'];
        end
    end
    score(count,:) = mean(data);
    errhigh(count,:) = std(data)/sqrt(sum(strcmp(groupID,group(count,1))));
    errlow(count,:) = std(data)/sqrt(sum(strcmp(groupID,group(count,1))));
    for errcount = 1:1:size(matrix,1)
        if score(count,errcount) + errhigh(count,errcount) > 1
            errhigh(count,errcount) = 1 - score(count,errcount);
        end
        if score(count,errcount) - errlow(count,errcount) < 0
            errlow(count,errcount) = score(count,errcount);
        end
    end
end
