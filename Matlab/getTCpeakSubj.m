roi_common = 'MECorr';

% subs = {'Sub02'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
main_dir = '/home/sshankar/Categorization/Data/Imaging/';
op_file = [roi_common '_PeakTC'];
op_dir = [main_dir 'All/Timecourse_MECorr_005corr/'];

nSub = length(subs);
load('~/Categorization/Data/Imaging/All/ROI_MECorr_005corr/nVox_MNI.mat')
nROI = length(['nVox_' roi_common]);
tcPeak = zeros(4,5,nROI,nSub);
tcPeakTime = zeros(4,5,nROI,nSub);

for si = 1:nSub
    sub = subs{si};
    sub_dir = [main_dir '/' sub '/Session_' int2str(baseSess(si))];
    tc_dir = [sub_dir '/GLM_TC/'];

    cd(tc_dir)
    % Load timecourse file
    tc_file = [sub '_' roi_common '_TCCorrAvg'];
    load(tc_file)
    nROI = size(ntcAvg,3);

    for ri = 1:nROI
        % Select roi of interest
        temp = ntcAvg(:,:,ri);

        % Calculate peak TC values for selected ROI for each coherence and
        % distance value
        for ci = 1:4
            for di = 1:5
                tcPeak(ci,di,ri,si) = nanmax(temp((ci-1)*5+1+(di-1),1:100));
                if ~isnan(tcPeak(ci,di,ri,si))
                    tcPeakTime(ci,di,ri,si) = find(temp((ci-1)*5+1+(di-1),1:100) == nanmax(temp((ci-1)*5+1+(di-1),1:100)))/10;
                else
                    tcPeakTime(ci,di,ri,si) = NaN;
                end
            end
        end
    end
end
save([op_dir op_file], 'tcPeak', 'tcPeakTime');

