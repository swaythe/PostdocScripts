cd('/home/sshankar/Categorization/Data/Behavior/Scanner/');

subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% subs = {'Sub01'};

allRTc = [];
allRTi = [];
RTcQ = zeros(1,4);
RTiQ = zeros(1,4);

for si = 1:length(subs)
    sub = subs{si};
    cd(sub);
    load([sub '_behavData.mat']);
    for ci = 1:4
        for di = 1:5
            allRTc = [allRTc; rtc_cond{ci,di}];
            allRTi = [allRTi; rti_cond{ci,di}];
        end
    end
    RTcQ(2) = median(allRTc);
    RTiQ(2) = median(allRTi);
    lowRT = allRTc(allRTc < RTcQ(2));
    hiRT = allRTc(allRTc >= RTcQ(2));
    RTcQ(1) = median(lowRT);
    RTcQ(3) = median(hiRT);
    RTcQ(4) = max(allRTc);
    lowRT = allRTi(allRTi < RTiQ(2));
    hiRT = allRTi(allRTi >= RTiQ(2));
    RTiQ(1) = median(lowRT);
    RTiQ(3) = median(hiRT);
    RTiQ(4) = max(allRTi);
    save([sub '_RTquartiles'], 'RTcQ', 'RTiQ');
    cd ..
end