subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
ic1_p = zeros(1,length(subs));
id1_p = zeros(1,length(subs));
ic2_p = zeros(1,length(subs));
ic1_pc = zeros(1,length(subs));
ic2_pc = zeros(1,length(subs));
id1_pc = zeros(1,length(subs));

main_dir = '~/Categorization/Data/Behavior/Scanner/';
cd(main_dir)

for si = 1:length(subs)
    sub = subs{si};
    load([sub '/' sub '_behavData'])
    ic1_pc(si) = pc_cond(2,5);
    ic2_pc(si) = pc_cond(3,5);
    id1_pc(si) = pc_cond(4,2);
    ic1_p(si) = binProb(ct_cond(2,5)+it_cond(2,5), ct_cond(2,5), 0.8);
    id1_p(si) = binProb(ct_cond(4,2)+it_cond(4,2), ct_cond(4,2), 0.8);
    ic2_p(si) = binProb(ct_cond(3,5)+it_cond(3,5), ct_cond(3,5), 0.90);
end