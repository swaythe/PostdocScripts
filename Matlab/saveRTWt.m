subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';
cd(main_dir)
ctr = 1;
rtcQ = zeros(4,length(subs));
rtiQ = zeros(4,length(subs));
rtcMean = zeros(4,length(subs));
rtiMean = zeros(4,length(subs));
rtcWt = zeros(4,length(subs));
rtiWt = zeros(4,length(subs));
allRTc = [];
allRTi = [];

for si = 1:length(subs)
    sub = subs{si};    
    cd(sub)
    load([sub '_behavData.mat']);
    for ci = 1:4
        for di = 1:5
            allRTc = [allRTc; rtc_cond{ci,di}];
            allRTi = [allRTi; rti_cond{ci,di}];
        end
    end
    load([sub '_RTquartiles'])
    for i = 1:4
        if i == 1
            rtcMean(i,si) = mean(allRTc(allRTc <= RTcQ(i)));
            rtiMean(i,si) = mean(allRTi(allRTi <= RTiQ(i)));
        else
            rtcMean(i,si) = mean(allRTc(allRTc <= RTcQ(i) & allRTc > RTcQ(i-1)));
            rtiMean(i,si) = mean(allRTi(allRTi <= RTiQ(i) & allRTi > RTiQ(i-1)));
        end
    end
    rt_val = rtcMean(:,si);
    m = mean(rt_val);
    mult = sqrt(sum((rt_val-m).^2));
    rtreg = (rt_val-m)./mult;
    rtcWt(:,si) = rtreg;
    
    rt_val = rtiMean(:,si);
    m = mean(rt_val);
    mult = sqrt(sum((rt_val-m).^2));
    rtreg = (rt_val-m)./mult;
    rtiWt(:,si) = rtreg;
    
    rtcQ(:,si) = RTcQ;
    rtiQ(:,si) = RTiQ;
    cd ..
end

save('rtWts', 'rtcQ', 'rtiQ', 'rtcMean', 'rtiMean', 'rtcWt', 'rtiWt');
