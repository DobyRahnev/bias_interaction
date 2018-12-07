function plotSDT3criteria(dprime, c_12N, subplot_num)

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

% Plot Gaussians
subplot(1,2,subplot_num)
plot(range, gauss(1,:), 'color', [.5,.5,.5], 'Linewidth', 2); %gray
hold
plot(range, gauss(2,:), 'k', 'Linewidth', 2);

% Plot criteria and extra lines
plot([c_12N(1),c_12N(1)], [0 .5], 'b', 'Linewidth', 3)
plot([c_12N(2),c_12N(2)], [0 .5], 'r', 'Linewidth', 3)
plot([mean(c_12N(1:2)),mean(c_12N(1:2))], [0 .5], 'm', 'Linewidth', 3)
plot([c_12N(3),c_12N(3)], [0 .5], 'color', [0,176/255,80/255], 'Linewidth', 3) %green
plot([0,0], [0 .5], 'k', 'Linewidth', 3)

% Remove line for y axis
plot([yLimits(1),yLimits(1)], xLimits, 'w-', 'Linewidth', 3)

% Figure details
xlim(yLimits);
xlabel('Evidence');
ylim(xLimits);
set(gca,'YTick',[])

% Add textbox with information about criteria
annotation('textbox',...
    [rem(subplot_num-1,2)/2, .9, .1, .1],...
    'String',{['c_{neutral} = ' num2str(round(100*c_12N(3))/100)],...
    ['c_{PredMid} = ' num2str(round(100*(c_12N(1)+c_12N(2))/2)/100)],...
    'c_{NoBias} = 0'},...
    'FontSize',12);