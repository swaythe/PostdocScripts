subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

roi_base = 'ROI_3x3_005unc';
roi_common = 'Anova005unc';
tc_file = ['_' roi_common 'TCGranger_all.mat'];

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
cs = {'ro-','go-','bo-','ko-','mo-','co-','yo-','rd-','gd-','bd-','kd-','md-','cd-','yd-','r.-','g.-','b.-','k.-'};

roi = 2;

for subi = 1:length(subs)
    sub = subs{subi};
    roi_dir = [main_dir sub '/Session_' int2str(baseSess(subi)) '/' roi_base '/'];
    cd(roi_dir)
    load([sub tc_file])
    miny = 9999;
    figure
    hold on
    if timecourse(1,1,roi) ~= 0
        for ei = 1:18
            if min(timecourse(:,ei,roi)) ~= 0 && min(timecourse(:,ei,roi)) < miny
                miny = min(timecourse(:,ei,roi));
            end
            plot(timecourse(:,ei,roi),cs{ei})
        end
        maxy = nanmax(nanmax(timecourse(:,:,roi)));
    else
        miny = 0;
        maxy = 1;
    end
    axis([0 300 miny maxy])
end