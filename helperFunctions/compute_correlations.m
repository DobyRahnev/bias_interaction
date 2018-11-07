function [r,p] = compute_correlations(crit, bias_shift, expt_filter)

% Compute correlations across all 3 experiments
[r(4),p(4)] = corr(crit, bias_shift);
%[r(4,2),~,p(4,2)] = spear(crit, bias_shift);

% Compute correlations for each expt separately
for expt=1:3
    [r(expt),p(expt)] = corr(crit(expt_filter==expt), bias_shift(expt_filter==expt));
    %[r(expt,2),~,p(expt,2)] = spear(crit(expt_filter==expt), bias_shift(expt_filter==expt));
end