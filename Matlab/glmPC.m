main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/'; 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};

output_file = 'GLM_PC_CD.mat';
nSub = 8;
cohmat = repmat(1:4,nSub,1);
dirmat = repmat(1:5,nSub,1);
% submat = 1:8;
ctr = 1;

rtm_mat = zeros(cohmax,dirmax,submax);
for si = 1:submax
    load([main_dir subs{si} '/' subs{si} '_behavData'])
    
end

[b, dev, stats] = glmfit([cohmat, dirmat, cohmat.*dirmat], pcmat, 'binomial');
