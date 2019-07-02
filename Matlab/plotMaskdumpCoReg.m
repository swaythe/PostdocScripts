sub = 'Sub02';
baseSess = 1;
cd(['~/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess) '/GLM_TC/'])
load([sub '_MECorr_TCCorrAvg'])
load([sub '_MECorrAvgTC_CoReg'])
ri = 9;

temp1 = ntcAvg(:,:,ri);
tcm1 = zeros(5,201);
temp2 = timecourse_norm(:,:,ri);
tcm2 = zeros(5,10);
temp3 = timecourse(:,:,ri);
tcm3 = zeros(5,10);

for di = 1:5
    ctrs = (1:5:20) + (di-1);
    tcm1(di,:) = nanmean(temp1(ctrs,:));
    tcm2(di,:) = nanmean(temp2(ctrs,:));
    tcm3(di,:) = nanmean(temp3(ctrs,:));
end

cs = 'rgbmk';
figure
subplot(1,3,1); hold on
for i = 1:5
    plot(tcm1(i,:),cs(i))
end
subplot(1,3,2); hold on
for i = 1:5
    plot(tcm2(i,:),cs(i))
end
subplot(1,3,3); hold on
for i = 1:5
    plot(tcm3(i,:),cs(i))
end
