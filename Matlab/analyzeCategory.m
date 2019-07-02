cd('/home/sshankar/Categorization/Data/Behavior/Scanner')
sub = 'Sub11';
fig = 1; % Make figures yes/no?
sv = 1; % Save data yes/no?
data_file = '_behavData';

%% Behavioral parameters

bounds = [45 135];
resp1 = 49;
resp2 = 50;

% dir1 = [20, 45, 70, 90, 110, 135, 160];
% dir2 = [-20, -45, -70, -90, -110, -135, -160];
dir1 = [15, 45, 75, 90, 105, 135, 165];
dir2 = [-15, -45, -75, -90, -105, -135, -165];
% dir1 = [12, 45, 78, 90, 102, 135, 168];
% dir2 = [-12, -45, -78, -90, -102, -135, -168];
% dir1 = [12, 45, 68, 90, 102, 135, 168];
% dir2 = [-12, -45, -68, -90, -102, -135, -168];
% dir1 = [10, 45, 80, 90, 100, 135, 170];
% dir2 = [-10, -45, -80, -90, -100, -135, -170];
% dir1 = [8, 45, 82, 90, 98, 135, 172];
% dir2 = [-8, -45, -82, -90, -98, -135, -172];
dir3 = [0, 180];
% cohs = [0, 3.2, 9, 100];
% cohs = [0, 25, 35, 100];
% cohs = [0, 15, 25, 100];
cohs = [0, 12, 25, 100];
% cohs = [0, 6, 12, 100];
% cohs = [0, 4, 10, 100];

% Figure axis labels
% xdTickLab = [' 0';'15';'45';'78';'90'];
% xcTickLab = ['  0';' 15';' 25';'100'];
xdTickLab = [' 0';'12';'45';'78';'90'];
xcTickLab = ['  0';' 12';' 25';'100'];
% xdTickLab = [' 0';'10';'45';'80';'90'];
% xcTickLab = ['  0';'  6';' 12';'100'];
% xdTickLab = [' 0';' 8';'45';'78';'90'];
% xcTickLab = ['  0';'  4';' 10';'100'];
    
%% Analysis variables

ct = zeros(length(cohs),length(dir1)+1);
it = zeros(length(cohs),length(dir1)+1);
rtsc = cell(length(cohs),length(dir1)+1);
rtsi = cell(length(cohs),length(dir1)+1);

%% Get data from each run for the subject for each session
cd(sub)
sess = dir('Session_*');
for si = 1:length(sess)
    cd(sess(si).name)
    runs = dir('run*');
    for ri = 1:length(runs)
        cd(runs(ri).name);
        d = dir('*.mat');
        for di = 1:length(d)
           load (d(di).name);
        %    load('SS24_cohAll_b45_225')
           sessBound = unique(trialTab(:,5));
           for cohi = 1:length(cohs)
               for diri = 1:length(dir1)
                   idneg = find(trialTab(:,10)-trialTab(:,3)<0);
                   if ~isempty(idneg)
                       sprintf('Session %s, Run %s', sess(si).name, runs(ri).name)
                   end
                   idc = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir1(diri) & trialTab(:,9)==resp1 & (trialTab(:,10)-trialTab(:,3))>0);
                   idi = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir1(diri) & trialTab(:,9)==resp2 & (trialTab(:,10)-trialTab(:,3))>0);
                   ct(cohi, diri) = ct(cohi, diri) + length(idc);
                   it(cohi, diri) = it(cohi, diri) + length(idi);
                   if ~isempty(idc)
                       rtsc{cohi, diri} = [rtsc{cohi, diri}; trialTab(idc,10)-trialTab(idc,3)];
                   end
                   if ~isempty(idi)
                       rtsi{cohi, diri} = [rtsi{cohi, diri}; trialTab(idi,10)-trialTab(idi,3)];
                   end
               end
               for diri = 1:length(dir2)
                   idc = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir2(diri) & trialTab(:,9)==resp2 & (trialTab(:,10)-trialTab(:,3))>0);
                   idi = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir2(diri) & trialTab(:,9)==resp1 & (trialTab(:,10)-trialTab(:,3))>0);
                   ct(cohi, diri) = ct(cohi, diri) + length(idc);
                   it(cohi, diri) = it(cohi, diri) + length(idi);
                   if ~isempty(idc)
                       rtsc{cohi, diri} = [rtsc{cohi, diri}; trialTab(idc,10)-trialTab(idc,3)];
                   end
                   if ~isempty(idi)
                       rtsi{cohi, diri} = [rtsi{cohi, diri}; trialTab(idi,10)-trialTab(idi,3)];
                   end
               end
               for diri = 1:length(dir3)
