roi_common = 'AnovaOverlap';
roi_name = 'ROI_3x3_005';
tc_file = ['_' roi_common 'AvgTC'];
figc_postfix = '_ParamCoh';
figd_postfix = '_ParamDir';
csc = 'rgbk';
csd = 'rgbmk';

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
tc_dir = [main_dir 'All/Timecourse_3x3_005/'];

% Plot parametric coherence as a function of distance
load([tc_dir roi_common 'TC.mat'])

% Set figure axis and other properties
Nfigs = 6;
% dimensions of all plots
hcurve = 0.15;
vcurve = 0.12;
hspace1 = 0.035;
vspace1 = 0.035;
lmargin = 0.1;
tmargin = 0.05;
col1 = lmargin; % + 0.05;
col2 = col1 + hcurve + hspace1 + 0.02;
col3 = col2 + hcurve + hspace1 + 0.02;
col4 = col1 + hcurve/2 + hspace1 + 0.02;
col5 = col2 + hcurve/2 + hspace1 + 0.02;
row1 = 1 - tmargin - vcurve + 0.015;
row2 = row1 - tmargin - vcurve - vspace1;
row3 = row2 - tmargin - vcurve - vspace1;
% positions of all axes
pos = zeros(Nfigs,4);
pos(1,:)  = [col1 row1 hcurve vcurve];
pos(2,:)  = [col2 row1 hcurve vcurve];
pos(3,:)  = [col3 row1 hcurve vcurve];
pos(4,:)  = [col4 row2 hcurve vcurve];
pos(5,:)  = [col5 row2 hcurve vcurve];
pos(6,:)  = [col2 row3 hcurve vcurve];

% lines, symbols and fonts
fnt0 = 6;
fnt1 = 7;       % for axis tickmarks
fnt2 = 12;       % for axis label
fnt3 = 10.5;      % panel indicators
line1 = 1;    % linewidth for axes
line2 = 2;    % linewidth for trace plots
msize1 = 1;
msize2 = 3;
tickfac = 2;    % factor that enlarges ticklengths
wzero = 0.0005; % width for ~zero width y axis

x1lo = 0;
x1hi = 11;
x2tick = 0:2:11;
x2ticklab = ['   0';' 3.6';' 7.2';'10.8';'14.4';'  18'];

for ri = 1:nRoi
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
    
    for di = 1:5
        axes(ah(di)), hold on;
        tcs = zeros(4,10);
        for ci = 1:4
            tcs(ci,:) = timecourse((di-1)*4+1+(ci-1),:,ri);
        end
        y1lo = min(min(tcs))-0.0005;
        y1hi = max(max(tcs))+0.0005;
        for ci = 1:4
%            plot(timecourse((di-1)*5+ci,:,ri)/max(timecourse((di-1)*5+ci,:,ri)), cs(ci))
            plot(tcs(ci,:), csc(ci), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        end
        if ~isnan(y1lo)
            axis([x1lo,x1hi,y1lo,y1hi])
        end
    end
    axes(ah(6)), hold on;
    for ci = 1:4
        ctrs = (1:4:20) + (ci-1);
        tcm = nanmean(timecourse(ctrs,:,ri));
        plot(tcm,csc(ci), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
    end
    if ~isnan(y1lo)
        axis([x1lo,x1hi,y1lo,y1hi])
    end
    
    pFile = ['/home/sshankar/Categorization/Figures/' roi_common '_ROI' int2str(ri) figc_postfix '.eps'];
    print('-depsc', pFile)
end

% Plot parametric distance as a function of coherence

% Set figure axis and other properties
Nfigs = 5;

% dimensions of all plots
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
            plot(tcs(di,:), csd(di), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        end
        if ~isnan(y1lo)
            axis([x1lo,x1hi,y1lo,y1hi])
        end
    end
    axes(ah(5)), hold on;
    for di = 1:5
        ctrs = (di-1)*4+1:(di-1)*4+4;
        tcm = nanmean(timecourse(ctrs,:,ri));
        plot(tcm,csd(di), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
    end
    if ~isnan(y1lo)
        axis([x1lo,x1hi,y1lo,y1hi])
    end
    
    pFile = ['/home/sshankar/Categorization/Figures/' roi_common '_ROI' int2str(ri) figd_postfix '.eps'];
    print('-depsc', pFile)
end
