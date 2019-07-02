main_dir = '/ace/old-ace/8tb/sshankar/Categorization/Data/Behavior/Scanner/'; 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};

output_file = 'AnovaPC_no0CD.mat';
cohmax = 2;
dirmax = 3;
submax = length(subs);
ctr = 1;

pc_mat = zeros(cohmax,dirmax,submax);
for si = 1:submax
    load([main_dir subs{si} '/' subs{si} '_behavData'])
%     pc_mat(:,:,si) = pc_cond;
    pc_mat(:,:,si) = pc_cond(2:end-1,2:end-1);
end
pc_mat = pc_mat(:);
pc_mat = asin(sqrt(pc_mat));

coh_mat = repmat([1:cohmax]',[1,dirmax*submax]);
coh_mat = coh_mat(:);
dir_mat = repmat(1:dirmax,[cohmax,1,submax]);
dir_mat = dir_mat(:);
sub_mat = repmat(1:submax,cohmax*dirmax,1);
sub_mat = sub_mat(:);

[pvals, tbl, stats] = anovan(pc_mat, {coh_mat, dir_mat, sub_mat}, ...
    'model', 2, 'random', 3, 'varnames', {'Coherence' 'Distance' 'Subject'});

[mcomp, means, h, gnames] = multcompare(stats, 'Dimension', [1 2]);
