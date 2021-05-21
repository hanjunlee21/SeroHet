----------README---------

SeroHet is a MATLAB-based software to study signatures of interpatient seroprotein heterogeneity in cancer patients.
SeroHet is developed and maintained by Hanjun Lee (MIT/MGH/Broad).
SeroHet requires three input files:
	a single tab-delimited .txt file containing the concentrations of each seroprotein (#seroproteins-by-#samples)
		unit should be identical to that in the library/SeroHet.v.1.0.txt
	a single .txt file containing the names of the seroprotein (#seroproteins-by-1)
		nomenclature should be identical to that in the library/SeroHet.v.1.0.txt
	a single .txt file containing the group IDs (#groups-by-1)
		non-cancer data should be labeled as "Healthy Control"

For detailed descriptions on SeroHet, please refer to:
Lee H, Kim SY, Kim DW, Park YS, Hwang JH, Cho S, and Cho JY.
SeroHet: Signatures of Interpatient Seroprotein Heterogeneity in Lung, Pancreatic, and Colorectal Cancers.
Forthcoming.

To run SeroHet, enter a MATLAB session and run the matlab function
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir');

path_matrix - The path to .txt file containing the concentrations of each seroprotein.
path_seroprotein - The path to .txt file containing the names of the seroprotein.
path_groupID - The path to .txt file containing group IDs.
outdir - An output directory where generated figures will be saved.

e.g. SeroHet('library/SeroHet.v.1.0.matrix.txt','library/SeroHet.v.1.0.seroprotein.txt','library/SeroHet.v.1.0.cancertype.txt','figure');

This package is supported in Windows, Mac, and Linux environments.
This package was developed using Matlab version 2019b.

----------v.1.1-alpha patch---------

Statistics optional field and input-wide Spearman correlation coefficient heatmap are added.

To run statistical analysis on SeroHet,
enter a MATLAB session and run the matlab function
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir', 'Statistics', 'on');

e.g. SeroHet('library/SeroHet.v.1.0.matrix.txt','library/SeroHet.v.1.0.seroprotein.txt','library/SeroHet.v.1.0.cancertype.txt','figure','Statistics','on');

----------v.1.2-alpha patch---------

ROC optional field is added. Input-wide Spearman correlation coefficient heatmap has been deprecated.

To run ROC analysis on SeroHet,
enter a MATLAB session and run the matlab function
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir', 'ROC', 'on');

e.g. SeroHet('library/SeroHet.v.1.0.matrix.txt','library/SeroHet.v.1.0.seroprotein.txt','library/SeroHet.v.1.0.cancertype.txt','figure','ROC','on');

----------v.1.2-beta patch---------

Metadata optional field is added.

To run Metadata analysis on SeroHet,
enter a MATLAB session and run the matlab function
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir', 'Metadata', 'path_metadata');

e.g. SeroHet('library/SeroHet.v.1.0.matrix.txt','library/SeroHet.v.1.0.seroprotein.txt','library/SeroHet.v.1.0.cancertype.txt','figure','Metadata','library/SeroHet.v.1.0.metadata.txt');
