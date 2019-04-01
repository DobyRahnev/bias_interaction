%fit_mixture_strategy2 (testing the "eliminate" hypothesis)

clc
clear

% Add helper functions and define useful variables
addpath(genpath(fullfile(pwd, 'helperFunctions')));

% Load data
load dprime_criterion
perform_fitting = 0; %If 0, then previous fitting results will be loaded

% Perform fitting or load previous fitting results
if perform_fitting
    
    % Parameters
    N = 1000000;
    d_cue1 = zeros(size(c_12N,1),100);
    d_cue2 = zeros(size(c_12N,1),100);
    c_cue1 = zeros(size(c_12N,1),100);
    c_cue2 = zeros(size(c_12N,1),100);
    
    % Loop over all subjects
    for sub=1:size(c_12N,1)
        sub
        
        % Determine mu and criterion based on the observed data
        mu = dprime_12N(sub,3); %observed d'
        crit = 0;
        
        % Generate the stim, SDT evidence, and responses
        stim = mod(randperm(N),2); %0: noise, 1: signal
        evidence = normrnd(mu*(stim-.5), 1);
        resp_neutral = evidence > crit; %0: noise, 1: signal
        [d_neutral(sub), c_neutral(sub)] = data_analysis_resp(stim, resp_neutral);
        
        % Simulate the results of different levels of prop_follow_cue
        for prop_follow_cue=0:.01:.99
            
            % Determine responses for the two cues
            resp_cue1 = resp_neutral;
            resp_cue2 = resp_neutral;
            follow_cue = round(prop_follow_cue*N);
            resp_cue1(1:follow_cue) = zeros(follow_cue,1);
            resp_cue2(1:follow_cue) = ones(follow_cue,1);
            
            % Compute d' and c for each cue type
            prop_number = round(prop_follow_cue*100+1);
            [d_cue1(sub,prop_number), c_cue1(sub,prop_number)] = data_analysis_resp(stim, resp_cue1);
            [d_cue2(sub,prop_number), c_cue2(sub,prop_number)] = data_analysis_resp(stim, resp_cue2);
        end
    end
    
    % Save fitting results
    save fittingResults2 d_cue1 d_cue2 d_neutral c_cue1 c_cue2 c_neutral
else
    % Load fitting results
    load fittingResults2
end

% Determine best fit for each subject
for sub=1:size(c_12N,1)
    crit_fit = abs(c_cue1(sub,:)-c_12N(sub,1)) + abs(c_cue2(sub,:)-c_12N(sub,2));
    best_proportion_num = find(crit_fit==min(crit_fit));
    proportion_follow_cue(sub) = (best_proportion_num-1)/100;
    d_sim(sub,:) = [d_cue1(sub,best_proportion_num), d_cue2(sub,best_proportion_num), d_neutral(sub)];
    c_sim(sub,:) = [c_cue1(sub,best_proportion_num), c_cue2(sub,best_proportion_num), c_neutral(sub)];
end

% Display results
average_dprime_cues_observed = mean(mean(dprime_12N(:,1:2),2))
average_dprime_cues_model = mean(mean(d_sim(:,1:2),2))
[~,p,~,stats] = ttest(mean(dprime_12N(:,1:2),2), mean(d_sim(:,1:2),2))