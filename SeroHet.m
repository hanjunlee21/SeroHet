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
%    'ROC' - Whether to draw ROC curves
%        'on' | 'off'
%    'Metadata' - Whether to analyze relationship between SeroHet signatures and metadata
%        'path_metadata'
%
%

function SeroHet(path_matrix,path_seroprotein,path_groupID,outdir,field1_name,field1_value)

% SeroHet software version 1.2
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.
version = '1.2';

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
    roc_value = 'off';
    metadata_value = 'off';
    if ~ischar(path_matrix)||~ischar(path_seroprotein)||~ischar(path_groupID)
        error('Inputs must be character arrays');
    end
elseif nargin==4
    statistics_value = 'off';
    roc_value = 'off';
    metadata_value = 'off';
    if ~ischar(path_matrix)||~ischar(path_seroprotein)||~ischar(path_groupID)||~ischar(outdir)
        error('Inputs must be character arrays');
    end
elseif nargin==5
    disp('Usage: SeroHet(path_matrix,path_seroprotein,path_groupID,outdir)');
    disp('Usage: SeroHet(___, Name, Value)');
    disp('User must specify optional field name and value');
    return;
elseif nargin==6
    if ~strcmpi(field1_name, 'Statistics')&&~strcmpi(field1_name, 'Statistic')&&~strcmpi(field1_name, 'ROC')&&~strcmpi(field1_name, 'Metadata')
        disp('Invalid optional field name');
        return;
    end
    if ~strcmpi(field1_value, 'on')&&~strcmpi(field1_value, 'off')&&~strcmpi(field1_value, 'true')&&~strcmpi(field1_value, 'false')&&~strcmpi(field1_value, 'T')&&~strcmpi(field1_value, 'F')&&~strcmpi(field1_name, 'Metadata')
        disp('Invalid optional field value');
        return;
    elseif strcmpi(field1_value, 'on')||strcmpi(field1_value, 'true')||strcmpi(field1_value, 'T')
        if strcmpi(field1_name, 'Statistics')||strcmpi(field1_name, 'Statistic')
            statistics_value = 'on';
            roc_value = 'off';
            metadata_value = 'off';
        elseif strcmpi(field1_name, 'ROC')
            roc_value = 'on';
            statistics_value = 'off';
            metadata_value = 'off';
        end
    elseif strcmpi(field1_value, 'off')||strcmpi(field1_value, 'false')||strcmpi(field1_value, 'F')
        if strcmpi(field1_name, 'Statistics')||strcmpi(field1_name, 'Statistic')
            statistics_value = 'off';
            roc_value = 'off';
            metadata_value = 'off';
        elseif strcmpi(field1_name, 'ROC')
            roc_value = 'off';
            statistics_value = 'off';
            metadata_value = 'off';
        end
    elseif strcmpi(field1_name, 'Metadata')
        statistics_value = 'off';
        roc_value = 'off';
        metadata_value = 'on';
        path_metadata = field1_value;
    end
    if ~ischar(path_matrix)||~ischar(path_seroprotein)||~ischar(path_groupID)||~ischar(outdir)||~ischar(field1_name)||~ischar(field1_value)
        error('Inputs must be character arrays');
    end
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
spearman_matrix = matrix;
group = unique(groupID);

% Read classification
class = read_classification(install_path,version);
signature = unique(class(:,2));
signature = sort_signature(signature);
cmap = colormap([0.545098039215686,0.0235294117647059,0.0156862745098039;0.564705882352941,0.341176470588235,0.00392156862745098;0.478431372549020,0.498039215686275,0.0705882352941177;0.223529411764706,0.443137254901961,0.141176470588235;0.133333333333333,0.466666666666667,0.341176470588235;0.247058823529412,0.419607843137255,0.525490196078431;0.117647058823529,0.227450980392157,0.419607843137255;0.203921568627451,0.160784313725490,0.380392156862745;0.450980392156863,0.219607843137255,0.470588235294118;0.623529411764706,0.0509803921568627,0.376470588235294]);
cmap_class = cmap_seroprotein(cmap,signature,class);
num_signature = count_signature(signature,class);

% Filter only SeroHet proteins
[matrix,mismatch] = filter_proteins(matrix,seroprotein,class);

% Mean-centered normalization based on reference data
matrix = mean_centered(matrix,groupID);
roc_matrix = matrix;
spearman_matrix = mean_centered(spearman_matrix,groupID);

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

