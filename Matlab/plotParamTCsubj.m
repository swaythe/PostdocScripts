roi_common = 'Anova005unc';
folder_prefix = '_ParamSplit';

% subs = {'Sub06'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
main_dir = '/home/sshankar/Categorization/Data/Imaging/';

cs = [217 219 217; 143 152 143; 78 84 78; 0 0 0]/255;
ds = [241 225 19; 238 155 33; 240 88 42; 213 30 56; 118 17 19]/255;

% Set figure axis and other properties
Nfigs = 9;
% dimensions of all plots
hcurve = 0.15;
vcurve = 0.14;
hspace1 = 0.015;
vspace1 = 0.015;
lmargin = 0.1;
tmargin = 0.05;
col1 = lmargin; % + 0.05;
col2 = col1 + hcurve + hspace1 + 0.02;
col3 = col2 + hcurve + hspace1 + 0.02;
col4 = col3 + hcurve + hspace1 + 0.02;
col5 = col4 + hcurve + hspace1 + 0.02;
row1 = 1 - tmargin - vcurve + 0.015;
row2 = row1 - tmargin - vcurve - vspace1;
% positions of all axes
pos = zeros(Nfigs,4);
pos(1,:) = [col1 row1 hcurve vcurve];
pos(2,:) = [col2 row1 hcurve vcurve];
pos(3,:) = [col3 row1 hcurve vcurve];
pos(4,:) = [col4 row1 hcurve vcurve];
pos(5,:) = [col1 row2 hcurve vcurve];
pos(6,:) = [col2 row2 hcurve vcurve];
pos(7,:) = [col3 row2 hcurve vcurve];
pos(8,:) = [col4 row2 hcurve vcurve];
pos(9,:) = [col5 row2 hcurve vcurve];

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
y1lo = -0.5;
y1hi = 0.8;
y1tick = y1lo:0.2:y1hi;
y1ticklab = num2str(y1lo);
for i = y1lo+0.2:0.2:y1hi
    y1ticklab = strvcat(y1ticklab,num2str(i));
end

for si = 1:length(subs)
    sub = subs{si};
    tc_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/GLM_TC/'];
    op_dir = [tc_dir 'Figures/'];

    cd(tc_dir)
    % Load timecourse file
    tc_file = [sub '_' roi_common '_TCAvg'];
    load(tc_file)
    roi_no = 1:size(ntcAvg,3);

    for ri = 1:length(roi_no)
        if ri>=10
            fig_file = [op_dir sub '_' roi_common int2str(ri) '_param'];
        else
            fig_file = [op_dir sub '_' roi_common '0' int2str(ri) '_param'];
        end

        % Select roi of interest
        temp = ntcAvg(:,:,ri);

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
            set(ah(j),'Ytick',y1tick);
            set(ah(j),'YtickLabel',y1ticklab);
        end

        % Plot parametric distance as a function of coherence
        for ci = 1:4
            axes(ah(ci)), hold on;
    %         tcs = zeros(5,10);
            tcs = zeros(5,201);
            for di = 1:5
                tcs(di,:) = temp((ci-1)*5+1+(di-1),:);
            end
%             y1lo = min(min(tcs))-0.5;
%             y1hi = max(max(tcs))+0.5;
            for di = 1:5
    %             plot(xx1,tcs(di,:), 'color',ds(di,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
                plot(xx1,tcs(di,1:100), 'color',ds(di,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
            end
            if ~isnan(y1lo)
                axis([x1lo,x1hi,y1lo,y1hi])
            end
            xlabel('Time from stimulus start (s)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
            if ci == 1
                ylabel('BOLD (a.u.)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Middle')
            end
        end
        if ~isnan(y1lo)
            axis([x1lo,x1hi,y1lo,y1hi])
        end

        % Plot parametric coherence as a function of distance
        for di = 1:5
            axes(ah(di+4)), hold on;
    %         tcs = zeros(4,10);
            tcs = zeros(4,201);
            for ci = 1:4
                tcs(ci,:) = temp((ci-1)*5+1+(di-1),:);
            end
%             y1lo = min(min(tcs))-0.5;
%             y1hi = max(max(tcs))+0.5;
            for ci = 1:4
    %             plot(xx1,tcs(ci,:),'color',cs(ci,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
                plot(xx1,tcs(ci,1:100),'color',cs(ci,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
            end
            if ~isnan(y1lo)
                axis([x1lo,x1hi,y1lo,y1hi])
            end
            xlabel('Time from stimulus start (s)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
            if di == 1
                ylabel('BOLD (a.u.)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Middle')
            end
        end

        print('-depsc', fig_file)
    end
end