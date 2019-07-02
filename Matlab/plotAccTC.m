main_dir = '/home/sshankar/Categorization/Data/Imaging/All/Timecourse_3x3_005unc_Acc';
cd(main_dir)
load('AccTC_maskdump')

rois = 1:42;
nBin = 4;
c = 'rgbk';

for ri = rois
    figure, hold on
    for bi = 1:nBin
        plot(nAccMean(bi,1:100,ri),c(bi))
    end
end