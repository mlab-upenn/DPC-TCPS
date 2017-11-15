
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
marker1 = '+';
h1 = plot(ptimevec,yyclg(plotdur), '-', 'Marker', marker1);
set(h1, 'Color', [0    0.4470    0.7410]);
[AX,H1,H2] = plotyy(ptimevec,yycw(plotdur),ptimevec,yylit(plotdur));
H1.Color = [0    0.4470    0.7410];
H1.LineStyle = '-';
H1.Marker = marker1;
H2.Color = [0    0.4470    0.7410];
H2.LineStyle = '-';
H2.Marker = marker1;
set(AX(1),'YLim',[0 30]);
set(AX(2),'YLim',[0 1.2],'YTick',0.6:0.1:1)
% set(get(AX(2),'Ylabel'),'string','Light Level [-]')
set(AX(1),'TickLabelInterpreter','latex', 'YColor','k')
set(AX(2),'TickLabelInterpreter','latex', 'YColor','k')
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
xlim([xmin, xmax]);

load('Results/dpc.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker2 = 's';
h2 = plot(ptimevec,yyclg(plotdur), '-', 'Marker', marker2);
set(h2, 'Color', [0.8500    0.3250    0.0980]);
[AX,H3,H4] = plotyy(ptimevec,yycw(plotdur),ptimevec,yylit(plotdur));
set(AX(1),'YLim',[0 30]);
set(AX(2),'YLim',[0 1.2],'YTick',0.6:0.1:1)
set(AX(1),'TickLabelInterpreter','latex', 'YColor','k')
set(AX(2),'TickLabelInterpreter','latex', 'YColor','k')
H3.Color = [0.8500    0.3250    0.0980];
H3.LineStyle = '-';
H3.Marker = marker2;
H4.Color = [0.8500    0.3250    0.0980];
H4.LineStyle = '-';
H4.Marker = marker2;
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
xlim([xmin, xmax]);

load('Results/donothing.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker3 = 'none';
% set(0,'DefaultLineLineWidth',1);
h3 = plot(ptimevec,yyclg(plotdur), '-.', 'Marker', marker3);
[AX,H5,H6] = plotyy(ptimevec,yycw(plotdur),ptimevec,yylit(plotdur));
set(h3, 'Color', [0.9290    0.6940    0.1250]);
H5.Color = [0.9290    0.6940    0.1250];
H5.LineStyle = '-.';
H5.Marker = marker3;
H6.Color = [0.9290    0.6940    0.1250];
H6.LineStyle = '-.';
H6.Marker = marker3;


ylabel('Temperature [$^{\circ}$C]')
set(AX(1),'YLim',[0 30]);
set(AX(2),'YLim',[0 1.2],'YTick',0.6:0.1:1)
set(get(AX(2),'Ylabel'),'string','Light Level [-]')
set(AX(1),'TickLabelInterpreter','latex', 'YColor','k')
set(AX(2),'TickLabelInterpreter','latex', 'YColor','k')
set(gca,'TickLabelInterpreter','latex')
set(0,'DefaultLineLineWidth',1);
vline(datenum(ptimevec(13)),'--k','Start');
% vline(datenum(ptimevec(25)),'--k','End');
vline(datenum(ptimevec(37)),'--k','End');
set(0,'DefaultLineLineWidth',2);
hleg = legend([h1, h2, h3], 'mbCRT', 'DPCRT', 'Naive', 'Location', 'Best');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'on');
datetick('x','HH:MM');
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
xlim([xmin, xmax]);
xlabel('Time of day [hh:mm]');

print('-depsc2', '-r600', '../Figures/res_control.eps')
