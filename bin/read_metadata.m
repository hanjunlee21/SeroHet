function metadata = read_metadata(path_metadata)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

if ~strcmp(path_metadata(end-3:end), ".txt")
    error('Metadata input must be a .txt file');
end

metadata = readmatrix(path_metadata, 'FileType', 'text', 'Delimiter', '\t', 'OutputType', 'string');

if size(metadata,2) == 0
    error('No metadata recognized');
else
    for count = 1:1:size(metadata,2)
        if size(unique(metadata(:,count)),1) ~= 2
            disp('We are committed to challenging discrimination against non-binary people and strongly advocate non-binary inclusion.');
            error('Non-binary metadata analysis will be supported in future releases of SeroHet');
        end
    end
end
