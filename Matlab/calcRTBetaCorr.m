% subs = {'Sub01'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
fig = 0;

main_dir = '/home/sshankar/Categorization/Data/';
im_dir = [main_dir 'Imaging/'];
beh_dir = [main_dir 'Behavior/Scanner/'];
roi_dir = [im_dir 'All/ROI_3x3_005unc/'];
roi_var = 'nVoxAnova005uncPositive';
beta_prefix = 'SingleTrial/';

cd(roi_dir)
load('nVox_native')
nROI = size(eval(roi_var),2);

for si = 1:length(subs)
    sub = subs{si};
    beta_dir = [im_dir sub '/Session_' int2str(baseSess(si)) '/' beta_prefix];
    rt_dir = [beh_dir sub];
    
    % Load the beta and RT matrices
    % This loads the following variables into the workspace:
    % betas, betac, betai, rts, rtc, rti
    cd(beta_dir)
    load([sub '_betaMat'])
    
%     Using all trials
    cohs = size(rts,1);
    dist = size(rts,2);
    
    RTBetaSlopeCD = zeros(cohs,dist,nROI);
    RTcBetaSlopeCD = zeros(cohs,dist,nROI);
    RTiBetaSlopeCD = zeros(cohs,dist,nROI);
    RTBetaIntCD = zeros(cohs,dist,nROI);
    RTcBetaIntCD = zeros(cohs,dist,nROI);
    RTiBetaIntCD = zeros(cohs,dist,nROI);
    
    RTBetaSlopeC = zeros(cohs,nROI);
    RTcBetaSlopeC = zeros(cohs,nROI);
    RTiBetaSlopeC = zeros(cohs,nROI);
    RTBetaIntC = zeros(cohs,nROI);
    RTcBetaIntC = zeros(cohs,nROI);
    RTiBetaIntC = zeros(cohs,nROI);
    
    RTBetaSlopeD = zeros(dist,nROI);
    RTcBetaSlopeD = zeros(dist,nROI);
    RTiBetaSlopeD = zeros(dist,nROI);
    RTBetaIntD = zeros(dist,nROI);
    RTcBetaIntD = zeros(dist,nROI);
    RTiBetaIntD = zeros(dist,nROI);
    
    for ri = 1:nROI
        if betas{1,1,ri}(1) ~= 0
            ctr = 1;
            for ci = 1:cohs
                for di = 1:dist
                    r = robustfit(rts{ci,di},betas{ci,di,ri});
                    RTBetaSlopeCD(ci,di,ri) = r(2);
                    RTBetaIntCD(ci,di,ri) = r(1);
                    r = robustfit(rtc{ci,di},betac{ci,di,ri});
                    RTcBetaSlopeCD(ci,di,ri) = r(2);
                    RTcBetaIntCD(ci,di,ri) = r(1);
                    if ~isempty(rti{ci,di}) && length(rti{ci,di}) >= 10
                        r = robustfit(rti{ci,di},betai{ci,di,ri});
                        RTiBetaSlopeCD(ci,di,ri) = r(2);
                        RTiBetaIntCD(ci,di,ri) = r(1);
                    end                    
                    if ci == 1
                        r = robustfit(cat(1,rts{:,di}),cat(1,betas{:,di,ri}));
%                         r = robustfit(cat(1,rts{2:end,di}),cat(1,betas{2:end,di,ri}));
                        RTBetaSlopeD(di,ri) = r(2);
                        RTBetaIntD(di,ri) = r(1);
                        r = robustfit(cat(1,rtc{:,di}),cat(1,betac{:,di,ri}));
%                         r = robustfit(cat(1,rtc{2:end,di}),cat(1,betac{2:end,di,ri}));
                        RTcBetaSlopeD(di,ri) = r(2);
                        RTcBetaIntD(di,ri) = r(1);
                        r = robustfit(cat(1,rti{:,di}),cat(1,betai{:,di,ri}));
%                         r = robustfit(cat(1,rti{2:end,di}),cat(1,betai{2:end,di,ri}));
                        RTiBetaSlopeD(di,ri) = r(2);
                        RTiBetaIntD(di,ri) = r(1);
                    end
                end
                r = robustfit(cat(1,rts{ci,:}),cat(1,betas{ci,:,ri}));
%                 r = robustfit(cat(1,rts{ci,2:end}),cat(1,betas{ci,2:end,ri}));
                RTBetaSlopeC(ci,ri) = r(2);
                RTBetaIntC(ci,ri) = r(1);
                r = robustfit(cat(1,rtc{ci,:}),cat(1,betac{ci,:,ri}));
%                 r = robustfit(cat(1,rtc{ci,2:end}),cat(1,betac{ci,2:end,ri}));
                RTcBetaSlopeC(ci,ri) = r(2);
                RTcBetaIntC(ci,ri) = r(1);
                r = robustfit(cat(1,rti{ci,:}),cat(1,betai{ci,:,ri}));
%                 r = robustfit(cat(1,rti{ci,2:end}),cat(1,betai{ci,2:end,ri}));
                RTiBetaSlopeC(ci,ri) = r(2);
                RTiBetaIntC(ci,ri) = r(1);
            end
        end
        save([beta_dir sub '_RTBetaReg'], 'RTBetaSlopeCD', 'RTBetaIntCD', 'RTcBetaSlopeCD', 'RTcBetaIntCD', 'RTiBetaSlopeCD', 'RTiBetaIntCD', ...
            'RTBetaSlopeC', 'RTBetaIntC', 'RTcBetaSlopeC', 'RTcBetaIntC', 'RTiBetaSlopeC', 'RTiBetaIntC', ...
            'RTBetaSlopeD', 'RTBetaIntD', 'RTcBetaSlopeD', 'RTcBetaIntD', 'RTiBetaSlopeD', 'RTiBetaIntD')
    end
end