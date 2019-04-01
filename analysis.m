%-------------------------------------------------------------------------
% Analysis file for Hu & Rahnev (submitted) "Predictive cues reduce but do
% not eliminate intrinsic response bias."
%
% Raw data from each experiment is in data_exptX.mat (X=1,2,3). These files
% contain the following variables:
%   - stim: stimulus identity (1: Cat1, 2: Cat2)
%   - resp: subject response (1: Cat1, 2: Cat2)
%   - cue: type of cue (1: Cat1, 2: Cat2, 3: Neutral)
%
% Written by Doby Rahnev, last updated: 4/1/2019
%-------------------------------------------------------------------------

clc
close all
clear

% Add helper functions and define useful variables
addpath(genpath(fullfile(pwd, 'helperFunctions')));
sub = 0;
sub_signNeutr = 0;
expt_filter = [];
analyze_only_pre_post_cues_in_expt1 = 0;
cue_to_consider_in_expt1 = 1; %1:pre, 2:post

% Load all data
for expt=1:3
    
    % Load data and update expt_filter
    load(['data_expt' num2str(expt)]);
    expt_filter = [expt_filter, expt*ones(1,length(data))];
    
    % Decide whether to analyze only pre or post cues in Expt 1 (all
    % analyses reported in paper combine these cues)
    if analyze_only_pre_post_cues_in_expt1==1 && expt==1
        for subject=1:30
            data{subject}.stim = data{subject}.stim(data{subject}.cue_order==cue_to_consider_in_expt1);
            data{subject}.resp = data{subject}.resp(data{subject}.cue_order==cue_to_consider_in_expt1);
            data{subject}.cue = data{subject}.cue(data{subject}.cue_order==cue_to_consider_in_expt1);
        end
    end
    
    % Loop over all subjects and compute d' and c for each cue type, as
    % well as do within-subject analyses
    for subject=1:length(data)
        sub = sub + 1;
        for cueType=1:3 %1: Cat 1, 2: Cat 2, 3: Neutral
            prob_12N(sub,cueType) = sum(data{subject}.resp(data{subject}.cue==cueType)==1) / ...
                sum(data{subject}.cue==cueType);
            [dprime_12N(sub,cueType), c_12N(sub,cueType)] = data_analysis_resp(...
                data{subject}.stim(data{subject}.cue==cueType), ...
                data{subject}.resp(data{subject}.cue==cueType));
        end
        
        % Within-subject Binomial tests on predictive cues
        number_cat1Resp_predCues = sum(data{subject}.resp(data{subject}.cue<=2)==1);
        number_predCues = sum(data{subject}.cue<=2);
        p_cmpr_neutralBias(sub)=binomTest(number_cat1Resp_predCues,number_predCues,prob_12N(sub,3),'two');
        p_cmpr_noBias(sub)=binomTest(number_cat1Resp_predCues,number_predCues,.5,'two');
    end
end

%% Compute predictive cues midpoint
c_pred_mid = mean(c_12N(:,1:2),2);
prob_pred_mid = mean(prob_12N(:,1:2),2);


%% Figure 3: Plot SDT graphs for 2 subjects
figure;
subjects_to_plot = [3,25];
for sub_num=1:2
    plotSDT3criteria(mean(dprime_12N(subjects_to_plot(sub_num),:)), c_12N(subjects_to_plot(sub_num),:), sub_num);
end


