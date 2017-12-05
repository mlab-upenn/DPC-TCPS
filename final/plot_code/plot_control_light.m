
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


H2 = plot(ptimevec,yylit(plotdur));
H2.Color = [0    0.4470    0.7410];
H2.LineStyle = '-';
H2.Marker = marker1;

xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
% xlim([xmin, xmax]);

load('Results/dpc.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker2 = 's';
H4 = plot(ptimevec,yylit(plotdur));

H4.Color = [0.8500    0.3250    0.0980];
H4.LineStyle = '-';
H4.Marker = marker2;
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
% xlim([xmin, xmax]);

load('Results/donothing.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker3 = 'none';
% set(0,'DefaultLineLineWidth',1);

H6 = plot(ptimevec,yylit(plotdur));

H6.Color = [0.9290    0.6940    0.1250];
H6.LineStyle = '-.';
H6.Marker = marker3;


ylabel('Light Level [-]')
set(gca,'TickLabelInterpreter','latex')
set(0,'DefaultLineLineWidth',1);
vline(datenum(ptimevec(13)),'--k','Start');
% vline(datenum(ptimevec(25)),'--k','End');
vline(datenum(ptimevec(37)),'--k','End');
set(0,'DefaultLineLineWidth',2);
hleg = legend( 'mbCRT', 'DPCRT', 'Naive', 'Location', 'southeast');
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'on');
datetick('x','HH:MM');
xmin = datenum(ptimevec(1));
xmax = datenum(ptimevec(end));
% xlim([xmin, xmax]);
xlabel('Time of day [hh:mm]');
ylim([0.5,0.8]);
print('-depsc2', '-r600', '../Figures/res_control.eps')
