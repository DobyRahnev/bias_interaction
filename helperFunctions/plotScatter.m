function plotScatter(crit, bias_shift, expt_filter, xlimits, xlabel_text, ylabel_text, subjects_to_plot)

figure

% Plot the different markers
plot(crit(expt_filter==1) ,bias_shift(expt_filter==1), 'r.', 'MarkerSize',25);
hold
plot(crit(expt_filter==2) ,bias_shift(expt_filter==2), 'b.', 'MarkerSize',25);
plot(crit(expt_filter==3) ,bias_shift(expt_filter==3), 'g.', 'MarkerSize',25);

% Add label information
xlabel(xlabel_text);
ylabel(ylabel_text);
legend('Expt 1', 'Expt 2', 'Expt 3')
xlim(xlimits);

% Add line of best fit
stats=regstats(bias_shift,crit(:));
plot(xlimits, stats.beta(1)+xlimits*stats.beta(2), 'k');

% Add different markers for 6 subjects from Figure 3
if exist('subjects_to_plot', 'var')
    plot(crit(subjects_to_plot(1)) ,bias_shift(subjects_to_plot(1)), 'rd', 'MarkerSize',15);
    plot(crit(subjects_to_plot(2)) ,bias_shift(subjects_to_plot(2)), 'rd', 'MarkerSize',15);
    plot(crit(subjects_to_plot(3)) ,bias_shift(subjects_to_plot(3)), 'bd', 'MarkerSize',15);
    plot(crit(subjects_to_plot(4)) ,bias_shift(subjects_to_plot(4)), 'bd', 'MarkerSize',15);
    plot(crit(subjects_to_plot(5)) ,bias_shift(subjects_to_plot(5)), 'gd', 'MarkerSize',15);
    plot(crit(subjects_to_plot(6)) ,bias_shift(subjects_to_plot(6)), 'gd', 'MarkerSize',15);
end