%% Binomial tests
% SDT
disp('Binomial test: SDT')
bin(1) = sum(sign(c_12N(:,3))~=sign(c_pred_mid)); %number of Ss with c_PredMid on the opposite side of c_neutral
bin(2) = sum(sign(c_12N(:,3)-c_pred_mid)==sign(c_12N(:,3)))-bin(1); %number of Ss with c_PredMid in-between 0 and c_neutral
bin(3) = sum(sign(c_12N(:,3)-c_pred_mid)~=sign(c_12N(:,3))); %number of Ss with c_PredMid beyond c_neutral
p_binom_SDT(1) = binomTest(sum(bin(2:3)), sum(bin), .5, 'two'); %test whether c_PredMid is centered around 0
p_binom_SDT(2) = binomTest(sum(bin(1:2)), sum(bin), .5, 'two'); %test whether c_PredMid is centered around c_neutral
num_sub_per_bin = bin
percent_sub_per_bin = 100*bin/sum(bin)
p_binom_SDT
%
% Simple bias
disp('Binomial test: probability')
bin(1) = sum(sign(prob_12N(:,3)-.5)~=sign(prob_pred_mid-.5)); %number of Ss with P_PredMid on the opposite side of P_neutral
bin(2) = sum(sign(prob_12N(:,3)-prob_pred_mid)==sign(prob_12N(:,3)-.5))-bin(1); %number of Ss with P_PredMid in-between 0.5 and P_neutral
bin(3) = sum(sign(prob_12N(:,3)-prob_pred_mid)~=sign(prob_12N(:,3)-.5)); %number of Ss with P_PredMid beyond c_neutral
p_binom_prob(1) = binomTest(sum(bin(2:3)), sum(bin), .5, 'two'); %test whether P_PredMid is centered around 0.5
p_binom_prob(2) = binomTest(sum(bin(1:2)), sum(bin), .5, 'two'); %test whether P_PredMid is centered around P_neutral
num_sub_per_bin = bin
percent_sub_per_bin = 100*bin/sum(bin)
p_binom_prob


%% Figure 4: SDT analyses
% Plot predictive midpoint criterion vs. neutral criterion
plotScatter(c_pred_mid, c_12N(:,3), expt_filter, [-.8, 1.2], ...
    'Intrinsic bias, c_{neutral}', 'Predictive criteria midpoint, c_{PredMid}', 0);

% Perform linear regression and compare obtained beta value with 0 and 1
disp('Regression results: SDT')
[b_SDT,F_SDT,p_SDT,dfe_SDT] = perform_regression(c_pred_mid, c_12N(:,3), expt_filter)


%% Figure 5: Simple bias analyses
% Plot predictive midpoint bias vs. neutral bias
plotScatter(prob_pred_mid, prob_12N(:,3), expt_filter, [.25, .75], ...
    'Intrinsic bias, P_{neutral}(resp=Cat1)', 'Predictive bias midpoint, P_{PredMid}(resp=Cat1)', .5);

% Perform linear regression and compare obtained beta value with 0 and 1
disp('Regression results: probability')
[b_prob,F_prob,p_prob,dfe_prob] = perform_regression(prob_pred_mid, prob_12N(:,3), expt_filter)


%% Aggregating within-subject Binomial test results
percent_significant_bias = 100*sum(p_cmpr_noBias<.05)/sub
p_cmpr_to_5pct = binomTest(sum(p_cmpr_noBias<.05),sub,.05,'two')

percent_bias_diff_from_neutral_cues = 100*sum(p_cmpr_neutralBias<.05)/sub
p_cmpr_to_5pct = binomTest(sum(p_cmpr_neutralBias<.05),sub,.05,'two')


%% Control analyses: exclude different types of outliers
% no_extreme_c = [1:4,6:70]; %Exclude subject (S5) with c > 1
% [b,F,p] = perform_regression(c_pred_mid(no_extreme_c), c_12N(no_extreme_c,3))
% non_outliers_5_95 = [1:59,61:70]; %Exclude subject (S60) with %Cat1 response < 5% or >95%
% [b,F,p] = perform_regression(c_pred_mid(non_outliers_5_95), c_12N(non_outliers_5_95,3))
% non_outliers_10_90 = [1:31,33:48,50:59,61:70]; %Exclude subjects (S32,49,60) with %Cat1 response < 5% or >95%
% [b,F,p] = perform_regression(c_pred_mid(non_outliers_10_90), c_12N(non_outliers_10_90,3))