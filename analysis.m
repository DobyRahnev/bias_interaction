%-------------------------------------------------------------------------
% Analysis file for Hu & Rahnev (submitted) "Integrating predictive cues 
% with intrinsic response bias."
%
% Raw data from each experiment is in data_exptX.mat (X=1,2,3). These files
% contain the following variables:
%   - stim: stimulus identity (1: left, 2: right)
%   - resp: subject response (1: left, 2: right)
%   - cue: type of cue (1: right, 2: neutral, 3: right)
%
% Written by Doby Rahnev, last updated: 11/7/2018
%-------------------------------------------------------------------------

clc
close all
clear

% Add helper functions and define useful variables
addpath(genpath(fullfile(pwd, 'helperFunctions')));
sub = 0;
expt_filter = [];

% Load all data
for expt=1:3
    
    % Load data and update expt_filter
    load(['data_expt' num2str(expt)]);
    expt_filter = [expt_filter, expt*ones(1,length(data))];
    
    % Loop over all subjects and compute d' and c for each cue type
    for subject=1:length(data)
        sub = sub + 1;
        for cueType=1:3 %1: right, 2: neutral, 3: left
            prob_RNL(sub,cueType) = sum(data{subject}.resp(data{subject}.cue==cueType)==1) / ...
                sum(data{subject}.cue==cueType);
            [dprime_RNL(sub,cueType), c_RNL(sub,cueType)] = data_analysis_resp(...
                data{subject}.stim(data{subject}.cue==cueType), ...
                data{subject}.resp(data{subject}.cue==cueType));
        end
    end
end

%% CONTROL ANALYSES: Remove outlier from Exp 1 (to run, uncomment 2 lines below)
% dprime_RNL = dprime_RNL([1:4,6:size(dprime_RNL,1)],:); c_RNL = c_RNL([1:4,6:size(c_RNL,1)],:);
% prob_RNL = prob_RNL([1:4,6:size(prob_RNL,1)],:); expt_filter = expt_filter([1:4,6:length(expt_filter)]);


%% Compute bias shift asymmetry, that is (c_N-c_R)-(c_L-c_N)
bias_shift = (c_RNL(:,2)-c_RNL(:,1)) - (c_RNL(:,3)-c_RNL(:,2));
prob_shift = (prob_RNL(:,2)-prob_RNL(:,1)) - (prob_RNL(:,3)-prob_RNL(:,2));


%% Binomial tests
for exp=1:3
    num_same_sign(exp) = sum(sign(c_RNL(expt_filter==exp,2))==sign(bias_shift(expt_filter==exp)));
    num_total(exp) = sum(expt_filter==exp);
    p_binomial(exp) = binomTest(num_same_sign(exp), num_total(exp), .5, 'two');
end
num_same_sign(4) = sum(num_same_sign);
num_total(4) = sum(num_total);
p_binomial(4) = binomTest(num_same_sign(4), num_total(4), .5, 'two');
binomial_test_results = [num_same_sign; num_total; num_same_sign./num_total; p_binomial]


%% Figure 3: Plot SDT graphs for 6 subjects
figure;
subjects_to_plot = [3,25,41,37,64,67]; %only correct outside of control analyses
for sub_num=1:6
    plotSDT3criteria(mean(dprime_RNL(subjects_to_plot(sub_num),:)), c_RNL(subjects_to_plot(sub_num),:), sub_num);
end


%% Figures 4 and 5: Compute and plot correlations for each expt
% Compute and display the correlations
[r_SDT,p_SDT] = compute_correlations(c_RNL(:,2), bias_shift, expt_filter)
[r_prob,p_prob] = compute_correlations(prob_RNL(:,2), bias_shift, expt_filter)

% Plot bias shift vs. neutral criterion
plotScatter(c_RNL(:,2), bias_shift, expt_filter, [-.8, 1.2], ...
    'Intrinsic bias, c_{neutral}', 'Asymmetry in bias shift, \Delta_{shift}', subjects_to_plot)
plotScatter(prob_RNL(:,2), prob_shift, expt_filter, [.2, .8], ...
    'Intrinsic bias, P_{neutral}(left)', 'Asymmetry in bias shift, \Delta_{P(left) shift}')


%% Discussion result: Correlation between c_neutral and c_right+c_left
sum_c_right_c_left = c_RNL(:,1) + c_RNL(:,3);
[r_sum2c,p_sum2c] = compute_correlations(c_RNL(:,2), sum_c_right_c_left, expt_filter)