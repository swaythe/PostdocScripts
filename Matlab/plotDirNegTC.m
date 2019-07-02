subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
baseSess = [1 1 1 2 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;
nSub = length(subs);
roi_common = 'DirNeg';
roi_name = 'ROI_3x3_005';
tc_file = ['_' roi_common 'AvgTC_full'];
fig_postfix = '_full005';
cs = 'rgbmk';

main_dir = '/home/sshankar/Categorization/Data/Imaging/';

% % To plot each subject's timecourse separately
% for si = 1:nSub
%     sub = subs{si};
%     roi_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' roi_name '/'];
%     cd(roi_dir);
%     load([sub '_' roi_common 'Coord']);
%     nRoi = size(top_vox,1);
%     load([sub tc_file]);
%     
%     for ri = 1:nRoi
%         figure(ri)
%         hold on
%         for ci = 1:4
%             subplot(nSub,5,(si-1)*5+ci)
%             hold on
%             for di = 1:5
% %                plot(timecourse((ci-1)*5+di,:,ri)/max(timecourse((ci-1)*5+di,:,ri)), cs(di))
%                 plot(timecourse((ci-1)*5+di,:,ri), cs(di))
%             end
%         end
%         subplot(nSub,5,5*si)
%         hold on
%         for di = 1:5
%             ctrs = di:5:20;
%             tcm = nanmean(timecourse(ctrs,:,ri));
%             plot(tcm/max(tcm),cs(di))
%         end
%     end
% end


% To plot all subjects' timecourse data collapsed


for si = 1:nSub
    sub = subs{si};
    roi_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' roi_name '/'];
    cd(roi_dir);
    load([sub '_' roi_common 'Coord']);
    if si == 1
        tcs = zeros(20,10,size(top_vox,1),nSub);
    end
    nRoi = size(top_vox,1);
    load([sub tc_file]);
    tcs(:,:,:,si) = timecourse_norm;
end

% Find the mean timecourse across all subjects
timecourse = nanmean(tcs,4);

% Set figure axis and other properties
Nfigs = 5;
% dimensions of all plots
hcurve = 0.28;
vcurve = 0.25;
hspace1 = 0.035;
vspace1 = 0.035;
lmargin = 0.1;
tmargin = 0.05;
col1 = lmargin; % + 0.05;
col2 = col1 + hcurve + hspace1 + 0.02;
col3 = col1 + hcurve/2 + hspace1 + 0.02;
row1 = 1 - tmargin - vcurve + 0.015;
row2 = row1 - tmargin - vcurve - vspace1;
row3 = row2 - tmargin - vcurve - vspace1;
% positions of all axes
pos = zeros(Nfigs,4);
pos(1,:)  = [col1 row1 hcurve vcurve];
pos(2,:)  = [col2 row1 hcurve vcurve];
pos(3,:)  = [col1 row2 hcurve vcurve];
pos(4,:)  = [col2 row2 hcurve vcurve];
pos(5,:)  = [col3 row3 hcurve vcurve];

% lines, symbols and fonts
fnt0 = 6;
fnt1 = 7;       % for axis tickmarks
fnt2 = 15;       % for axis label
fnt3 = 10.5;      % panel indicators
line1 = 1;    % linewidth for axes
line2 = 2;    % linewidth for trace plots
msize1 = 1;
msize2 = 3;
tickfac = 2;    % factor that enlarges ticklengths
wzero = 0.0005; % width for ~zero width y axis

% frame for letter tags
hoff1= hcurve + 0.005;
voff1= vcurve + 0.025;

x1lo = 0;
x1hi = 11;
x2tick = 0:2:11;
x2ticklab = ['   0';' 3.6';' 7.2';'10.8';'14.4';'  18'];

% Plot the figures
for ri = 1:nRoi
    % initialize paper and figure
    figure, clf 
    whitebg('white') 
    set(gcf,'color', 'white')
    %  asp = 5/4;
    asp = 11/8.5;
    % Use 'Paperorientation' to turn to landscape
    set(gcf,'Units','inches','Position',[0.25 1.5 asp*5 5], ...
         'Paperposition',[0 0 11 8.5], 'Paperorientation', 'Portrait');
    hframe = axes('Position',[0 0 2 1],'Visible','off');

    ah = zeros(Nfigs,1);
    for j=1:Nfigs
        ah(j) = axes('Position', pos(j,:), 'Fontsize', fnt2, 'Box', 'off', ...
                  'TickDir','out', 'Visible', 'on');
        tlen = get(ah(j),'ticklength');
        set(ah(j),'Linewidth', line1,'TickLength',tickfac*tlen,'Clipping','off');
        set(ah(j),'Xtick',x2tick);
        set(ah(j),'XtickLabel',x2ticklab);
    end
    
    for ci = 1:4
        axes(ah(ci)), hold on;
        tcs = zeros(5,10);
        for di = 1:5
            tcs(di,:) = timecourse((di-1)*4+1+(ci-1),:,ri);
        end
        y1lo = min(min(tcs))-0.0005;
        y1hi = max(max(tcs))+0.0005;
        for di = 1:5
%            plot(timecourse((di-1)*5+ci,:,ri)/max(timecourse((di-1)*5+ci,:,ri)), cs(ci))
            plot(tcs(di,:), cs(di), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        end
        axis([x1lo,x1hi,y1lo,y1hi])
    end
    axes(ah(5)), hold on;
    for di = 1:5
        ctrs = (di-1)*4+1:(di-1)*4+4;
        tcm = nanmean(timecourse(ctrs,:,ri));
        plot(tcm,cs(di), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
    end
    axis([x1lo,x1hi,y1lo,y1hi])
    
    pFile = ['/home/sshankar/Categorization/Figures/' roi_common '_ROI' int2str(ri) fig_postfix '.eps'];
    print('-depsc', pFile)
end
