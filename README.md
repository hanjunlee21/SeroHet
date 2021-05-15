# SeroHet
Lee H, Kim SY, Kim DW, Park YS, Hwang JH, Cho S, and Cho JY. SeroHet: Signatures of Interpatient Seroprotein Heterogeneity in Lung, Pancreatic, and Colorectal Cancers. _Forthcoming._
## Overview
SeroHet is a MATLAB-based software to study signatures of interpatient seroprotein heterogeneity in cancer patients.
SeroHet is developed and maintained by Hanjun Lee (MIT/MGH/Broad). SeroHet signatures are also available from [here](https://hanjun.group/wp-content/uploads/2021/05/SeroHet.v.1.0.txt). 
## Installation
SeroHet is implemented in MATLAB. MATLAB version equal to or greater than R2019b is recommended. SeroHet has been tested in Windows, Mac, and Linux environments.
Download and decompress the latest stable release of SeroHet to your directory of choice. The current stable release of SeroHet is [v.1.1-alpha](https://github.com/hanjunlee21/SeroHet/releases/tag/v.1.1-alpha).

Alternatively, if you have git functionality in your system, you can run the following:
```git
git https://github.com/hanjunlee21/SeroHet.git
```

## Input
SeroHet requires a matrix of seroprotein concentrations. The nomenclature and the unit for should follow that of the [library](https://hanjun.group/wp-content/uploads/2021/05/SeroHet.v.1.0.txt). Data from individuals without cancer should be labeled as "Healthy Control".

SeroHet requires three input files:
* a single tab-delimited .txt file containing the concentrations of each seroprotein (#seroproteins-by-#samples)
* a single .txt file containing the names of the seroprotein (#seroproteins-by-1)
* a single .txt file containing the group IDs (#groups-by-1)

## Run
Enter a MATLAB session in that specific directory and run the following MATLAB function:

```matlab
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir');
```

By default, SeroHet normalizes the concentration input based on the original SeroHet cohort. This cohort is based on 584 individuals with or without lung, pancreatic, or colorectal cancers. For normalization, only the seroprotein concentration profile of cancer patients are utilized.

Optionally, if you want to perform statistical analysis on your grouped samples, you can utilize the Statistics functionality of SeroHet. By default, the software will create volcano plots based on Welch's t-test and the signature-wise Bonferroni-corrected threshold for p-values will be presented. To perform this optional statistical analysis, run the following MATLAB function:

```matlab
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir','Statistics','on');
```

## Output
SeroHet produces multiple plots as output.
### `Input-wide.Spearman.pdf`
A heatmap of Spearman's rho between identical and different seroproteins
* Each signature is color-coded and represented as a box

<img src="https://user-images.githubusercontent.com/67846757/118358363-6ca7a480-b54c-11eb-9523-d6fc834dbe3f.jpg" width="500">

### `GroupID.signatures.pdf`
A bar plot of logistic(z-score) of each group
* Each signature is color-coded and is presented in a numerical order

<img src="https://user-images.githubusercontent.com/67846757/118358446-c8722d80-b54c-11eb-9d11-ac0dad6cbf06.jpg" width="500">

### `GroupID1.GroupID2.volcano.pdf`
A volcano plot between two groups
* x-axis: log2 fold change (log2(GroupID2/GroupID1))
* y-axis: -log10 p-value (Welch's t-test)
* Each signature is color-coded
* Signature-wise Bonferroni-corrected threshold for p-value is presented as a horizontal line

<img src="https://user-images.githubusercontent.com/67846757/118358498-125b1380-b54d-11eb-8fb1-35cea50afc59.jpg" width="500">
