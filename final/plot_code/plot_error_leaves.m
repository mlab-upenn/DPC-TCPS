
errorInLeaves;

set(0,'defaulttextinterpreter','latex');
fontsize = 18;
set(0,'DefaultTextFontSize',fontsize,...
'DefaultAxesFontSize',fontsize,...
'DefaultLineLineWidth',2,...
'DefaultLineMarkerSize',7,...
'DefaultTextHorizontalAlignment','left')

figure; hold on; box on; grid on;
LineWidth = 2;
h1 = stem(1:length(dr12), error_val_max/1e6);
h2 = stem(1:length(dr12), error_val_min/1e6);
h1.MarkerSize = 7;
h1.Color = 'k';
h1.LineStyle = ':';
h1.LineWidth = 0.5;
h1.MarkerFaceColor = 'g';
h1.MarkerEdgeColor = 'k';
h2.MarkerSize = 7;
h2.Color = 'k';
h2.LineStyle = ':';
h2.LineWidth = 0.5;
h2.MarkerFaceColor = 'm';
h2.MarkerEdgeColor = 'k';

ylabel('Residual Error $P_{\mathrm{pred}}-P_{\mathrm{real}}$ [MW]');
xlabel('Leaf Index [-]');
xmin = 0;
xmax = length(dr12)+1;
xlim([xmin, xmax]);
ylim([-0.2, 0.2]);
set(gca,'TickLabelInterpreter','latex')
hleg = legend([h1, h2], 'Max', 'Min', 'Location', 'NorthEast');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'off');

print('-depsc2', '-r600', '../Figures/error_leaf.eps')
