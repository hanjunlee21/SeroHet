% Usage :
%    SeroHet('path_matrix','path_seroprotein','path_groupID','outdir');
%    SeroHet(___,Name,Value);
%
% Arguments:
%    path_matrix - The path to .txt file containing the concentrations of each seroprotein
%    path_seroprotein - The path to .txt file containing the names of the seroprotein
%    path_groupID - The path to .txt file containing group IDs
%    outdir - An output directory where generated figures will be saved
%
% Optional Fields:
%    'Statistics' - Whether to draw volcano plot
%        'on' | 'off'
%
% Output Figures:
%    (groupID).SeroHet.signatures.pdf : This bar plot compares the SerHet signatures in the given group
%

function SeroHet(path_matrix,path_seroprotein,path_groupID,outdir,field1_name,field1_value)

% SeroHet software version 1.1
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.
version = '1.1';

% Determine necessary paths
install_path = regexprep(which('SeroHet'),'SeroHet\.m$','');
bin_path = [install_path 'bin/'];
addpath(bin_path);

% Check input arguments
if nargin<3
    disp('Usage: SeroHet(path_matrix,path_seroprotein,path_groupID,outdir)');
    disp('User must specify a path to each input file and output directory');
    return;
elseif nargin==3
    disp('No output directory specified... using:');
    outdir = [install_path 'figure/'];
    disp(outdir);
    statistics_value = 'off';
elseif nargin==4
    statistics_value = 'off';
elseif nargin==5
    disp('Usage: SeroHet(path_matrix,path_seroprotein,path_groupID,outdir)');
    disp('Usage: SeroHet(___, Name, Value)');
    disp('User must specify optional field name and value');
    return;
elseif nargin==6
    if ~strcmpi(field1_name, 'Statistics')&&~strcmpi(field1_name, 'Statistic')
        disp('Invalid optional field name');
        return;
    end
    if ~strcmpi(field1_value, 'on')&&~strcmpi(field1_value, 'off')&&~strcmpi(field1_value, 'true')&&~strcmpi(field1_value, 'false')&&~strcmpi(field1_value, 'T')&&~strcmpi(field1_value, 'F')
        disp('Invalid optional field value');
        return;
    elseif strcmpi(field1_value, 'on')||strcmpi(field1_value, 'true')||strcmpi(field1_value, 'T')
        statistics_value = 'on';
    elseif strcmpi(field1_value, 'off')||strcmpi(field1_value, 'false')||strcmpi(field1_value, 'F')
        statistics_value = 'off';
    end
end
if ~ischar(path_matrix)||~ischar(path_seroprotein)||~ischar(path_groupID)||~ischar(outdir)||~ischar(field1_name)||~ischar(field1_value)
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
cmap = colormap(hsv(size(signature,1)));
cmap_class = cmap_seroprotein(cmap,signature,class);
num_signature = count_signature(signature,class);

% Filter only SeroHet proteins
[matrix,mismatch] = filter_proteins(matrix,seroprotein,class);

% Mean-centered normalization based on reference data
matrix = mean_centered(matrix,groupID);

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

% Draw input-wide Spearman correlation coefficient heatmap
hmap = spearman_heatmap(matrix);
figure('Visible','off');
cmax = 0.5;
imagesc(hmap,[0 cmax]);
hold on
colormap bone
cbar = colorbar('southoutside','XTick',[0 cmax]);
cbar.Label.String = 'Spearman''s rho';
axis square;
line_width = 1.5;
line_offset = -0.5;
for count = 1:1:size(signature,1)
    if count == 1
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1),size(hmap,1)+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+0,sum(num_signature(1:(count),1))+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1),size(hmap,1)-sum(num_signature(1:(count),1))+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+0,0+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1)-sum(num_signature(1:(count),1)),size(hmap,1)-sum(num_signature(1:(count),1))+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+0,sum(num_signature(1:(count),1))+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1),size(hmap,1)-sum(num_signature(1:(count),1))+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+sum(num_signature(1:(count),1)),sum(num_signature(1:(count),1))+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
    else
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1)-sum(num_signature(1:(count-1),1)),size(hmap,1)-sum(num_signature(1:(count-1),1))+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+sum(num_signature(1:(count-1),1)),sum(num_signature(1:(count),1))+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1)-sum(num_signature(1:(count-1),1)),size(hmap,1)-sum(num_signature(1:(count),1))+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+sum(num_signature(1:(count-1),1)),sum(num_signature(1:(count-1),1))+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1)-sum(num_signature(1:(count),1)),size(hmap,1)-sum(num_signature(1:(count),1))+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+sum(num_signature(1:(count-1),1)),sum(num_signature(1:(count),1))+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
        line([size(hmap,1),size(hmap,1)]-[line_offset+size(hmap,1)-sum(num_signature(1:(count-1),1)),size(hmap,1)-sum(num_signature(1:(count),1))+line_offset],[size(hmap,1),size(hmap,1)]-[line_offset+sum(num_signature(1:(count),1)),sum(num_signature(1:(count),1))+line_offset],'Color',cmap(count,:),'LineWidth',line_width);
    end
end
set(gca,'LineWidth',3,'XTick',[],'YTick',[]);
print_to_file([outdir 'Input-wide.Spearman.pdf'],1200);
hold off

% Statistical anaylsis
alpha = 0.05/size(signature,1);
if strcmp(statistics_value,'on')
    combi = nchoosek(group,2);
    for count = 1:size(combi,1)
        log2FC = zeros(size(class,1),1);
        welch_p = ones(size(class,1),1);
        for countclass = 1:1:size(class,1)
            log2FC(countclass,1) = log(mean(matrix(countclass,strcmp(groupID,combi(count,2))).'))/log(2)-log(mean(matrix(countclass,strcmp(groupID,combi(count,1))).'))/log(2);
            [~,welch_p(countclass,1)] = ttest2(matrix(countclass,strcmp(groupID,combi(count,2))).',matrix(countclass,strcmp(groupID,combi(count,1))).','VarType','unequal');
        end
        scatter_size = 25;
        figure('Visible','off');
        scatter(log2FC,-log10(welch_p),scatter_size,cmap_class,'filled');
        hold on
        box on
        ylabel('-log10 p-value');
        xlabel('log2 fold change');
        if max(-log10(welch_p)) < 10
            ymax = 10;
        else
            ymax = 20;
        end
        ylim([0 ymax]);
        xlim([-1 1]);
        line([-1 1],[-log10(alpha) -log10(alpha)],'Color',[0.5 0.5 0.5],'LineWidth',line_width);
        set(gca,'LineWidth',3,'XTick',-1:1:1,'YTick',0:(ymax/2):ymax);
        print_to_file([outdir char(combi(count,1)) '.vs.' char(combi(count,2)) '.volcano.pdf'],1200);
        hold off
    end
end