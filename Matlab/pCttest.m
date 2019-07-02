subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
ic1_pc = zeros(1,length(subs));
id1_pc = zeros(1,length(subs));
ldlc_pc = zeros(1,length(subs));
hdlc_pc = zeros(1,length(subs));
ldhc_pc = zeros(1,length(subs));
hdhc_pc = zeros(1,length(subs));

main_dir = '~/Categorization/Data/Behavior/Scanner/';
cd(main_dir)

for si = 1:length(subs)
    sub = subs{si};
    load([sub '/' sub '_behavData'])
    ic1_pc(si) = pc_cond(2,5);
    id1_pc(si) = pc_cond(4,2);
    ldlc_pc(si) = pc_cond(1,1);
    hdlc_pc(si) = pc_cond(1,5);
    ldhc_pc(si) = pc_cond(4,1);
    hdhc_pc(si) = pc_cond(4,5);
end

% Calculate statistics of intermediate coherence and distance
[ic1_h, ic1_p, ic1_c, ic1_s] = ttest(ic1_pc,0.8);
[id1_h, id1_p, id1_c, id1_s] = ttest(id1_pc,0.8);

% Calculate statistics of low distance at low coherence 
[ldlc_h, ldlc_p, ldlc_c, ldlc_s] = ttest(ldlc_pc,0.5);

% Calculate statistics of high distance at low coherence 
[hdlc_h, hdlc_p, hdlc_c, hdlc_s] = ttest(hdlc_pc,0.5);

% Calculate statistics of high coherence at low distance
[ldhc_h, ldhc_p, ldhc_c, ldhc_s] = ttest(ldhc_pc,0.5);

% Calculate statistics of high distance at high coherence 
[hdhc_h, hdhc_p, hdhc_c, hdhc_s] = ttest(hdhc_pc,1);
