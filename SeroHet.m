% Usage :
%    SeroHet('path_matrix','path_seroprotein','path_groupID','outdir');
%
% Arguments:
%     path_matrix - The path to .txt file containing the concentrations of each seroprotein
%     path_seroprotein - The path to .txt file containing the names of the seroprotein
%     path_groupID - The path to .txt file containing group IDs
%     outdir - An output directory where generated figures will be saved
%
% Output Figures:
%    (groupID).SeroHet.signatures.pdf : This bar plot compares the SerHet signatures in the given group
%

function SeroHet(path_matrix,path_seroprotein,path_groupID,outdir)

% SeroHet software version 1.0
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.
version = '1.0';

% Determine necessary paths
install_path = regexprep(which('SeroHet'),'SeroHet\.m$','');
bin_path = [install_path 'bin/'];
addpath(bin_path);

% Check input arguments
if nargin==0
    disp('Usage: SeroHet(path_matrix,path_seroprotein,path_groupID,outdir)');
    disp('User must specify a path to each input file and output directory');
    return;
end
if nargin==3
    disp('No output directory specified... using:');
    outdir = [install_path 'figure/'];
    disp(outdir);
end
if ~ischar(path_matrix)||~ischar(path_seroprotein)||~ischar(path_groupID)||~ischar(outdir)
    error('Inputs must be character arrays');
end
if ~strcmp(outdir(end),'/')
    outdir = [outdir '/'];
end

% Get full paths for each input file
path_matrix = full_path(path_matrix, install_path);
path_seroprotein = full_path(path_seroprotein, install_path);
path_groupID = full_path(path_groupID, install_path);

% Read files
[matrix,seroprotein,groupID] = read_files(path_matrix,path_seroprotein,path_groupID);
group = unique(groupID);

% Read classification
class = read_classification(install_path,version);
signature = unique(class(:,2));
signature = sort_signature(signature);

% Filter only SeroHet proteins
[matrix,mismatch] = filter_proteins(matrix,seroprotein,class);

% Mean-centered normalization based on reference data
matrix = mean_centered(matrix,install_path,version,class);

% Retrieve the logistic of z-score and set non-available values as zero
matrix = logistic_transformation(matrix,mismatch);

% Calculate group-wise SeroHet signature scores
[score,errhigh,errlow] = group_wise(matrix,groupID,group);

% Draw bar plots

for count = 1:1:size(group, 1)
    figure('Visible','off');
    barplot = bar(1:size(matrix,1),score(count,:));
    hold on
    
    er = errorbar(1:size(matrix,1),score(count,:),errlow(count,:),errhigh(count,:));
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    cmap = colormap(hsv(size(signature,1)));
    barplot.BaseValue = 0.5;
    barplot.FaceColor = 'flat';
    for signaturecount = 1:1:size(signature,1)
        barplot.CData(strcmp(signature(signaturecount,1),class(:,2)),:) = repmat(cmap(signaturecount,:),sum(strcmp(signature(signaturecount,1),class(:,2))),1);
    end
    
    ylabel('logistic(z)');
    xlabel('SeroHet signatures');
    ylim([0 1]);
    xlim([1-0.75 size(matrix,1)+0.75]);
    set(gca,'LineWidth',3,'XTick',[]);
    print_to_file([outdir char(group(count,1)) '.signatures.pdf'],1200);
    
    hold off
end