%                    sprintf('%d %d',cohs(cohi), dir3(diri))
                   ids = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir3(diri) & (trialTab(:,9)==resp1 | trialTab(:,9)==resp2) & (trialTab(:,10)-trialTab(:,3))>0);
                   rs = rand(1,length(ids))>0.5;
                   idc = ids(rs==1);
                   idi = ids(rs==0);
                   ct(cohi, 8) = ct(cohi, 8) + length(idc);
                   it(cohi, 8) = it(cohi, 8) + length(idi);
                   if ~isempty(idc)
                       rtsc{cohi, 8} = [rtsc{cohi, 8}; trialTab(idc,10)-trialTab(idc,3)];
                   end
                   if ~isempty(idi)
                       rtsi{cohi, 8} = [rtsi{cohi, 8}; trialTab(idi,10)-trialTab(idi,3)];
                   end
               end
           end
        end
        cd ..
    end
    cd ..
end

%% RT stuff

rtc_cond = cell(4,5);
rti_cond = cell(4,5);
rts_cond = cell(4,5);
rtm_cond = zeros(4,5);
rtsd_cond = zeros(4,5);
for cohi = 1:length(cohs)
    rtc_cond{cohi,1} = rtsc{cohi,8};
    rtc_cond{cohi,2} = [rtsc{cohi,1}; rtsc{cohi,7}];
    rtc_cond{cohi,3} = [rtsc{cohi,2}; rtsc{cohi,6}];
    rtc_cond{cohi,4} = [rtsc{cohi,3}; rtsc{cohi,5}];
    rtc_cond{cohi,5} = rtsc{cohi,4};
    
    rti_cond{cohi,1} = rtsi{cohi,8};
    rti_cond{cohi,2} = [rtsi{cohi,1}; rtsi{cohi,7}];
    rti_cond{cohi,3} = [rtsi{cohi,2}; rtsi{cohi,6}];
    rti_cond{cohi,4} = [rtsi{cohi,3}; rtsi{cohi,5}];
    rti_cond{cohi,5} = rtsi{cohi,4};
end

for cohi = 1:length(cohs)
    for diri = 1:5
        rts_cond{cohi,diri} = [rtc_cond{cohi,diri}; rti_cond{cohi,diri}];
        rtm_cond(cohi,diri) = mean(rts_cond{cohi,diri});
        rtsd_cond(cohi,diri) = std(rts_cond{cohi,diri});
    end
end

%% Accuracy stuff

pc = ct./(ct+it);
ct_cond = zeros(4,5);
ct_cond(:,1) = ct(:,8);
ct_cond(:,2) = ct(:,1)+ct(:,7);
ct_cond(:,3) = ct(:,2)+ct(:,6);
ct_cond(:,4) = ct(:,3)+ct(:,5);
ct_cond(:,5) = ct(:,4);
it_cond = zeros(4,5);
it_cond(:,1) = it(:,8);
it_cond(:,2) = it(:,1)+it(:,7);
it_cond(:,3) = it(:,2)+it(:,6);
it_cond(:,4) = it(:,3)+it(:,5);
it_cond(:,5) = it(:,4);
pc_cond = ct_cond./(ct_cond+it_cond);

%% Data saving stuff
if sv == 1
    save([sub data_file], 'dir1', 'dir2', 'dir3', 'cohs', 'ct_cond', 'it_cond', 'pc_cond', 'rtc_cond', 'rti_cond', 'rts_cond', 'rtm_cond', 'rtsd_cond'); 
end

%% Figure stuff

