% subs = {'Sub01'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

main_dir = '/home/sshankar/Categorization/Data/Imaging/All/SingleTrial/';
fig_dir = [main_dir 'RTBetaFigures/'];
beta_prefix = 'RTBetaParam';
cd(main_dir)
load(beta_prefix)

symb = {'ro','bo','co','mo','ko','rd','bd','md','kd'};
ROI = [2,3,5,6,7,8,11,15,18,27];
% ROI = 2;
roi_name = {'R SPL','L SPL','R Mid. Occ. G','L IPL','R Supramarginal G','L SFG','R SFG','L IT','R IT','L Insula'};
nROI = length(ROI);
nCoh = size(RTBIntCD,1);
nDist = size(RTBIntCD,2);
  
maxR = ones(1,nROI);
minR = zeros(1,nROI);
for ri = 1:nROI
    minR(ri) = min(min(min(squeeze(RTBIntCD(:,:,ri,:)))));
    maxR(ri) = max(max(max(squeeze(RTBIntCD(:,:,ri,:)))));
    maxR(maxR==0) = 1;
end

% % To plor CD figures
% for si = 1:length(subs)
%     for ri = 1:nROI
%         figure(ri)
%         hold on
%         ctr = 1;
%         for ci = 1:nCoh
%             for di = 1:nDist
%                 subplot(nCoh,nDist,ctr); hold on
%                 plot(RTBIntCD(ci,di,ri,si), symb{si})
%                 axis([0 2 minR(ri) maxR(ri)])
%                 ctr = ctr + 1;
%             end
%         end
%     end
% end

% % To plot C figures
% for si = 1:length(subs)
%     for ri = 1:nROI
%         figure(ri)
%         hold on
%         for ci = 1:nCoh
%             subplot(3,nCoh,ci); hold on
%             plot(RTBIntC(ci,ri,si), symb{si})
%             if si==9
%                 if ci==2
%                     title(roi_name{ri})
%                 elseif ci==1
%                     ylabel('All')
%                 end
%             end
%             axis([0 2 minR(ri) maxR(ri)])
%             subplot(3,nCoh,ci+nCoh); hold on
%             plot(RTcBIntC(ci,ri,si), symb{si})
%             if si==9 && ci==1
%                 ylabel('Correct')
%             end
%             axis([0 2 minR(ri) maxR(ri)])
%             subplot(3,nCoh,ci+nCoh*2); hold on
%             plot(RTiBIntC(ci,ri,si), symb{si})
%             if si==9 && ci==1
%                 ylabel('Incorrect')
%             end
%             axis([0 2 minR(ri) maxR(ri)])
%         end
%     end
% end

% To plot D figures
for si = 1:length(subs)
    for ri = 1:nROI
        figure(ri)
        hold on
        for di = 1:nDist
            subplot(3,nDist,di); hold on
            plot(RTBIntD(di,ri,si), symb{si})
            if si==9
                if di==3
                    title(roi_name{ri})
                elseif di==1
                    ylabel('All')
                end
            end
            axis([0 2 minR(ri) maxR(ri)])
            subplot(3,nDist,di+nDist); hold on
            plot(RTcBIntD(di,ri,si), symb{si})
            if si==9 && di==1
                ylabel('Correct')
            end
            axis([0 2 minR(ri) maxR(ri)])
            subplot(3,nDist,di+nDist*2); hold on
            plot(RTiBIntD(di,ri,si), symb{si})
            if si==9 && di==1
                ylabel('Incorrect')
            end
            axis([0 2 minR(ri) maxR(ri)])
        end
    end
end

for ri = 1:nROI
    figure(ri)
    pFile = ['IntD_' int2str(ROI(ri))];
    print('-depsc2', [fig_dir pFile])
end