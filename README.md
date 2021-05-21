# SeroHet
Lee H, Kim SY, Kim DW, Park YS, Hwang JH, Cho S, and Cho JY. SeroHet: Signatures of Interpatient Seroprotein Heterogeneity in Lung, Pancreatic, and Colorectal Cancers. _Forthcoming._
<br/>

## Overview
SeroHet is a MATLAB-based software to study signatures of interpatient seroprotein heterogeneity in cancer patients.
SeroHet is developed and maintained by Hanjun Lee (MIT/MGH/Broad). SeroHet signatures are also available from [here](https://hanjun.group/wp-content/uploads/2021/05/SeroHet.v.1.0.txt).
<br/>

## Installation
SeroHet is implemented in MATLAB. MATLAB version equal to or greater than R2019b is recommended. SeroHet has been tested in Windows, Mac, and Linux environments.
Download and decompress the latest stable release of SeroHet to your directory of choice. The current stable release of SeroHet is [v.1.2-alpha](https://github.com/hanjunlee21/SeroHet/releases/tag/v.1.2-alpha).

Alternatively, if you have git functionality in your system, you can run the following:
```git
git https://github.com/hanjunlee21/SeroHet.git
```
<br/>

## Input
SeroHet requires a matrix of seroprotein concentrations. The nomenclature and the unit for seroproteins should follow that of the [library](https://hanjun.group/wp-content/uploads/2021/05/SeroHet.v.1.0.txt). Novel seroprotein may follow the nomenclature and unit of your preference. Data from individuals without cancer should be labeled as "Healthy Control".

SeroHet requires three input files:
* a single tab-delimited .txt file containing the concentrations of each seroprotein (#seroproteins-by-#samples)
* a single .txt file containing the names of the seroprotein (#seroproteins-by-1)
* a single .txt file containing the group IDs (#groups-by-1)
<br/>

## Run
Enter a MATLAB session in that specific directory and run the following MATLAB function:

```matlab
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir');
```

By default, SeroHet normalizes the concentration input based on the original SeroHet cohort. This cohort is based on 584 individuals with or without lung, pancreatic, or colorectal cancers. For normalization, only the seroprotein concentration profile of cancer patients are utilized.
<br/>

### Statistics
Optionally, if you want to perform statistical analysis on your grouped samples, you can utilize the Statistics functionality of SeroHet. By default, the software will create volcano plots based on Welch's t-test and display the signature-wise Bonferroni-corrected threshold for p-values. To perform this optional statistical analysis, run the following MATLAB function:

```matlab
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir','Statistics','on');
```

<br/>

### ROC
Alternatively, if you have individuals without cancer in your cohort, you can utilize ROC functionality of SeroHet to measure signature-wise ROC curves in your cohort. By default, the software performs 1,000 iterations of 10-fold cross-validation. The aggregate data will be saved as a text file. The software will also create volcano plots for each signature based on the conditional diagnostic odds ratio and its cognate p-values calculated by Student's t-test. Of note, ROC fields is currently incompatible with Statistics functionality of SeroHet.

```matlab
SeroHet('path_matrix','path_seroprotein','path_groupID','outdir','ROC','on');
```
<br/>

## Output
SeroHet produces multiple plots and files as output.
<br/>

### `novel.seroprotein.signature.txt`
A text file containing SeroHet signature classifications for novel seroproteins
* column 1: seroprotein ID
* column 2: SeroHet signature
<br/>

### `GroupID.signatures.pdf`
A bar plot of logistic(z-score) of each group
* each signature is color-coded and is presented in an order specified [here](https://hanjun.group/wp-content/uploads/2021/05/SeroHet.v.1.0.txt)

<img src="https://user-images.githubusercontent.com/67846757/119079876-08129c80-b9c7-11eb-98c7-4662d0f578de.jpg" width="500">

**Figure 1. logistic z-scores of each seroprotein in the initial SeroHet cohort**

<br/>

### `GroupID1.GroupID2.volcano.pdf`
A volcano plot between two groups
* x-axis: log2 fold change (log2(GroupID2/GroupID1))
* y-axis: -log10 p-value (Welch's t-test)
* each signature is color-coded
* signature-wise Bonferroni-corrected threshold for p-value is presented as a horizontal line

<img src="https://user-images.githubusercontent.com/67846757/119079953-31332d00-b9c7-11eb-9730-9b5a2f9a67d5.jpg" width="500">

**Figure 2. volcano plot showing the alteractions in the expression profiles of each signature between individuals without cancer and AJCC stage I cancer patients in the initial SeroHet cohort**

<br/>

### `Healthy Control vs Cancer.Signature ID.volcano.pdf`
A volcano plot for conditional diagnostic odds ratio in ROC
* only generated when ROC field is turned on
* x-axis: log2 conditional DOR
* y-axis: -log10 p-value (Student's t-test)
* each signature is color-coded
* seroprotein-wise Bonferroni-corrected threshold for p-value is presented as a horizontal line

<img src="https://user-images.githubusercontent.com/67846757/119080850-d1d61c80-b9c8-11eb-847b-d214db4873b9.jpg" width="500">

**Figure 3. volcano plot showing the conditional diagnostic odds ratio of seroproteins from SeroHet signature 3 in the initial SeroHet cohort**

<br/>

### `Healthy Control vs GroupID.Signature ID.ROC.txt`
A text file containing prediction values and state values required for ROC construction
* column 1: prediction values (logistic regression, range: 0–1)
* column 2: state values (0: Healthy Control, 1: Cancer)
<br/>
