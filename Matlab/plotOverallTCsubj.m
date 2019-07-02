roi_common = 'Anova005unc';

% subs = {'Sub01'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

main_dir = '/home/sshankar/Categorization/Data/Imaging/';

for si = 1:length(subs)
    sub = subs{si};
    tc_dir = [main_dir '/' sub '/Session_' int2str(baseSess(si)) '/GLM_TC/'];
    op_dir = [tc_dir 'Figures/'];

    cd(tc_dir)
    % Load timecourse file
    tc_file = [sub '_' roi_common '_TCAvg'];
    load(tc_file)
    roi_no = 1:size(tcAvg,3);

    cs = [217 219 217; 143 152 143; 78 84 78; 0 0 0]/255;
    ds = [241 225 19; 238 155 33; 240 88 42; 213 30 56; 118 17 19]/255;

    % Set figure axis and other properties
    Nfigs = 2;
    % dimensions of all plots
    hcurve = 0.15;
    vcurve = 0.14;
    hspace1 = 0.035;
    vspace1 = 0.035;
    lmargin = 0.1;
    tmargin = 0.05;
    col1 = lmargin; % + 0.05;
    col2 = col1 + hcurve + hspace1 + 0.02;
    row1 = 1 - tmargin - vcurve + 0.015;
    % positions of all axes
    pos = zeros(Nfigs,4);
    pos(1,:) = [col1 row1 hcurve vcurve];
    pos(2,:) = [col2 row1 hcurve vcurve];

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

    % x1lo = 0;
    % x1hi = 11;
    % xx1 = 0:1.22:11;
    % x1tick = 0:2:11;
    % x1ticklab = ['   0';' 3.6';' 7.2';'10.8';'14.4';'  18'];

    x1lo = 0;
    x1hi = 101;
    xx1 = 0:1.02:101;
    x1tick = 0:10:101;
    x1ticklab = [' 0';' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10'];


    for ri = 1:length(roi_no)
        if ri>=10
            fig_file = [op_dir roi_common int2str(ri) '_overall'];
        else
            fig_file = [op_dir roi_common '0' int2str(ri) '_overall'];
        end

        % Select ROI of interest
        temp = tcAvg(:,:,ri);

        % Set figure properties
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
            set(ah(j),'Xtick',x1tick);
            set(ah(j),'XtickLabel',x1ticklab);
            set(ah(j),'Ytick',[]);
            set(ah(j),'YtickLabel',[]);
        end

        % Plot overall parametric effect of distance
        axes(ah(1)), hold on;
    %     tcm = zeros(5,10);
        tcm = zeros(5,201);
        for di = 1:5
    %         ctrs = (di-1)*4+1:(di-1)*4+4;
            ctrs = (1:5:20) + (di-1);
            tcm(di,:) = nanmean(temp(ctrs,:));
        end

        for di = 1:5
    %         plot(xx1,tcm(di,:),'color',ds(di,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
            plot(xx1,tcm(di,1:100),'color',ds(di,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        end
        y1lo = nanmin(nanmin(tcm))-0.5;
        y1hi = nanmax(nanmax(tcm))+0.5;

        xlabel('Time from stimulus start (s)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
        ylabel('BOLD (a.u.)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Middle')

        if ~isnan(y1lo)
            axis([x1lo,x1hi,y1lo,y1hi])
        end

        % Plot overall parametric effect of coherence
        axes(ah(2)), hold on;
    %     tcm = zeros(4,10);
        tcm = zeros(4,201);
        for ci = 1:4
    %         ctrs = (1:4:20) + (ci-1);
            ctrs = (ci-1)*5+1:(ci-1)*5+5;
            tcm(ci,:) = nanmean(temp(ctrs,:));
        end
        y1lo = nanmin(nanmin(tcm))-0.5;
        y1hi = nanmax(nanmax(tcm))+0.5;

        for ci = 1:4
    %         plot(xx1,tcm(ci,:),'color',cs(ci,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
            plot(xx1,tcm(ci,1:100),'color',cs(ci,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        end

        if ~isnan(y1lo)
            axis([x1lo,x1hi,y1lo,y1hi])
        end
        xlabel('Time from stimulus start (s)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
        ylabel('BOLD (a.u.)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Middle')

        print('-depsc', fig_file)
    end
end