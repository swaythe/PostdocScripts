roi_common = 'Acc';
folder_prefix = '_Acc';
tc_file = '_MEPos_TCAvg';
main_dir = '/home/sshankar/Categorization/Data/';
imaging_dir = 'Imaging/';
behav_dir = 'Behavior/Scanner/';
gpTC_dir = [main_dir imaging_dir 'All/Timecourse_3x3_005unc' folder_prefix '/'];

cd([main_dir behav_dir])
load('PCRankandBinMeanWts');
nBin = size(rankBinWt,1);

allsubs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;
nSub = length(subs);
tc_name = 'GLM_TC';
op_file = [gpTC_dir roi_common 'TC_maskdump'];

for si = 1:nSub
    sub = subs{si};
    subNo = find(strcmp(allsubs,sub)==1);
    rkBin = rankBin(:,:,subNo);
    rkBin = reshape(rkBin',4*5,1);
    
    tc_dir = [main_dir imaging_dir sub '/Session_' int2str(baseSess(si)) '/' tc_name '/'];
    cd(tc_dir);
    load([sub tc_file]);
    
    if si == 1
        mtcs = zeros(nBin,size(tcAvg,2),size(tcAvg,3),nSub);
        sdtcs = zeros(nBin,size(tcAvg,2),size(tcAvg,3),nSub);
        nmtcs = zeros(nBin,size(tcAvg,2),size(tcAvg,3),nSub);
        nsdtcs = zeros(nBin,size(tcAvg,2),size(tcAvg,3),nSub);
    end
    
    for bi = 1:nBin
        idx = find(rkBin==bi);
        mtcs(bi,:,:,si) = squeeze(nanmean(tcAvg(idx,:,:)));
        sdtcs(bi,:,:,si) = nanmean(tcSD(idx,:,:));
        nmtcs(bi,:,:,si) = nanmean(ntcAvg(idx,:,:));
        nsdtcs(bi,:,:,si) = nanmean(ntcSD(idx,:,:));
    end
end

AccMean = squeeze(nanmean(mtcs,4));
AccSD = squeeze(nanmean(sdtcs,4));
nAccMean = squeeze(nanmean(nmtcs,4));
nAccSD = squeeze(nanmean(nsdtcs,4));

save(op_file, 'AccMean', 'AccSD', 'nAccMean', 'nAccSD');
