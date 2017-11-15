
addpath('./TreeModel/')

PowerConsumptionDOE;

set(0,'defaulttextinterpreter','latex');
fontsize = 18;
set(0,'DefaultTextFontSize',fontsize,...
'DefaultAxesFontSize',fontsize,...
'DefaultLineLineWidth',2,...
'DefaultLineMarkerSize',7,...
'DefaultTextHorizontalAlignment','left')

t1 = datetime('01-Jul-2013 00:05');
t2 = datetime('31-Jul-2013 23:55');
timevec = t1:minutes(5):t2;

plotdur = 3456:1:3600;
ptimevec = timevec(plotdur);
% l = length(YDRrtree_mat(:,1));

figure; hold on; box on; grid on;
LineWidth = 2;
h1 = plot(ptimevec, YDRrtree(1,20+plotdur)/1e6, 'r', 'LineWidth', LineWidth);
h2 = plot(ptimevec, YDRrtree(11,10+plotdur)/1e6, '--b', 'LineWidth', LineWidth);
h3 = plot(ptimevec, YDRrtree(21,plotdur)/1e6, '.-g', 'LineWidth', LineWidth);
h4 = plot(ptimevec, YDR(20+plotdur,1)/1e6, '--m', 'LineWidth', LineWidth);
ylabel('$P$ [MW]');
datetick('x', 'HH:MM');
xlabel('[hh:mm]');
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
xlim([xmin, xmax]);
set(gca,'TickLabelInterpreter','latex')
hleg = legend([h1, h2, h3, h4], '$P_{t}$', '$P_{t|t-10}$', '$P_{t|t-20}$', 'Ground Truth', 'Location', 'SouthEast');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'off');

print('-depsc2', '-r600', '../Figures/perf_test.eps')
