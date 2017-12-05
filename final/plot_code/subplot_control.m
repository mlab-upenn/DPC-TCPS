set(0,'defaulttextinterpreter','latex');
fontsize = 18;
set(0,'DefaultTextFontSize',fontsize,...
'DefaultAxesFontSize',fontsize,...
'DefaultLineLineWidth',2,...
'DefaultLineMarkerSize',4,...
'DefaultTextHorizontalAlignment','left')

% Light SP
subplot(3,1,1)
hold on; box on; grid on;
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

% DPCRT
load('Results/dpc.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker2 = 's';
H4 = plot(ptimevec,yylit(plotdur));
H4.Color = [0.8500    0.3250    0.0980];
H4.LineStyle = '-';
H4.Marker = marker2;

% Naive
load('Results/donothing.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker3 = 'none';
H6 = plot(ptimevec,yylit(plotdur));
H6.Color = [0.9290    0.6940    0.1250];
H6.LineStyle = '-.';
H6.Marker = marker3;

ylabel('$u_\ell$ [-]')
set(gca,'TickLabelInterpreter','latex')
set(0,'DefaultLineLineWidth',1);
ylim([0.5,0.8]);
vline(datenum(ptimevec(13)),'--k','Start');
vline(datenum(ptimevec(37)),'--k','End');
set(0,'DefaultLineLineWidth',2);
hleg = legend('mbCRT', 'DPCRT', 'Naive', 'Location', 'southeast');
set(hleg, 'box', 'off');
datetick('x','HH:MM');
hold off

% Cooling SP
subplot(3,1,2)
hold on; box on; grid on;
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

load('Results/dpc.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker2 = 's';
h2 = plot(ptimevec,yyclg(plotdur), '-', 'Marker', marker2);
set(h2, 'Color', [0.8500    0.3250    0.0980]);

load('Results/donothing.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker3 = 'none';
h3 = plot(ptimevec,yyclg(plotdur), '-.', 'Marker', marker3);
set(h3, 'Color', [0.9290    0.6940    0.1250]);

ylabel('$u_c$ [$^{\circ}$C]')
set(gca,'TickLabelInterpreter','latex')
set(0,'DefaultLineLineWidth',1);
ylim([23.371,29])
vline(datenum(ptimevec(13)),'--k','Start');
vline(datenum(ptimevec(37)),'--k','End');
set(0,'DefaultLineLineWidth',2);
% hleg = legend([h1, h2, h3], 'mbCRT', 'DPCRT', 'Naive', 'Location', 'southeast');
% set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'on');
datetick('x','HH:MM');

% Chilled Water SP
subplot(3,1,3)
hold on; box on; grid on;
t1 = datetime('17-Jul-2013 00:00');
t2 = datetime('17-Jul-2013 23:55');
timevec = t1:minutes(5):t2;

% mbCRT
load('Results/mbCRT.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker1 = '+';
H1 = plot(ptimevec,yycw(plotdur));
H1.Color = [0    0.4470    0.7410];
H1.LineStyle = '-';
H1.Marker = marker1;

load('Results/dpc.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker2 = 's';
H3 = plot(ptimevec,yycw(plotdur));
H3.Color = [0.8500    0.3250    0.0980];
H3.LineStyle = '-';
H3.Marker = marker2;

load('Results/donothing.mat');
plotdur = 169:217;
ptimevec = timevec(plotdur);
marker3 = 'none';
H5 = plot(ptimevec,yycw(plotdur));
H5.Color = [0.9290    0.6940    0.1250];
H5.LineStyle = '-.';
H5.Marker = marker3;

ylabel('$u_h$ [$^{\circ}$C]')
set(gca,'TickLabelInterpreter','latex')
set(0,'DefaultLineLineWidth',1);
ylim([5.7,11])
vline(datenum(ptimevec(13)),'--k','Start');
vline(datenum(ptimevec(37)),'--k','End');
set(0,'DefaultLineLineWidth',2);
newPosition = [0.4 0.85 0.2 0.2];
newUnits = 'normalized';
set(hleg,'Interpreter', 'LaTex', 'FontSize', fontsize, 'Color', 'w', 'box', 'off', ...
    'Position', newPosition,'Units', newUnits, 'orientation', 'horizontal');
datetick('x','HH:MM');
xlabel('Time of day [hh:mm]');

print('-depsc2', '-r600', '../Figures/res_control.eps')
