main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/'; 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};

rt11 = zeros(1,9);
rt15 = zeros(1,9);
rt41 = zeros(1,9);
rt45 = zeros(1,9);
rt11_15 = zeros(1,9);
rt11_41 = zeros(1,9);
rt41_45 = zeros(1,9);
rt15_45 = zeros(1,9);
rtstat = zeros(4,2,9);

rts = [];
cs = [];
ds = [];
ss = [];

for si = 1:length(subs)
    load([main_dir subs{si} '/' subs{si} '_behavData'])
    rt11(si) = rtm_cond(1,1);
    rts = [rts; rts_cond{1,1}];
    cs = [cs repmat(1,1,length(rts_cond{1,1}))];
    ds = [ds repmat(1,1,length(rts_cond{1,1}))];
    ss = [ss repmat(si,1,length(rts_cond{1,1}))];
    rt15(si) = rtm_cond(1,5);
    rts = [rts; rts_cond{1,5}];
    cs = [cs repmat(1,1,length(rts_cond{1,5}))];
    ds = [ds repmat(2,1,length(rts_cond{1,5}))];
    ss = [ss repmat(si,1,length(rts_cond{1,5}))];
    rt41(si) = rtm_cond(4,1);
    rts = [rts; rts_cond{4,1}];
    cs = [cs repmat(2,1,length(rts_cond{4,1}))];
    ds = [ds repmat(1,1,length(rts_cond{4,1}))];
    ss = [ss repmat(si,1,length(rts_cond{4,1}))];
    rt45(si) = rtm_cond(4,5);
    rts = [rts; rts_cond{4,5}];
    cs = [cs repmat(2,1,length(rts_cond{4,5}))];
    ds = [ds repmat(2,1,length(rts_cond{4,5}))];
    ss = [ss repmat(si,1,length(rts_cond{4,5}))];
    
    [a b c d] = ttest2(rts_cond{1,1}, rts_cond{1,5}, 0.05, 'both', 'unequal');
    rtstat(1,2,si) = b;
    rtstat(1,1,si) = d.tstat;
    
    [a b c d] = ttest2(rts_cond{1,1}, rts_cond{4,1}, 0.05, 'both', 'unequal');
    rtstat(2,2,si) = b;
    rtstat(2,1,si) = d.tstat;
    
    [a b c d] = ttest2(rts_cond{4,1}, rts_cond{4,5}, 0.05, 'both', 'unequal');
    rtstat(3,2,si) = b;
    rtstat(3,1,si) = d.tstat;
    
    [a b c d] = ttest2(rts_cond{1,5}, rts_cond{4,5}, 0.05, 'both', 'unequal');
    rtstat(4,2,si) = b;
    rtstat(4,1,si) = d.tstat;
    
    rt11_15(si) = rtm_cond(1,1)-rtm_cond(1,5);
    rt11_41(si) = rtm_cond(1,1)-rtm_cond(4,1);
    rt41_45(si) = rtm_cond(4,1)-rtm_cond(4,5);
    rt15_45(si) = rtm_cond(1,5)-rtm_cond(4,5);
end

% [a1 b1 c1 d1] = ttest(abs(rt11),abs(rt15));
% [a2 b2 c2 d2] = ttest(abs(rt11),abs(rt41));
% [a3 b3 c3 d3] = ttest(abs(rt15),abs(rt45));
% [a4 b4 c4 d4] = ttest(abs(rt41),abs(rt45));
% [a5 b5 c5 d5] = ttest(abs(rt11_15),abs(rt11_41));
% [a6 b6 c6 d6] = ttest(abs(rt41_45),abs(rt15_45));

[a1 b1 c1 d1] = ttest(rt11,rt15);
[a2 b2 c2 d2] = ttest(rt11,rt41);
[a3 b3 c3 d3] = ttest(rt15,rt45);
[a4 b4 c4 d4] = ttest(rt41,rt45);
[a5 b5 c5 d5] = ttest(rt11_15,rt11_41);
[a6 b6 c6 d6] = ttest(rt41_45,rt15_45);

% p = anovan(rts',{cs,ds,ss},'model','interaction','varnames',strvcat('cs','ds','ss'));
