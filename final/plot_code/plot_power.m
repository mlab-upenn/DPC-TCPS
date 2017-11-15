
set(0,'defaulttextinterpreter','latex');
fontsize = 18;
set(0,'DefaultTextFontSize',fontsize,...
'DefaultAxesFontSize',fontsize,...
'DefaultLineLineWidth',2,...
'DefaultLineMarkerSize',4,...
'DefaultTextHorizontalAlignment','left')

figure; hold on; box on; grid on;
t1 = datetime('17-Jul-2013 00:00');
t2 = datetime('17-Jul-2013 23:55');
timevec = t1:minutes(5):t2;

% mbCRT
load('Results/mbCRT.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
h1 = plot(ptimevec,logdata(plotdur,1)/1e6, '-+');

load('Results/dpc.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
h2 = plot(ptimevec,logdata(plotdur,1)/1e6, '-s');

load('Results/donothing.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
% set(0,'DefaultLineLineWidth',1);
h3 = plot(ptimevec,logdata(plotdur,1)/1e6, '-.');

ylim([1.05 1.8]);
ylabel('Temperature [$^{\circ}$C]')
set(gca,'TickLabelInterpreter','latex')
set(0,'DefaultLineLineWidth',1);
vline(datenum(ptimevec(13)),'--k','Start');
% vline(datenum(ptimevec(25)),'--k','End');
vline(datenum(ptimevec(37)),'--k','End');
set(0,'DefaultLineLineWidth',2);
ylabel('Power Consumption [MW]')
datetick('x','HH:MM');
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
xlim([xmin, xmax]);

xlabel('Time of day [hh:mm]');
set(gca,'TickLabelInterpreter','latex')

hleg = legend([h1, h2, h3], 'mbCRT', 'DPCRT', 'Naive', 'Location','NorthEast');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'on');

print('-depsc2', '-r600', '../Figures/res_power.eps')
