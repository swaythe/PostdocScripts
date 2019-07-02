%FIGSKEL Basic skeleton for Matlab figures

% Emilio Salinas, December 2001

 Nfigs = 1;
 % dimensions of all plots
 hcurve = 0.18;
 vcurve = 0.18;
 hspace1 = 0.035;
 vspace1 = 0.045;
 lmargin = 0.1;
 tmargin = 0.05;
 col1 = lmargin; % + 0.05;
 col2 = col1 + hcurve + hspace1 + 0.02;
 row1 = 1 - tmargin - vcurve + 0.015;
 % positions of all axes
 pos = zeros(Nfigs,4);
 pos(1,:)  = [col1 row1 hcurve vcurve];
%  pos(2,:)  = [col2 row1 hcurve vcurve];

 % lines, symbols and fonts
 fnt0 = 5;
 fnt1 = 7;       % for axis tickmarks
 fnt2 = 8.5;       % for axis label
 fnt3 = 9.5;      % panel indicators
 line1 = 1;    % linewidth for axes
 line2 = 1.5;    % linewidth for trace plots
 msize2 = 2;
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
 
%  text(col1-0.068,row1+voff1,'\bfa','Fontsize',fnt2,'HorizontalAlignment','Left');
%  text(col2-hoff1,row1+voff1,'\bfb','Fontsize',fnt2,'HorizontalAlignment','Left');

 % produce all axes
 %  gap = [20, 40, 70, 100, 130, 160, 600];
 x1tick = -3:3.5:27;
 x1ticklab = [' 0';' 3'; ' 6'; ' 9';'12'; '15'; '18'; '21'; '24'];
 y1tick    = 0.4:0.1:1;
 y1ticklab = ['0.4';'0.5';'0.6';'0.7';'0.8';'0.9';'  1'];
 
 ah = zeros(Nfigs,1);
 for j=1:Nfigs
     ah(j) = axes('Position', pos(j,:), 'Fontsize', fnt2, 'Box', 'off', ...
                  'TickDir','out', 'Visible', 'on');
     tlen = get(ah(j),'ticklength');
     set(ah(j),'Linewidth', line1,'TickLength',tickfac*tlen,'Clipping','off');
     if j==1 
         set(ah(j),'Xtick',x1tick);
         set(ah(j),'XtickLabel',x1ticklab);
     else
         set(ah(j),'Xtick',x2tick);
         set(ah(j),'XtickLabel',x2ticklab);
     end     
     set(ah(j),'Ytick',y1tick);
     set(ah(j),'YtickLabel',y1ticklab);
 end
 
 % graph parameters
 xx1 = -3:3.5:27;
 x1lo = -3;
 x1hi = 27;
 ylo = 0.4;
 yhi = 1.01;
 
 c = [1 0 0];
 
 cd('/Users/kayserlab/Documents/DotsSS/Scripts/Categorization/')
 analyzeCategory;
 ct = ct1 + ct2;
 it = it1 + it2;
 pc = ct./(ct+it);
 
 %
 % Panel a
 %
 axes(ah(1)), hold on;
 plot(xx1,pc,'o','color',c,'MarkerSize',msize2,'Linewidth', line2,'LineStyle','-');
 
 axis([x1lo,x1hi,ylo,yhi])
 xlabel('Distance from boundary (deg)','Fontsize',fnt3,'HorizontalAlignment','Center','VerticalAlignment','Top')
 ylabel('Fraction correct','Fontsize',fnt3,'VerticalAlignment','bottom')

 print -depsc '/Users/kayserlab/Documents/DotsSS/Scripts/Categorization/prelimPrecision.eps'
  