if fig == 1
    xdTick = 1:5;
    xcTick = 1:4;
    y1Tick = 0.1:0.1:1;
    y2Tick = 0:0.2:3;
    linewd = 2.5;
    markerSz = 3;
    
    cs = zeros(10,3);
    h = 0;
    s = 0.9;
    v  = 0.8;
    cStep = s/15;
    for ci = 5:-1:1
        cs(ci,:) = hsv2rgb([h/360 s v]);
        s = s - cStep;
        h = h + 10;
    end

    % Plot accuracy for each coherence as a function of distance from
    % boundary
    a = figure;
    a1 = subplot(1,2,1);
    set(a1, 'Xtick',xdTick, 'XtickLabel', xdTickLab)
    set(a1, 'Ytick',y1Tick)
    axis square
    hold on
    plot(a1, pc_cond(1,:), 'o', 'color', cs(1,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    plot(a1, pc_cond(2,:), 'o', 'color', cs(2,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    plot(a1, pc_cond(3,:), 'o', 'color', cs(3,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    plot(a1, pc_cond(4,:), 'o', 'color', cs(4,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    xlabel('Distance from boundary (deg)')
    ylabel('Fraction correct')
%     set(a, 'XtickLabel', xdTickLab) %'Xtick', xdTick, 
    
    % Plot RT mean and std for each coherence as a function of distance from
    % boundary
%     figure
    a2 = subplot(1,2,2);
    set(a2, 'Xtick',xdTick, 'XtickLabel', xdTickLab)
    set(a2, 'Ytick',y2Tick)
    axis square
    hold on
    errorbar(rtm_cond(1,:), rtsd_cond(1,:), 'o', 'color', cs(1,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    errorbar(rtm_cond(2,:), rtsd_cond(2,:), 'o', 'color', cs(2,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    errorbar(rtm_cond(3,:), rtsd_cond(3,:), 'o', 'color', cs(3,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    errorbar(rtm_cond(4,:), rtsd_cond(4,:), 'o', 'color', cs(4,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    xlabel('Distance from boundary (deg)')
    ylabel('RT (s)')
    
    % Plot accuracy for each distance from boundary as a function of
    % coherence
    figure 
    a3 = subplot(1,2,1);
    set(a3, 'Xtick',xcTick, 'XtickLabel', xcTickLab)
    set(a3, 'Ytick',y1Tick)
    axis square
    hold on
    plot(pc_cond(:,1), 'o', 'color', cs(1,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    plot(pc_cond(:,2), 'o', 'color', cs(2,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    plot(pc_cond(:,3), 'o', 'color', cs(3,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    plot(pc_cond(:,4), 'o', 'color', cs(4,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    plot(pc_cond(:,5), 'o', 'color', cs(5,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    xlabel('Coherence (%)')
    ylabel('Fraction correct')
    
    % Plot RT mean and std for each distance from boundary as a function of
    % coherence
%     figure
    a4 = subplot(1,2,2);
    set(a4, 'Xtick',xcTick, 'XtickLabel', xcTickLab)
    set(a4, 'Ytick',y2Tick)
    axis square
    hold on
    errorbar(rtm_cond(:,1), rtsd_cond(:,1), 'o', 'color', cs(1,:), 'MarkerSize',2,'Linewidth', linewd,'LineStyle','-')
    errorbar(rtm_cond(:,2), rtsd_cond(:,2), 'o', 'color', cs(2,:), 'MarkerSize',2,'Linewidth', linewd,'LineStyle','-')
    errorbar(rtm_cond(:,3), rtsd_cond(:,3), 'o', 'color', cs(3,:), 'MarkerSize',2,'Linewidth', linewd,'LineStyle','-')
    errorbar(rtm_cond(:,4), rtsd_cond(:,4), 'o', 'color', cs(4,:), 'MarkerSize',2,'Linewidth', linewd,'LineStyle','-')
    errorbar(rtm_cond(:,5), rtsd_cond(:,5), 'o', 'color', cs(5,:), 'MarkerSize',2,'Linewidth', linewd,'LineStyle','-')
    xlabel('Coherence (%)')
    ylabel('RT (s)')
end
