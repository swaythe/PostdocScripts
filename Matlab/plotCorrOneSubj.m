subs = {'Sub11'};
baseSess = 1;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
nSub = length(subs);

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
bdir_prefix = 'SingleTrial';
roi_common = '';
corr_prefix = ['CorrZval' roi_common];

ROI = [2:8, 10, 11, 13, 15, 18, 24, 26, 27];
roi = 2;
colr = 'rgbmk';
zcCDsum = zeros(4,5,38,38);
subPerRoi = zeros(1,38);

figure
hold on
plot(ccCD(1,:,roi,18), 'ro-')
plot(ccCD(2,:,roi,18), 'go-')
plot(ccCD(3,:,roi,18), 'bo-')
plot(ccCD(4,:,roi,18), 'ko-')

figure
hold on
plot(zcCD(:,1,roi,18), 'ro-')
plot(zcCD(:,2,roi,18), 'go-')
plot(zcCD(:,3,roi,18), 'bo-')
plot(zcCD(:,4,roi,18), 'mo-')
plot(zcCD(:,5,roi,18), 'ko-')

figure; hold on
for i = 1:5
    plot(i,mean(betac{1,i,roi}), 'ro')
end
for i = 1:5
    plot(i,mean(betac{2,i,roi}), 'go')
end
for i = 1:5
    plot(i,mean(betac{3,i,roi}), 'bo')
end
for i = 1:5
    plot(i,mean(betac{4,i,roi}), 'ko')
end

figure; hold on
for i = 1:4
    plot(i,mean(betac{i,1,roi}), 'ro')
end
for i = 1:4
    plot(i,mean(betac{i,2,roi}), 'go')
end
for i = 1:4
    plot(i,mean(betac{i,3,roi}), 'bo')
end
for i = 1:4
    plot(i,mean(betac{i,4,roi}), 'mo')
end
for i = 1:4
    plot(i,mean(betac{i,5,roi}), 'ko')
end

