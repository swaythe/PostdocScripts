cd('/home/sshankar/Categorization/Data/Behavior/Training')
sub = 'Sub11';
fig = 1;

%% Behavioral parameters

bounds = [45 135];
resp1 = 49;
resp2 = 50;

dir1 = [12, 45, 78, 90, 102, 135, 168];
dir2 = [-12, -45, -78, -90, -102, -135, -168];
dir3 = [0, 180];
% cohs = [0, 3.2, 9, 100];
cohs = [0, 6, 12, 25, 100];

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
                   idc = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir1(diri) & trialTab(:,9)==resp1);
                   idi = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir1(diri) & trialTab(:,9)==resp2);
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
                   idc = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir2(diri) & trialTab(:,9)==resp2);
                   idi = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir2(diri) & trialTab(:,9)==resp1);
                   ct(cohi, diri) = ct(cohi, diri) + length(idc);
                   it(cohi, diri) = it(cohi, diri) + length(idi);
                   if ~isempty(idc)
                       rtsc{cohi, diri} = [rtsc{cohi, diri}; trialTab(idc,10)-trialTab(idc,3)];
                   end
                   if ~isempty(idc)
                       rtsi{cohi, diri} = [rtsi{cohi, diri}; trialTab(idi,10)-trialTab(idi,3)];
                   end
               end
               for diri = 1:length(dir3)
%                    sprintf('%d %d',cohs(cohi), dir3(diri))
                   ids = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir3(diri) & (trialTab(:,9)==resp1 | trialTab(:,9)==resp2));
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

nC = length(cohs);
rtc_cond = cell(nC,5);
rti_cond = cell(nC,5);
rts_cond = cell(nC,5);
rtm_cond = zeros(nC,5);
rtsd_cond = zeros(nC,5);
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
ct_cond = zeros(nC,5);
ct_cond(:,1) = ct(:,8);
ct_cond(:,2) = ct(:,1)+ct(:,7);
ct_cond(:,3) = ct(:,2)+ct(:,6);
ct_cond(:,4) = ct(:,3)+ct(:,5);
ct_cond(:,5) = ct(:,4);
it_cond = zeros(nC,5);
it_cond(:,1) = it(:,8);
it_cond(:,2) = it(:,1)+it(:,7);
it_cond(:,3) = it(:,2)+it(:,6);
it_cond(:,4) = it(:,3)+it(:,5);
it_cond(:,5) = it(:,4);
pc_cond = ct_cond./(ct_cond+it_cond);

%% Figure stuff

if fig == 1
    xdTick = 1:5;
    xdTickLab = [' 0';'12';'45';'78';'90'];
    xcTick = 1:nC;
    xcTickLab = ['  0';'  6';' 12';' 25';'100'];
    y1Tick = 0.1:0.1:1;
    y2Tick = 0.6:0.2:2.6;
    linewd = 2.5;
    markerSz = 3;
    
    cs = zeros(10,3);
    h = 0;
    s = 0.9;
    v  = 0.8;
    cStep = s/10;
    for ci = 5:-1:1
        cs(ci,:) = hsv2rgb([h/360 s v]);
        s = s - cStep;
        h = h + 15;
    end

    % Plot accuracy for each coherence as a function of distance from
    % boundary
    a = figure;
    a1 = subplot(1,2,1);
    set(a1, 'Xtick',xdTick, 'XtickLabel', xdTickLab)
    set(a1, 'Ytick',y1Tick)
    axis square
    hold on
    for ri = 1:nC
        plot(pc_cond(ri,:), 'o', 'color', cs(ri,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    end
    xlabel('Distance from boundary (deg)')
    ylabel('Fraction correct')
%     set(a, 'XtickLabel', xdTickLab) %'Xtick', xdTick, 
    
    % Plot RT mean and std for each coherence as a function of distance from
    % boundary
%     figure
    a2 = subplot(1,2,2);
    set(a2, 'Xtick',xdTick, 'XtickLabel', xdTickLab)
%     set(a2, 'Ytick',y2Tick)
    axis square
    hold on
    for ri = 1:nC
        errorbar(rtm_cond(ri,:), rtsd_cond(ri,:), 'o', 'color', cs(ri,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    end
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
    for ci = 1:5
        plot(pc_cond(:,ci), 'o', 'color', cs(ci,:), 'MarkerSize',markerSz,'Linewidth', linewd,'LineStyle','-')
    end
    xlabel('Coherence (%)')
    ylabel('Fraction correct')
    
    % Plot RT mean and std for each distance from boundary as a function of
    % coherence
%     figure
    a4 = subplot(1,2,2);
    set(a4, 'Xtick',xcTick, 'XtickLabel', xcTickLab)
%     set(a4, 'Ytick',y2Tick)
    axis square
    hold on
    for ci = 1:5
        errorbar(rtm_cond(:,ci), rtsd_cond(:,ci), 'o', 'color', cs(ci,:), 'MarkerSize',2,'Linewidth', linewd,'LineStyle','-')
    end
    xlabel('Coherence (%)')
    ylabel('RT (s)')
end
