roi_common = 'Anova005unc';
folder_prefix = '';
main_dir = '/home/sshankar/Categorization/Data/Imaging/';
tc_dir = [main_dir 'All/Timecourse_3x3_005unc' folder_prefix '/'];
op_dir = [tc_dir 'Figures/'];

tc_postfix = '_maskdump'; %'_full';
cd(tc_dir)
% Load timecourse file
tc_file = [roi_common 'TC' tc_postfix];
load(tc_file)
roi_no = 1:size(nmTC,3);

cs = [217 219 217; 143 152 143; 78 84 78; 0 0 0]/255;
ds = [241 225 19; 238 155 33; 240 88 42; 213 30 56; 118 17 19]/255;

% Set figure axis and other properties
Nfigs = 2;
% dimensions of all plots
hcurve = 0.15;
vcurve = 0.14;
hspace1 = 0.035;
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
line2 = 1.57;    % linewidth for trace plots
msize1 = 1;
msize2 = 4;
tickfac = 2;    % factor that enlarges ticklengths
wzero = 0.0005; % width for ~zero width y axis

xclo = 0;
xchi = 5;
xxc = 1:4;
xctick = 1:4;
xcticklab = ['C1';'C2';'C3';'C4'];
xdlo = 0;
xdhi = 6;
xxd = 1:5;
xdtick = 1:5;
xdticklab = ['D1';'D2';'D3';'D4';'D5'];

for ri = 1:length(roi_no)
    if ri>=10
        fig_file = [op_dir roi_common int2str(ri) tc_postfix '_peak'];
    else
        fig_file = [op_dir roi_common '0' int2str(ri) tc_postfix '_peak'];
    end
    
    % Select roi of interest
    temp = nmTC(:,:,ri);
    tempsd = nsdTC(:,:,ri);

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

    maxTC = zeros(4,5);
    sdTC = zeros(4,5);
    for di = 1:5
        for ci = 1:4
            maxTC(ci,di) = max(temp((ci-1)*5+1+(di-1),1:100));
            if ~isnan(maxTC(ci,di))
                sdTC(ci,di) = tempsd((ci-1)*5+1+(di-1),find(temp((ci-1)*5+1+(di-1),1:100)==maxTC(ci,di),1));
            end
        end
    end
    y1lo = round((min(min(maxTC)) - max(max(sdTC)))*100)/100 - 0.05;
    y1hi = round((max(max(maxTC)) + max(max(sdTC)))*100)/100 + 0.05;
    y1tick = y1lo:0.1:y1hi;
    y1ticklab = num2str(y1lo);
    for i = y1lo+0.1:0.1:y1hi
        y1ticklab = strvcat(y1ticklab,num2str(i));
    end

    ah = zeros(Nfigs,1);
    for j=1:Nfigs
        ah(j) = axes('Position', pos(j,:), 'Fontsize', fnt2, 'Box', 'off', ...
                  'TickDir','out', 'Visible', 'on');
        tlen = get(ah(j),'ticklength');
        set(ah(j),'Linewidth', line1,'TickLength',tickfac*tlen,'Clipping','off');
        if j==1
            set(ah(j),'Xtick',xctick);
            set(ah(j),'XtickLabel',xcticklab);
        else
            set(ah(j),'Xtick',xdtick);
            set(ah(j),'XtickLabel',xdticklab);
        end
        set(ah(j),'Ytick',y1tick);
        set(ah(j),'YtickLabel',y1ticklab);
    end

    % Plot parametric distance as a function of coherence
    axes(ah(1)), hold on;
    offset = 0;
    for di = 1:5
        plot(xxc+offset,maxTC(:,di), 'o', 'color',ds(di,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        for ci = 1:4
            line([xxc(ci)+offset xxc(ci)+offset],[maxTC(ci,di)+sdTC(ci,di) maxTC(ci,di)-sdTC(ci,di)], 'color',ds(di,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        end
        offset = offset + 0.15;
    end
        
    xlabel('Coherence (%)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
    ylabel('Peak BOLD (a.u.)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Middle')
    if ~isnan(y1lo)
        axis([xclo,xchi,y1lo,y1hi])
    end
    
    % Plot parametric distance as a function of distance
    axes(ah(2)), hold on;
    offset = 0;
    for ci = 1:4
        plot(xxd+offset,maxTC(ci,:), 'o', 'color',cs(ci,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        for di = 1:5
            line([xxd(di)+offset xxd(di)+offset],[maxTC(ci,di)+sdTC(ci,di) maxTC(ci,di)-sdTC(ci,di)], 'color',cs(ci,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
        end
        offset = offset + 0.15;
    end
        
    xlabel('Distance from category boundary (^{o})','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
    ylabel('Peak BOLD (a.u.)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Middle')
    if ~isnan(y1lo)
        axis([xdlo,xdhi,y1lo,y1hi])
    end
    
    print('-depsc', fig_file)
end