% Classify novel seroproteins into SeroHet signatures
hmap = spearman_heatmap(spearman_matrix);
novel_seroprotein = [];
line_width = 1.5;
for count = 1:1:size(spearman_matrix,1)
    if sum(strcmp(seroprotein(count,1), class(:,1))) == 0
        spearman_vector = [];
        signature_vector = [];
        for spearmancount = 1:1:size(spearman_matrix,1)
            if sum(strcmp(seroprotein(spearmancount,1), class(:,1))) > 0
                spearman_vector = [spearman_vector; hmap(count, spearmancount)];
                signature_vector = [signature_vector; class(strcmp(seroprotein(spearmancount,1), class(:,1)),2)];
            end
        end
        [~,idx] = max(spearman_vector);
        novel_seroprotein = [novel_seroprotein; [seroprotein(count,1), signature_vector(idx,1)]];
    end
end
if size(novel_seroprotein,1) > 0
    writematrix(novel_seroprotein, [outdir 'novel.seroprotein.signature.txt'], 'Delimiter', '\t', 'FileType', 'text');
    disp(['Outputting figure to ' outdir 'novel.seroprotein.signature.txt']);
end

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

% ROC curve
if strcmp(roc_value,'on')
    fold = 10;
    maxiter = 1000;
    if sum(strcmp(group, "Healthy Control")) == 0
        error('Healthy Control is either mislabelled or absent');
    end
    for signaturecount = 1:1:size(signature)
        alpha = 0.05/sum(strcmp(class(:,2),signature(signaturecount,1)));
        for groupcount = 1:1:size(group)
            if ~strcmp(group(groupcount,1),"Healthy Control")
                matrix_include = (roc_matrix(strcmp(class(:,2),signature(signaturecount,1)),strcmp(group(groupcount,1),groupID)|strcmp("Healthy Control",groupID))).';
                group_include = groupID(strcmp(group(groupcount,1),groupID)|strcmp("Healthy Control",groupID),1);
                matrix_exclude = (roc_matrix(strcmp(class(:,2),signature(signaturecount,1)),~strcmp(group(groupcount,1),groupID)&~strcmp("Healthy Control",groupID))).';
                group_exclude = groupID(~strcmp(group(groupcount,1),groupID)&~strcmp("Healthy Control",groupID),1);
                fold_include = fold*size(matrix_include,1)/(size(matrix_include,1)+size(matrix_exclude,1));
                roc_vector = [];
                for iter = 1:1:maxiter
                    trainingidx = [randperm(sum(strcmp(groupID, "Healthy Control")),round(sum(strcmp(groupID, "Healthy Control"))*fold_include/(fold_include+1))),(randperm(sum(strcmp(groupID, group(groupcount,1))),round(sum(strcmp(groupID, group(groupcount,1)))*fold_include/(fold_include+1)))+sum(strcmp(groupID, "Healthy Control"))-1)];
                    validationidx = ~ismember(1:sum(strcmp(groupID, "Healthy Control")|strcmp(groupID, group(groupcount,1))),trainingidx);
                    trainingmatrix = [matrix_include(trainingidx,:);matrix_exclude];
                    traininggroup = [group_include(trainingidx,1);group_exclude];
                    validationmatrix = matrix_include(validationidx,:);
                    validationgroup = group_include(validationidx,1);
                    
                    mdl = fitglm(trainingmatrix, ~strcmp(traininggroup, "Healthy Control"), 'Distribution', 'binomial', 'Link', 'logit');
                    prediction = [predict(mdl, validationmatrix),~strcmp(validationgroup, "Healthy Control")];
                    roc_vector = [roc_vector; prediction];
                end
                writematrix(roc_vector, [outdir 'Healthy Control vs ' char(group(groupcount,1)) '.' char(signature(signaturecount,1)) '.ROC.txt'], 'Delimiter', '\t', 'FileType', 'text');
                disp(['Outputting figure to ' outdir 'Healthy Control vs ' char(group(groupcount,1)) '.' char(signature(signaturecount,1)) '.ROC.txt']);
            end
        end
        mdl = fitglm([matrix_include;matrix_exclude], ~strcmp([group_include;group_exclude], "Healthy Control"), 'Distribution', 'binomial', 'Link', 'logit');
        p_value = mdl.Coefficients.pValue;
        p_value = p_value(2:end,1);
        log2cDOR = mdl.Coefficients.Estimate/log(2);
        log2cDOR = log2cDOR(2:end,1);
        scatter_size = 25;
        figure('Visible','off');
        scatter(log2cDOR,-log10(p_value),scatter_size,cmap(signaturecount,:),'filled');
        hold on
        box on
        ylabel('-log10 p-value');
        xlabel('log2 conditional DOR');
        xmax = round(max(abs(log2cDOR)) * 1.5)+1;
        ymax = round(max(-log10(p_value)) * 1.5)+1;
        ylim([0 ymax]);
        xlim([-xmax xmax]);
        line([-xmax xmax],[-log10(alpha) -log10(alpha)],'Color',[0.5 0.5 0.5],'LineWidth',line_width);
        set(gca,'LineWidth',3,'XTick',-xmax:xmax:xmax,'YTick',0:(ymax/2):ymax);
        print_to_file([outdir 'Healthy Control vs Cancer.' char(signature(signaturecount,1)) '.volcano.pdf'],1200);
        hold off
    end
