% subs = {'Sub01'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
fig = 0;

main_dir = '/home/sshankar/Categorization/Data/';
im_dir = [main_dir 'Imaging/'];
beh_dir = [main_dir 'Behavior/Scanner/'];
fig_dir = [im_dir 'All/SingleTrial/RTBetaFigures/'];
roi_dir = [im_dir 'All/ROI_3x3_005unc/'];
roi_var = 'nVoxAnova005uncPositive';
beta_prefix = 'SingleTrial/';

cd(roi_dir)
load('nVox_native')
nROI = size(eval(roi_var),2);
ROI = [2 3 5 6 7 8 11 15 18 27];

for si = 1:length(subs)
    sub = subs{si};
    beta_dir = [im_dir sub '/Session_' int2str(baseSess(si)) '/' beta_prefix];
    rt_dir = [beh_dir sub];
    
    % Load the beta and RT matrices
    % This loads the following variables into the workspace:
    % betas, betac, betai, rts, rtc, rti
    cd(beta_dir)
    load([sub '_betaMat'])
    load([sub '_RTBetaReg'])
    
    cohs = size(rts,1);
    dist = size(rts,2);

    for ri = 1:length(ROI)
        close all
        if betas{1,1,ri}(1) ~= 0
            figure; hold on
            xmin = min(rtMat) - 0.25;
            xmax = max(rtMat) + 0.25;
            ymin = min(betaMat(:,ri,1)) - 2;
            ymax = max(betaMat(:,ri,1)) + 2;

    %         To plot each Coh-Dist combination separately
            ctr = 1;
            for ci = 1:cohs
                for di = 1:dist
                    subplot(4,5,ctr); hold on
                    plot(rts{ci,di},betas{ci,di,ri},'k.')
                    plot(rts{ci,di},RTBetaIntCD(ci,di,ri)+RTBetaSlopeCD(ci,di,ri)*rts{ci,di},'r')
                    axis([xmin xmax ymin ymax]);
                    axis square
                    ctr = ctr + 1;
                end
            end
        pFile = [sub '_RTBetaDistCD_ROI' int2str(ri)];
        print('-depsc2', [fig_dir pFile])

%     %         To plot individual coherences collapsed across distance
%             for ci = 1:cohs
%                 subplot(1,4,ci); hold on
%                 for di = 1:dist
%                     plot(rts{ci,di},betas{ci,di,ri},'k.')
%                 end
%                 plot(rts{ci,di},RTBetaIntC(ci,ri)+RTBetaSlopeC(ci,ri)*rts{ci,di},'r')
%                 axis([xmin xmax ymin ymax]);
%                 axis square
%             end
%         pFile = [sub '_RTBetaDistC_ROI' int2str(ri)];
%         print('-depsc2', [fig_dir pFile])

%     %         To plot individual distances collapsed across coherence
%             for di = 1:dist
%                 subplot(1,5,di); hold on
%                 for ci = 1:cohs
%                     plot(rts{ci,di},betas{ci,di,ri},'k.')
%                 end
%                 plot(rts{ci,di},RTBetaIntD(ci,ri)+RTBetaSlopeD(ci,ri)*rts{ci,di},'r')
%                 axis([xmin xmax ymin ymax]);
%                 axis square
%             end
%         
%             pFile = [sub '_RTBetaDistD_ROI' int2str(ROI(ri))];
%             print('-depsc2', [fig_dir pFile])
        end         
    end
end