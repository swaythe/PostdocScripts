roi_common = 'Anova005unc';

% subs = {'Sub02'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
main_dir = '/home/sshankar/Categorization/Data/Imaging/';
tc_postfix = '_PeakTCval';
corr_postfix = '_CorrZval';
fef = 8;
op_prefix = ['_Corr' int2str(fef) 'Peak'];

cs = [217 219 217; 143 152 143; 78 84 78; 0 0 0]/255;
ds = [241 225 19; 238 155 33; 240 88 42; 213 30 56; 118 17 19]/255;

for si = 1:length(subs)
    sub = subs{si};
    sub_dir = [main_dir '/' sub '/Session_' int2str(baseSess(si))];
    ip_dir = [sub_dir '/SingleTrial/'];
    op_dir = [sub_dir '/ROI_3x3_005unc/Figures/'];

    cd(ip_dir)
    % Load correlation and timecourse peak files
    tc_file = [sub tc_postfix];
    corr_file = [sub corr_postfix];
    
    load(tc_file)
    load(corr_file)
    nROI = size(tcPeak,3);
    
    for ri = 1:nROI
        if ri<10
            op_file = [op_prefix '_0' int2str(ri)];
        else
            op_file = [op_prefix '_' int2str(ri)];
        end
        
        figure
        subplot(2,2,1)
%         axis square
        hold on
        for di = 1:5
            plot(1:4, zcCD(:,di,ri,fef), 'color', ds(di,:), 'Linewidth', 1.5, 'LineStyle', '-')
        end
        title('Correlation with L. FEF (z-value)')
        xlabel('Coherence')
        subplot(2,2,2)
%         axis square
        hold on
        for di = 1:5
            plot(1:4, tcPeak(:,di,ri), 'color', ds(di,:), 'Linewidth', 1.5, 'LineStyle', '-')
        end
        title('Peak timecourse amplitude')
        xlabel('Coherence')
        subplot(2,2,3)
%         axis square
        hold on
        for ci = 1:4
            plot(1:5, zcCD(ci,:,ri,fef), 'color', cs(ci,:), 'Linewidth', 1.5, 'LineStyle', '-')
        end
        xlabel('Distance from boundary')
        subplot(2,2,4)
%         axis square
        hold on
        for ci = 1:4
            plot(1:5, tcPeak(ci,:,ri), 'color', cs(ci,:), 'Linewidth', 1.5, 'LineStyle', '-')
        end
        xlabel('Distance from boundary')
        
        print('-depsc', [op_dir sub op_file])
    end
end