end

% Metdata analysis
if strcmp(metadata_value,'on')
    path_metadata = full_path(path_metadata, install_path);
    metadata = read_metadata(path_metadata);
    if size(metadata,1) ~= size(matrix.',1)
        error('Number of rows in the metadata does not match sample number');
    else
        metadata_group1 = cell(1,size(metadata,2));
        metadata_group2 = cell(1,size(metadata,2));
        metadata_log2FC = [];
        metadata_welch_p = [];
        for count = 1:1:size(metadata,2)
            metadata_group = unique(metadata(:,count));
            metadata_char_determinant = char(metadata_group(2,1));
            if strcmpi(metadata_char_determinant,'Lean')||strcmpi(metadata_char_determinant,'Female')||strcmpi(metadata_char_determinant(1),'N')
                metadata_group = metadata_group(end:-1:1,1);
            end
            metadata_group1(1,count) = {char(metadata_group(1,1))};
            metadata_group2(1,count) = {char(metadata_group(2,1))};
            log2FC = zeros(1,size(signature,1));
            welch_p = zeros(1,size(signature,1));
            for signaturecount = 1:1:size(signature,1)
                log2FC(1,signaturecount) = log(mean(mean(matrix(strcmp(class(:,2),signature(signaturecount,1)),strcmp(metadata(:,count),metadata_group(2,1))).').'))/log(2)-log(mean(mean(matrix(strcmp(class(:,2),signature(signaturecount,1)),strcmp(metadata(:,count),metadata_group(1,1))).').'))/log(2);
                [~,welch_p(1,signaturecount)] = ttest2(mean(matrix(strcmp(class(:,2),signature(signaturecount,1)),strcmp(metadata(:,count),metadata_group(2,1))).'),mean(matrix(strcmp(class(:,2),signature(signaturecount,1)),strcmp(metadata(:,count),metadata_group(1,1))).'),'VarType','unequal');
            end
            metadata_log2FC = [metadata_log2FC; log2FC];
            metadata_welch_p = [metadata_welch_p; welch_p];
        end
        
        scatter_size = 75;
        figure('Visible','off');
        for count = 1:1:size(metadata,2)
            if count == 1
                scatter(metadata_log2FC(count,:).',repmat(1+size(metadata,2)-count,size(signature,1),1),scatter_size,cmap,'filled');
                line([-1 1],[1+size(metadata,2)-count 1+size(metadata,2)-count],'Color',[0.5 0.5 0.5],'LineWidth',line_width);
                hold on
            else
                scatter(metadata_log2FC(count,:).',repmat(1+size(metadata,2)-count,size(signature,1),1),scatter_size,cmap,'filled');
                line([-1 1],[1+size(metadata,2)-count 1+size(metadata,2)-count],'Color',[0.5 0.5 0.5],'LineWidth',line_width);
            end
        end
        box on
        ymax = size(metadata,2)+1;
        xlim([-1 1]);
        xlabel('log2 fold change');
        yyaxis left
        ylim([0 ymax]);
        yticks(1:1:size(metadata,2));
        yticklabels(metadata_group1(1,end:-1:1));
        yyaxis right
        ylim([0 ymax]);
        yticks(1:1:size(metadata,2));
        yticklabels(metadata_group2(1,end:-1:1));
        set(gca,'LineWidth',3,'XTick',-1:1:1,'ycolor','w');
        print_to_file([outdir 'Metadata.log2FC.pdf'],1200);
        hold off
        
        description = ["Column1","Column2"];
        description = [description,signature.'];
        below_description = [string(metadata_group1).',string(metadata_group2).'];
        for signaturecount = 1:1:size(signature,1)
            below_description = [below_description,num2str(-log10(metadata_welch_p(:,signaturecount)))];
        end
        writematrix([description;below_description],[outdir 'Metadata.-log10P.txt'],'FileType','text','Delimiter','\t');
        disp(['Outputting figure to ' outdir 'Metadata.-log10P.txt']);
    end
end
