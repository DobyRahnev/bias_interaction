function plotSDT3criteria(dprime, c_RNL, subplot_num)

% Basic parameters
yLimits = [-4.5, 4.5];
xLimits = [0,.6];
stepSize = .01;
mus = [-dprime/2, dprime/2];
sigma = 1;

% Compute signals for each distribution
range = yLimits(1):stepSize:yLimits(2);
for distrib=1:length(mus)
    gauss(distrib,:) = normpdf(range, mus(distrib), sigma);
end

% Plot criteria and extra lines
subplot(3,2,subplot_num)
plot([c_RNL(1),c_RNL(1)], [0 .5], 'b', 'Linewidth', 3)
hold
plot([c_RNL(2),c_RNL(2)], [0 .5], 'k', 'Linewidth', 3)
plot([c_RNL(3),c_RNL(3)], [0 .5], 'r', 'Linewidth', 3)
legend('right cue', 'neutral cue', 'left cue')

% Plot Gaussians
plot(range, gauss(1,:), 'k');
plot(range, gauss(2,:), 'k');

% Replot the criteria so that they are on top of the Gaussians
plot([c_RNL(1),c_RNL(1)], [0 .5], 'b', 'Linewidth', 3)
plot([c_RNL(2),c_RNL(2)], [0 .5], 'k', 'Linewidth', 3)
plot([c_RNL(3),c_RNL(3)], [0 .5], 'r', 'Linewidth', 3)
plot([0,0], xLimits, 'k--', 'Linewidth', 1)

% Remove line for y axis
plot([yLimits(1),yLimits(1)], xLimits, 'w-', 'Linewidth', 3)

% Figure details
xlim(yLimits);
ylim(xLimits);
set(gca,'YTick',[])

% Add textbox with information about criteria
yloc = [.9, .9, .6, .6, .3, .3];
annotation('textbox',...
    [rem(subplot_num-1,2)/2, yloc(subplot_num), .1, .1],...
    'String',{['shift_{right} = ' num2str(round(100*(c_RNL(2)-c_RNL(1)))/100)],...
    ['shift_{left} = ' num2str(round(100*(c_RNL(3)-c_RNL(2)))/100)],...
    ['\Delta_{shift} = ' num2str(round(100*(c_RNL(2)-c_RNL(1)))/100-round(100*(c_RNL(3)-c_RNL(2)))/100)]},...
    'FontSize',12,...
    'LineStyle','none');