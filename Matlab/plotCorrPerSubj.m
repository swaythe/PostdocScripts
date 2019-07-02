% subs = {'Sub11'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
nSub = length(subs);

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
bdir_prefix = 'SingleTrial';
roi_common = '';
corr_prefix = ['CorrZval' roi_common];

ROI = [2:8, 10, 11, 13, 15, 18, 24, 26, 27];
fef = 8;
colr = 'rgbmk';
zcCDsum = zeros(4,5,38,38);
subPerRoi = zeros(1,38);

for ri = 1:length(ROI)
    figure
    hold on
end

for si = 1:nSub
    sub = subs{si};
    beta_dir = [main_dir  sub '/Session_' int2str(baseSess(si)) '/' bdir_prefix '/'];
    cd(beta_dir)
    load([sub '_' corr_prefix])
    tmp = cat(5, zcCDsum, zcCD);
    zcCDsum = nansum(tmp, 5);
%     nROI = size(zcC,3);
%     nCoh = size(zcC,1);
%     for ri = 1:nROI
%         if sum(sum(isnan(zcC(:,:,ri))))/nCoh < nROI
%             break
%         end
%     end
%     subPerRoi = subPerRoi + ~isnan(squeeze(ccC(1,:,ri)));
end

% zcCDsum = zcCDsum ./ 9;

for ri = 1:length(ROI)
    for ci = 1:4
        figure(ri)
        for di = 1:5
            plot(ci, zcCDsum(ci,di,fef,ROI(ri)), 'color', colr(di), 'marker', 'o', 'LineStyle', '--')
        end
    end
end
