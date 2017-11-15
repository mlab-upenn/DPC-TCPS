
clear
% close all

%% Testing or training

traintree = 0;
if traintree
    load train_data.mat
else
    load powertree_horizon20
    load test_data.mat
end

%% Prepare Training/Testing data

disp('Preparing data..');

XDR = [BASEMENTZoneAirTemperatureCTimeStep(2:end),...
    HEATSYS1BOILERBoilerOutletTemperatureCTimeStep(2:end),...
    COOLSYS1CHILLER1ChillerEvaporatorOutletTemperatureCTimeStep(2:end),...
    COOLSYS1CHILLER2ChillerEvaporatorOutletTemperatureCTimeStep(2:end),...
    CORE_BOTTOMZoneAirTemperatureCTimeStep(2:end),...
    CORE_MIDZoneAirTemperatureCTimeStep(2:end),...
    CORE_TOPZoneAirTemperatureCTimeStep(2:end),...
    EMScurrentDayOfWeekTimeStep(2:end),...
    GROUNDFLOOR_PLENUMZoneAirTemperatureCTimeStep(2:end),...
    HTGSETP_SCHScheduleValueTimeStep(2:end),...
    HWLOOPTEMPSCHEDULEScheduleValueTimeStep(2:end),...
    MIDFLOOR_PLENUMZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_BOT_ZN_1ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_BOT_ZN_2ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_BOT_ZN_3ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_BOT_ZN_4ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_MID_ZN_1ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_MID_ZN_2ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_MID_ZN_3ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_MID_ZN_4ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_TOP_ZN_1ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_TOP_ZN_2ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_TOP_ZN_3ZoneAirTemperatureCTimeStep(2:end),...
    PERIMETER_TOP_ZN_4ZoneAirTemperatureCTimeStep(2:end),...
    EMScurrentTimeOfDayTimeStep(2:end),...
    TOPFLOOR_PLENUMZoneAirTemperatureCTimeStep(2:end)];

XENV = [EnvironmentSiteWindDirectiondegTimeStep(2:end),...
    EnvironmentSiteWindSpeedmsTimeStep(2:end)...
    EnvironmentSiteOutdoorAirDrybulbTemperatureCTimeStep(2:end),...
    EnvironmentSiteOutdoorAirRelativeHumidityTimeStep(2:end),...
    EnvironmentSiteOutdoorAirWetbulbTemperatureCTimeStep(2:end)];

ctrlHzn = 20;
orderAR = 6;
pred_env = lagmatrix(XENV, -(1:1:ctrlHzn));
pred_env(isnan(pred_env)) = 0;

YDR = WholeBuildingFacilityTotalElectricDemandPowerWTimeStep(2:end);
pred_kw = lagmatrix(YDR, -(1:1:ctrlHzn));
pred_kw(isnan(pred_kw)) = 0;

XDRctrl = [CLGSETP_SCHScheduleValueTimeStep(2:end), ...
    CWLOOPTEMPSCHEDULEScheduleValueTimeStep(2:end),...
    BLDG_LIGHT_SCHScheduleValueTimeStep(2:end)];
pred_XDRctrl = lagmatrix(XDRctrl,-(1:1:ctrlHzn));
XDRctrl = [XDRctrl, pred_XDRctrl];

lag_kw = lagmatrix(YDR, 1:1:orderAR);
lag_kw(isnan(lag_kw)) = 0;

% Augment training matrix with lagged kw columns
XDR = [XDR, XENV, pred_env, lag_kw];
YDR = [YDR, pred_kw];

XDR(end-max(orderAR,ctrlHzn)+1:end,:) = [];
YDR(end-max(orderAR,ctrlHzn)+1:end,:) = [];
XDRctrl(end-max(orderAR,ctrlHzn)+1:end,:) = [];

disp('Done.');

%% Tree Regression with multi-output data

if traintree
    
    disp('Learning Regression Tree');
    
    cat = [8,25];
    minleaf = 5;   % minimium number of leaf node observations
    tic
    powertree = buildTree(XDR', YDR', minleaf, 200, [], true);
    toc
    tic
    powertree_mat = fitrtree(XDR, YDR(:,1), 'MinLeafSize', minleaf, 'CategoricalPredictors', cat);
    toc
    
    % predict on training and testing data and plot the fits
    [YDRrtree, ~] = evalTree(powertree, XDR');
    powertreeNRMSE = sqrt(mean((YDRrtree'-YDR).^2,1))./mean(YDR,1);
    
%     figure; hold on;
%     for idx = 1:ctrlHzn+1
%         h1 = plot(YDR(:,idx), YDR(:,idx), '.b');
%         h2 = plot(YDR(:,idx), YDRrtree(idx,:), '.');
%     end
%     clearvars -except powertree powertree_mat traintree
    
end

%% Tree evaluation on testing data

if ~traintree 
    
    [YDRrtree, ~] = evalTree(powertree, XDR');
    YDRrtree_mat = predict(powertree_mat, XDR);
    
    powertreeNRMSE = sqrt(mean((YDRrtree'-YDR).^2,1))./mean(YDR,1);
    powertreeNRMSE_mat = sqrt(mean((YDRrtree_mat-YDR(:,1)).^2))/mean(YDR(:,1));
    
end
