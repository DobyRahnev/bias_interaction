function plotScatter(Y, X, expt_filter, xlimits, xlabel_text, ylabel_text, dash_loc)

figure

% Plot the different markers
plot(X(expt_filter==1), Y(expt_filter==1), 'r.', 'MarkerSize',30);
hold
plot(X(expt_filter==2), Y(expt_filter==2), 'b.', 'MarkerSize',30);
plot(X(expt_filter==3), Y(expt_filter==3), 'g.', 'MarkerSize',30);

% Add label information
xlabel(xlabel_text);
ylabel(ylabel_text);
legend('Expt 1', 'Expt 2', 'Expt 3')
xlim(xlimits);
ylim(xlimits);

% Add line of best fit
stats=regstats(Y,X);
plot(xlimits, stats.beta(1)+xlimits*stats.beta(2), 'k', 'LineWidth', 3);

% Add additional lines
plot(xlimits, xlimits, 'color', [.5,.5,.5], 'LineWidth', 1);
plot(xlimits, [dash_loc,dash_loc], 'color', [.5,.5,.5], 'LineWidth', 1);
