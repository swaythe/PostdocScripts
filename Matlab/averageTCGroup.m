roi_common = 'AnovaRoiCorr_bigROI';
main_dir = '/home/sshankar/Categorization/Data/Imaging/';
gpTC_dir = [main_dir 'All/Timecourse_AnovaCorr_005unc_bigROI/'];

subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;
nSub = length(subs);
tc_name = 'GLM_TC';
tc_file = ['_' roi_common '_TCCorrAvg'];
op_file = [gpTC_dir roi_common 'TC_maskdump'];

for si = 1:nSub
    sub = subs{si};
    tc_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' tc_name '/'];
    cd(tc_dir);
    load([sub tc_file]);
    if si == 1
        mtcs = zeros(size(tcAvg,1),size(tcAvg,2),size(tcAvg,3),nSub);
        nmtcs = zeros(size(tcAvg,1),size(tcAvg,2),size(tcAvg,3),nSub);
        sdtcs = zeros(size(tcAvg,1),size(tcAvg,2),size(tcAvg,3),nSub);
        nsdtcs = zeros(size(tcAvg,1),size(tcAvg,2),size(tcAvg,3),nSub);
    end
    mtcs(:,:,:,si) = tcAvg;
    nmtcs(:,:,:,si) = ntcAvg;
    sdtcs(:,:,:,si) = tcSD;
    nsdtcs(:,:,:,si) = ntcSD;
end

% Find the mean timecourse across all subjects
mTC = nanmean(mtcs,4);
nmTC = nanmean(nmtcs,4);
sdTC = squeeze(sqrt(nansum(sdtcs.*sdtcs,4)));
nsdTC = squeeze(sqrt(nansum(nsdtcs.*nsdtcs,4)));

save(op_file, 'mTC', 'nmTC', 'sdTC', 'nsdTC')
