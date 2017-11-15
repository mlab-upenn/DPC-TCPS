
errorInLeaves;

set(0,'defaulttextinterpreter','latex');
fontsize = 18;
set(0,'DefaultTextFontSize',fontsize,...
'DefaultAxesFontSize',fontsize,...
'DefaultLineLineWidth',2,...
'DefaultLineMarkerSize',7,...
'DefaultTextHorizontalAlignment','left')

figure;
subplot(2,1,1); hold on; box on; grid on;
jj = 43;
title('Leaf 1')
h1 = plot(act_val{jj}/1e6, '-o');
h2 = plot((pred_val_clg{jj}+pred_val_cw{jj}+pred_val_lgt{jj})/3/1e6, '-s');
ylabel('$\sum_i P_{t+i}$ [MW]');
xmin = 0;
xmax = 12;
xlim([xmin, xmax]);
set(gca,'TickLabelInterpreter','latex');
hleg = legend([h1, h2], 'Ground Truth', 'Predicted', 'Location', 'NorthEast');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'off');

subplot(2,1,2); hold on; box on; grid on;
jj = 65;
title('Leaf 2')
plot(act_val{jj}/1e6, '-o');
plot((pred_val_clg{jj}+pred_val_cw{jj}+pred_val_lgt{jj})/3/1e6, '-s');
xlabel('Data Sample Index [-]');
ylabel('$\sum_i P_{t+i}$ [MW]');
xmin = 0;
xmax = 11;
xlim([xmin, xmax]);
set(gca,'TickLabelInterpreter','latex');

print('-depsc2', '-r600', '/Users/Achin/GitHub/DPC-TCPS/final/Figures/error_leaf2_1.eps')

figure;
subplot(2,1,1); hold on; box on; grid on;
jj = 66;
title('Leaf 3')
plot(act_val{jj}/1e6, '-o');
plot((pred_val_clg{jj}+pred_val_cw{jj}+pred_val_lgt{jj})/3/1e6, '-s');
ylabel('$\sum_i P_{t+i}$ [MW]');
xlim([xmin, xmax]);
set(gca,'TickLabelInterpreter','latex');

subplot(2,1,2); hold on; box on; grid on;
jj = 103;
title('Leaf 4')
h1 = plot(act_val{jj}/1e6, '-o');
h2 = plot((pred_val_clg{jj}+pred_val_cw{jj}+pred_val_lgt{jj})/3/1e6, '-s');
xlabel('Data Sample Index [-]');
ylabel('$\sum_i P_{t+i}$ [MW]');
xlim([xmin, xmax]);
set(gca,'TickLabelInterpreter','latex');
hleg = legend([h1, h2], 'Ground Truth', 'Predicted', 'Location', 'NorthWest');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'off');

print('-depsc2', '-r600', '../Figures/error_leaf2_2.eps')
