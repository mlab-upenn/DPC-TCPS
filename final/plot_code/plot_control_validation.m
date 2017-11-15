addpath('./TreeModel/')

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

figure; hold on; box on; grid on;
LineWidth = 2;

% tree without control variables
prepare_testdata;
[YDRrtree, ~] = evalTree(powertree, XDR');
powertreeNRMSE = sqrt(mean((YDRrtree'-YDR).^2,1))./mean(YDR,1);

h1 = plot(ptimevec, YDRrtree(1,6+plotdur)/1e6, 'r', 'LineWidth', LineWidth);
h2 = plot(ptimevec, YDRrtree(5,2+plotdur)/1e6, '--b', 'LineWidth', LineWidth);

% tree with control variables
prepare_testdata_CTRL;
[YDRrtree, ~] = evalTree(powertree, XDR');
powertreeNRMSE_CTRL = sqrt(mean((YDRrtree'-YDR).^2,1))./mean(YDR,1);

h3 = plot(ptimevec, YDRrtree(1,6+plotdur)/1e6, 'g', 'LineWidth', LineWidth);
h4 = plot(ptimevec, YDRrtree(5,2+plotdur)/1e6, '--m', 'LineWidth', LineWidth);
% h5 = plot(ptimevec, YDR(6+plotdur,1)/1e6, '.-k', 'LineWidth', LineWidth);

ylabel('$P$ [MW]');
datetick('x', 'HH:MM');
xlabel('[hh:mm]');
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
xlim([xmin, xmax]);
set(gca,'TickLabelInterpreter','latex')
hleg = legend([h3, h4, h1, h2], '$\mathcal{T}_1: P_t$', '$\mathcal{T}_1: P_{t+5}$',...
    '$\mathcal{T}_2: P_{t}$', '$\mathcal{T}_2: P_{t+5}$', 'Location', 'SouthEast');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'off');

print('-depsc2', '-r600', '../Figures/separation_vars.eps')
