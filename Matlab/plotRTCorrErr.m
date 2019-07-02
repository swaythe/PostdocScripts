%FIGSKEL Basic skeleton for Matlab figures

% Emilio Salinas, December 2001

 Nfigs = 2;
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
 pos(2,:)  = [col2 row1 hcurve vcurve];
 pos(3,:)  = [col1 row2 hcurve vcurve];
 pos(4,:)  = [col2 row2 hcurve vcurve];
 
 % lines, symbols and fonts
 fnt0 = 6;
 fnt1 = 7;       % for axis tickmarks
 fnt2 = 8.5;       % for axis label
 fnt3 = 10.5;      % panel indicators
 line1 = 1;    % linewidth for axes
 line2 = 1;    % linewidth for trace plots
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
 xx1 = -4:36:104;
 x1lo = -5;
 x1hi = 116;
 xx2 = -5:25:95;
 x2lo = -6;
 x2hi = 115;
 y1lo = 0.5;
 y1hi = 2.3;
  
 cs = [217 219 217; 143 152 143; 78 84 78; 0 0 0]/255;
 ds = [241 225 19; 238 155 33; 240 88 42; 213 30 56; 118 17 19]/255;
 
 cd('/home/sshankar/Categorization/Data/Behavior/Scanner/')
%  sub = 'Sub11';
%  load([sub '/' sub '_behavData'])
% 
%  x1ticklab = ['  0';' 12';' 25';'100'];
%  x2ticklab = [' 0';'15';'45';'75';'90'];
 
 sub = 'All';
 load([sub '_behavData'])
 
 x1ticklab = ['Coh1';'Coh2';'Coh3';'Coh4'];
 x2ticklab = ['Dir1';'Dir2';'Dir3';'Dir4';'Dir5'];
 
  % produce all axes
 x1tick = -4:36:104;
 x2tick = -5:25:95;
 y1tick = 0.5:0.2:2.3;
 y1ticklab = ['0.5';'0.7';'0.9';'1.1';'1.3';'1.5';'1.7';'1.9';'2.1';'2.3'];
 
 ah = zeros(Nfigs,1);
 for j=1:Nfigs
     ah(j) = axes('Position', pos(j,:), 'Fontsize', fnt2, 'Box', 'off', ...
                  'TickDir','out', 'Visible', 'on');
     tlen = get(ah(j),'ticklength');
     set(ah(j),'Linewidth', line1,'TickLength',tickfac*tlen,'Clipping','off');
     set(ah(j),'Ytick',y1tick);
     set(ah(j),'YtickLabel',y1ticklab);
     if j==2
         set(ah(j),'Xtick',x1tick);
         set(ah(j),'XtickLabel',x1ticklab);
     else
         set(ah(j),'Xtick',x2tick);
         set(ah(j),'XtickLabel',x2ticklab);
     end
 end

 %
 % Panel a
 %
 % To plot as a function of coherence
 axes(ah(2)), hold on;
 offset = 0;
 do = 1.5;
 for pi = 1:5
     plot(xx1+offset,rtcm_cond(:,pi),'o','color',ds(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
     plot(xx1+offset+do,rtim_cond(:,pi),'o','color',ds(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','--');
     for rti = 1:length(rtcm_cond(:,pi))
         line([xx1(rti)+offset xx1(rti)+offset],[rtcm_cond(rti,pi)+rtcsd_cond(rti,pi) rtcm_cond(rti,pi)-rtcsd_cond(rti,pi)],'color',ds(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
         line([xx1(rti)+offset+do xx1(rti)+offset+do],[rtim_cond(rti,pi)+rtisd_cond(rti,pi) rtim_cond(rti,pi)-rtisd_cond(rti,pi)],'color',ds(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','--');
     end
     offset = offset + 4; %2.25;
%      text(col1+100,pc_cond(5,pi),[num2str(dirs(pi)) '%'],'Fontsize',fnt0,'HorizontalAlignment','Left');
 end
 
 axis([x1lo,x1hi,y1lo,y1hi])
 xlabel('Coherence (%)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
 ylabel('Response time (s)','Fontsize',fnt3,'VerticalAlignment','bottom')

% To plot as a function of category boundary distance
 axes(ah(1)), hold on;
 offset = 0;
 for pi = 1:4
     plot(xx2+offset,rtcm_cond(pi,:),'o','color',cs(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
     plot(xx2+offset+do,rtim_cond(pi,:),'o','color',cs(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','--');
     for rti = 1:length(rtcm_cond(pi,:))
         line([xx2(rti)+offset xx2(rti)+offset],[rtcm_cond(pi,rti)+rtcsd_cond(pi,rti) rtcm_cond(pi,rti)-rtcsd_cond(pi,rti)],'color',cs(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
         line([xx2(rti)+offset+do xx2(rti)+offset+do],[rtim_cond(pi,rti)+rtisd_cond(pi,rti) rtim_cond(pi,rti)-rtisd_cond(pi,rti)],'color',cs(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','--');
     end
     offset = offset + 4; %2.25;
%      text(col1+100,pc_cond(5,pi),[num2str(dirs(pi)) '%'],'Fontsize',fnt0,'HorizontalAlignment','Left');
 end
 
 axis([x2lo,x2hi,y1lo,y1hi])
 xlabel('Distance from category boundary (^{o})','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
 ylabel('Response time (s)','Fontsize',fnt3,'VerticalAlignment','bottom')

 pFile = ['/home/sshankar/Categorization/Figures/' sub '_RTsCE'];
 print('-depsc2', pFile)
 