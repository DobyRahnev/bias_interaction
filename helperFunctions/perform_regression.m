function [beta,F,p,DFE] = perform_regression(Y, X, expt_filter)

%--------------------------------------------------------------------------
% Performs regression analyses (Y = a + b*X) on 3 datasets. expt_filter
% describes which data comes from which dataset. It outputs beta values, as
% well as F, p, and DFE (degrees of freedom). Four outputs values are 
% outputed: the values for Expt 1, Expt 2, Expt 3, and all experiments
% combined. DFE has two rows: the first lists the numerator degrees of
% freedom, the second lists the denominator degrees of freedom.
%
% Written by Doby Rahnev, last updated: 12/7/2018
%--------------------------------------------------------------------------

% Perform regression across all 3 datasets
beta(4,:) = regress(Y, [ones(length(X),1), X]);

% Compute p values for the beta coefficient when comparing with 0 and 1
tbl = table(Y,X,'VariableNames',{'Y','X'});
lm = fitlm(tbl,'Y~X');
[p(1,4),F(1,4), DFE(1,4)] = coefTest(lm,[0,1],0); %Compare with 0
[p(2,4),F(2,4)] = coefTest(lm,[0,1],1); %Compare with 1
DFE(2,4) = lm.DFE; %Denominator degrees of freedom

% Perform correlation and regression for each expt separately
for exp=1:3
    beta(exp,:) = regress(Y(expt_filter==exp), ...
        [ones(sum(expt_filter==exp),1), X(expt_filter==exp)]);
    tbl = table(Y(expt_filter==exp),X(expt_filter==exp),'VariableNames',{'Y','X'});
    lm = fitlm(tbl,'Y~X');
    [p(1,exp),F(1,exp), DFE(1,exp)] = coefTest(lm,[0,1],0); %Compare with 0
    [p(2,exp),F(2,exp)] = coefTest(lm,[0,1],1); %Compare with 1
    DFE(2,exp) = lm.DFE; %Denominator degrees of freedom
end

% Only pass relevant beta values as output
beta = beta(:,2)';