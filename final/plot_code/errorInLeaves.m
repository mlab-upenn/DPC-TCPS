
load('powertree_dpc2x.mat')

for ii = 1:length(dr12)
    
    coeff_clg = dr12(ii).mdl_clg';
    coeff_cw = dr12(ii).mdl_cw';
    coeff_lgt = dr12(ii).mdl_lgt';
    
    X = dr12(ii).xdata{1,1};
    X_clg = zeros(ctrlHzn+1,length(dr12(ii).leaves{1}));
    X_cw = zeros(ctrlHzn+1,length(dr12(ii).leaves{1}));
    X_lgt = zeros(ctrlHzn+1,length(dr12(ii).leaves{1}));
    for ij = 1:ctrlHzn+1
        X_clg(ij,:) = X(3*(ij-1)+1,:);
        X_cw(ij,:) = X(3*(ij-1)+2,:);
        X_lgt(ij,:) = X(3*(ij-1)+3,:);
    end
    
    ifNorm = 0;
    if ifNorm
        [X_clg, Xmin_clg, Xmax_clg] = normalize(X_clg);
        [X_cw, Xmin_cw, Xmax_cw] = normalize(X_cw);
        [X_lgt, Xmin_lgt, Xmax_lgt] = normalize(X_lgt);
    end
    
    X_clg = [ones(size(dr12(ii).ydata{1},2),1), X_clg'];
    X_cw = [ones(size(dr12(ii).ydata{1},2),1), X_cw'];
    X_lgt = [ones(size(dr12(ii).ydata{1},2),1), X_lgt'];
    
    pred_val_clg{ii} = X_clg*coeff_clg';
    pred_val_cw{ii} = X_cw*coeff_cw';
    pred_val_lgt{ii} = X_lgt*coeff_lgt';
    act_val{ii} = sum(dr12(ii).ydata{1},1)';
    
    error_val_max(ii) = max((pred_val_clg{ii}+pred_val_cw{ii}+pred_val_lgt{ii})/3-act_val{ii})/length(dr12(ii).leaves{1});
    error_val_min(ii) = min((pred_val_clg{ii}+pred_val_cw{ii}+pred_val_lgt{ii})/3-act_val{ii})/length(dr12(ii).leaves{1});
    error_val2(ii) = sum((pred_val_clg{ii}+pred_val_cw{ii}+pred_val_lgt{ii})/3-act_val{ii})/norm(act_val{ii});
    
    % error_val{ii} = abs(pred_val_lgt{ii}-act_val{ii});
    
end

figure; hold on;
stem(1:length(dr12), error_val_max/1e6);
stem(1:length(dr12), error_val_min/1e6);

% figure; hold on;
% stem(1:length(dr12), error_val2);


%%
jj = 1;

for jj = [43 65 66 103]
figure; hold on;
plot(act_val{jj});
plot((pred_val_clg{jj}+pred_val_cw{jj}+pred_val_lgt{jj})/3);
% plot(pred_val_cw{jj});
% plot(pred_val_lgt{jj});
end
