%FIGSKEL Basic skeleton for Matlab figures

% Emilio Salinas, December 2001

 Nfigs = 1;
 % dimensions of all plots
 hcurve = 0.18;
 vcurve = 0.18;
 hspace1 = 0.035;
 vspace1 = 0.035;
 lmargin = 0.1;
 tmargin = 0.05;
 col1 = lmargin; % + 0.05;
 col2 = col1 + hcurve + hspace1 + 0.02;
 row1 = 1 - tmargin - vcurve + 0.015;
 row2 = row1 - tmargin - vcurve - vspace1;
 % positions of all axes
 pos = zeros(Nfigs,4);
 pos(1,:)  = [col1 row1 hcurve vcurve];
%  pos(2,:)  = [col2 row1 hcurve vcurve];
%  pos(3,:)  = [col1 row2 hcurve vcurve];
%  pos(4,:)  = [col2 row2 hcurve vcurve];
 
 % lines, symbols and fonts
 fnt0 = 6;
 fnt1 = 7;       % for axis tickmarks
 fnt2 = 8.5;       % for axis label
 fnt3 = 10.5;      % panel indicators
 line1 = 1;    % linewidth for axes
 line2 = 2;    % linewidth for trace plots
 msize1 = 1;
 msize2 = 3;
 tickfac = 2;    % factor that enlarges ticklengths
 wzero = 0.0005; % width for ~zero width y axis
 % initialize paper and figure 1
 figure, clf 
 whitebg('white') 
 set(gcf,'color', 'white')
%  asp = 5/4;
 asp = 11/8.5;
 % Use 'Paperorientation' to turn to landscape
 set(gcf,'Units','inches','Position',[0.25 1.5 asp*5 5], ...
         'Paperposition',[0 0 11 8.5], 'Paperorientation', 'Portrait');
 % frame for letter tags
 hoff1= hcurve + 0.005;
 voff1= vcurve + 0.025;
 hframe = axes('Position',[0 0 2 1],'Visible','off');
 
 % graph parameters
 xx1 = 1:4;
 xx2 = 1:5;
 x2lo = 0.5;
 x2hi = 5.5;
 y2lo = 0.6;
 y2hi = 2.6;
 
 cs = zeros(10,3);
 
%  h = 0;
%  s = 0.9;
%  v  = 0.8;
%  cStep = s/10;
%  for ci = 5:-1:1
%      cs(ci,:) = hsv2rgb([h/360 s v]);
%      s = s - cStep;
%      h = h + 12;
%  end
 
 h = 200;
 s  = 1;
 v = 0.8;
 cStep = v/20;
 for ci = 1:1:4
     cs(ci,:) = hsv2rgb([h/360 s v]);
     v = v - cStep;
     h = h + 1;
 end
 
 cd('/home/sshankar/Categorization/Data/Behavior/Scanner/')
 sub = 'Sub01';
 load([sub '/' sub '_RTbyCohDirHigh'])
 
 x1tick = 1:5;
 y2tick = 0.6:0.2:2.6;
 y2ticklab = ['0.6';'0.8';'  1';'1.2';'1.4';'1.6';'1.8';'  2';'2.2';'2.4';'2.6'];
 
 ah = zeros(Nfigs,1);
 for j=1:Nfigs
     ah(j) = axes('Position', pos(j,:), 'Fontsize', fnt2, 'Box', 'off', ...
                  'TickDir','out', 'Visible', 'on');
     tlen = get(ah(j),'ticklength');
     set(ah(j),'Linewidth', line1,'TickLength',tickfac*tlen,'Clipping','off');
     set(ah(j),'Xtick',x1tick);
     set(ah(j),'Ytick',y2tick);
     set(ah(j),'YtickLabel',y2ticklab);
 end

 %
 % Panel a
 %
 % To plot as a function of coherence
 axes(ah(1)), hold on;
 offset = 0;
 plot(xx1,rtmByCoh,'o','color',cs(1,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
 for rti = 1:4
     line([xx1(rti)+offset xx1(rti)+offset],[rtmByCoh(rti)+rtsdByCoh(rti) rtmByCoh(rti)-rtsdByCoh(rti)],'color',cs(1,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
 end
 offset = offset + 0.15;
 plot(xx2+offset,rtmByDir,'o','color',cs(5,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
 for rti = 1:5
     line([xx2(rti)+offset xx2(rti)+offset],[rtmByDir(rti)+rtsdByDir(rti) rtmByDir(rti)-rtsdByDir(rti)],'color',cs(5,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
 end
 
 axis([x2lo,x2hi,y2lo,y2hi])
%  xlabel('Coherence (%)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
 ylabel('Reaction Time (ms)','Fontsize',fnt3,'VerticalAlignment','bottom')
 
 pFile = ['/home/sshankar/Categorization/Figures/' sub '_RTbyCohDirHigh.eps'];
 print('-depsc', pFile)
 