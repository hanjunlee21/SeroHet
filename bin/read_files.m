function [matrix,seroprotein,groupID] = read_files(path_matrix,path_seroprotein,path_groupID)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

if ~strcmp(path_matrix(end-3:end), ".txt")||~strcmp(path_seroprotein(end-3:end), ".txt")||~strcmp(path_groupID(end-3:end), ".txt")
    error('Inputs must be .txt files');
end

matrix = readmatrix(path_matrix, 'FileType', 'text', 'Delimiter', '\t');
seroprotein = readmatrix(path_seroprotein, 'FileType', 'text', 'Delimiter', '\t', 'OutputType', 'string');
groupID = readmatrix(path_groupID, 'FileType', 'text', 'Delimiter', '\t', 'OutputType', 'string');

if size(matrix, 1)~=size(seroprotein, 1) 
    error('Dimension of the input matrix does not match seroprotein list');
end
if size(matrix, 2)~=size(groupID, 1)
    error('Dimension of the input matrix does not match groupID list');
end

groupID = groupID((sum(isnan(matrix))==0),1);
matrix = matrix(:,(sum(isnan(matrix))==0));
