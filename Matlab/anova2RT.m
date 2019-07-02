main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/'; 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};

output_file = 'AnovaCD.mat';
cohmax = 4;
dirmax = 5;
submax = 8;
ctr = 1;

rtm_mat = zeros(cohmax*submax,dirmax);
for si = 1:submax
    load([main_dir subs{si} '/' subs{si} '_behavData'])
    for ci = 1:cohmax
        rtm_mat(8*[0:3]+si,:) = rtm_cond;
    end
end
% rtm_mat = rtm_mat(:);

[pvals, tbl, stats] = anova2(rtm_mat, submax);

[mcomp, means, h, gnames] = multcompare(stats, 'Dimension', [1 2]);