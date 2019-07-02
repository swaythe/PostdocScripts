subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
fig = 0;

main_dir = '/home/sshankar/Categorization/Data/';
im_dir = [main_dir 'Imaging/'];
fig_dir = [im_dir 'All/SingleTrial/RTBetaFigures/'];
roi_dir = [im_dir 'All/ROI_3x3_005unc/'];
roi_var = 'nVoxAnova005uncPositive';
beta_prefix = 'SingleTrial/';

cd(roi_dir)
load('nVox_native')
nROI = size(eval(roi_var),2);
ROI = [2 3 5 6 7 8 11 15 18 27];
slopes = zeros(length(subs),length(ROI));
ints = zeros(length(subs),length(ROI));
slopec = zeros(length(subs),length(ROI));
intc = zeros(length(subs),length(ROI));
slopei = zeros(length(subs),length(ROI));
inti = zeros(length(subs),length(ROI));

minx = 999;
maxx = 0;
miny = 999;
maxy = 0;
for si = 1:length(subs)
    sub = subs{si};
    beta_dir = [im_dir sub '/Session_' int2str(baseSess(si)) '/' beta_prefix];
    
    % Load the beta and RT matrices
    % This loads the following variables into the workspace:
    % betas, betac, betai, rts, rtc, rti
    cd(beta_dir)
    load([sub '_betaMat'])
    if min(cat(1,rts{:,:})) < minx
        minx = min(cat(1,rts{:,:}));
    end
    if max(cat(1,rts{:,:})) > maxx
        maxx = max(cat(1,rts{:,:}));
    end
    if min(cat(1,betas{:,:,:})) < miny
        miny = min(cat(1,betas{:,:,:}));
    end
    if max(cat(1,betas{:,:,:})) > maxy
        maxy = max(cat(1,betas{:,:,:}));
    end
   
    for ri = 1:length(ROI)
        figure(ri), hold on
        subplot(3,3,si), hold on
        temp = robustfit(cat(1,rts{:,5}),cat(1,betas{:,5,ROI(ri)}));
        slopes(si,ri) = temp(2);
        ints(si,ri) = temp(1);
        plot(cat(1,rts{:,5}),cat(1,betas{:,5,ROI(ri)}),'k.')
        plot(cat(1,rts{:,5}),temp(1)+temp(2)*cat(1,rts{:,5}),'r-')
        
        temp = robustfit(cat(1,rtc{:,5}),cat(1,betac{:,5,ROI(ri)}));
        slopec(si,ri) = temp(2);
        intc(si,ri) = temp(1);
        
        temp = robustfit(cat(1,rti{:,5}),cat(1,betai{:,5,ROI(ri)}));
        slopei(si,ri) = temp(2);
        inti(si,ri) = temp(1);
    end
end

for i=1:10
    figure(i)
    for si = 1:9
        subplot(3,3,si)
        axis([minx maxx miny maxy])
        axis square
    end
end

