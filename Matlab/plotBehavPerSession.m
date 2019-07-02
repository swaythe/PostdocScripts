%FIGSKEL Basic skeleton for Matlab figures

% Emilio Salinas, December 2001
 subs = {'Sub01'}; %,'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};

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
 line2 = 2;    % linewidth for trace plots
 msize1 = 1;
 msize2 = 3;
 tickfac = 2;    % factor that enlarges ticklengths
 wzero = 0.0005; % width for ~zero width y axis
 % initialize paper and figure 1

 for si = 1:length(subs)
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
     y1lo = 0.35;
     y1hi = 1.01;
     y2lo = 0.6;
     y2hi = 2.6;

     cs = [217 219 217; 143 152 143; 78 84 78; 0 0 0]/255;
     ds = [241 225 19; 238 155 33; 240 88 42; 213 30 56; 118 17 19]/255;
     x1ticklab = ['  0';' 12';' 25';'100'];
     x2ticklab = [' 0';'15';'45';'75';'90'];

     % produce all axes
     x1tick = -4:36:104;
     %  x1ticklab = ['  0';' 15';' 25';'100'];
     x2tick = -5:25:95;
     %  x2ticklab = [' 0';'15';'45';'75';'90'];
     y1tick = 0.4:0.1:1;
     y1ticklab = [;'0.4';'0.5';'0.6';'0.7';'0.8';'0.9';'  1'];
     y2tick = 0.6:0.2:2.6;
     y2ticklab = ['0.6';'0.8';'  1';'1.2';'1.4';'1.6';'1.8';'  2';'2.2';'2.4';'2.6'];
 
     ah = zeros(Nfigs,1);
     for j=1:Nfigs
         ah(j) = axes('Position', pos(j,:), 'Fontsize', fnt2, 'Box', 'off', ...
                      'TickDir','out', 'Visible', 'on');
         tlen = get(ah(j),'ticklength');
         set(ah(j),'Linewidth', line1,'TickLength',tickfac*tlen,'Clipping','off');
         if j==1 || j==3
             set(ah(j),'Ytick',y1tick);
             set(ah(j),'YtickLabel',y1ticklab);
         else
             set(ah(j),'Ytick',y2tick);
             set(ah(j),'YtickLabel',y2ticklab);
         end 
         if j==3 || j==4
             set(ah(j),'Xtick',x1tick);
             set(ah(j),'XtickLabel',x1ticklab);
         else
             set(ah(j),'Xtick',x2tick);
             set(ah(j),'XtickLabel',x2ticklab);
         end
     end
     
     sub = subs{si};
     cd(['/home/sshankar/Categorization/Data/Behavior/Scanner/' sub])
     sess = dir('Sess*');
     for sessi = 1:length(sess)
         cd(sess(sessi).name)
         load([sub '_behavData'])

         %
         % Panel a
         %
         % To plot as a function of coherence
%          axes(ah(3)), hold on;
%          offset = 0;
%          for pi = 1:5
%              plot(xx1+offset,pc_cond(:,pi), 'o', 'color', ds(pi,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
%              offset = offset + 2.25;
%         %      text(col1+100,pc_cond(4,pi),[num2str(dirs(pi)) ' degs'],'Fontsize',fnt0,'HorizontalAlignment','Left');
%          end
% 
%          axis([x1lo,x1hi,y1lo,y1hi])
%          xlabel('Coherence (%)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
%          ylabel('Fraction correct','Fontsize',fnt3,'VerticalAlignment','bottom')
% 
%          axes(ah(4)), hold on;
%          offset = 0;
%          for pi = 1:5
%              plot(xx1+offset,rtm_cond(:,pi),'o','color',ds(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
%              for rti = 1:length(rtm_cond(:,pi))
%                  line([xx1(rti)+offset xx1(rti)+offset],[rtm_cond(rti,pi)+rtsd_cond(rti,pi) rtm_cond(rti,pi)-rtsd_cond(rti,pi)],'color',ds(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
%              end
%              offset = offset + 2.25;
%         %      text(col1+100,pc_cond(5,pi),[num2str(dirs(pi)) '%'],'Fontsize',fnt0,'HorizontalAlignment','Left');
%          end
% 
%          axis([x1lo,x1hi,y2lo,y2hi])
%          xlabel('Coherence (%)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
%          ylabel('Response time (s)','Fontsize',fnt3,'VerticalAlignment','bottom')
% 
%         %  print -depsc '/home/sshankar/Categorization/Figures/ScanSub02.eps'


        % To plot as a function of category boundary distance
         axes(ah(1)), hold on;
         offset = 0;
         for pi = 1:4
             plot(xx2+offset,pc_cond(pi,:), 'o', 'color', cs(pi,:), 'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-')
             offset = offset + 2.25;
        %      text(col1+100,pc_cond(4,pi),[num2str(dirs(pi)) ' degs'],'Fontsize',fnt0,'HorizontalAlignment','Left');
         end

         axis([x2lo,x2hi,y1lo,y1hi])
         xlabel('Distance from category boundary (^{o})','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
         ylabel('Fraction correct','Fontsize',fnt3,'VerticalAlignment','bottom')

         axes(ah(2)), hold on;
         offset = 0;
         for pi = 1:4
             plot(xx2+offset,rtm_cond(pi,:),'o','color',cs(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
             for rti = 1:length(rtm_cond(pi,:))
                 line([xx2(rti)+offset xx2(rti)+offset],[rtm_cond(pi,rti)+rtsd_cond(pi,rti) rtm_cond(pi,rti)-rtsd_cond(pi,rti)],'color',cs(pi,:),'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
             end
             offset = offset + 2.25;
        %      text(col1+100,pc_cond(5,pi),[num2str(dirs(pi)) '%'],'Fontsize',fnt0,'HorizontalAlignment','Left');
         end

         axis([x2lo,x2hi,y2lo,y2hi])
         xlabel('Distance from category boundary (^{o})','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
         ylabel('Response time (s)','Fontsize',fnt3,'VerticalAlignment','bottom')
         cd ..
     end

%      pFile = ['/home/sshankar/Categorization/Figures/' sub '_behav'];
%      print('-depsc2', pFile)
     cd ..
 end
