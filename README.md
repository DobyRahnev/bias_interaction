Data and code for paper titled "Predictive cues reduce but do not eliminate intrinsic response bias" by Hu & Rahnev.

Both data and code are in MATLAB (tested on version 2018b). Here is a guideline to the files/folders:
- analysis.m: analysis file that reproduces all statistical tests and figures from paper
- data_exptX.mat: the raw data for Experiment X (X=1,2,3)
- helperFunctions: useful functions that are called by the analysis files above
- fit_mixture_strategy.m & fit_mixture_strategy2.m: codes to fit mixture strategies to data and perform comparisons to the empirical data
- fittingResults.mat & fittingResults2.mat: results of the fitting; can be loaded instead of refitting the models each time
- dprime_criterion.mat: d' and c values used for the fitting

If using these codes, please cite the paper.
