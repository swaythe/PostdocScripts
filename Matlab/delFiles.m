data_dir = '/home/sshankar/Categorization/Data/Imaging/';
cd(data_dir)

subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
baseSess = [1 1 1 2 1 1 1 1];

for si = 1:length(subs)
    sub = subs{1,si};
    glm_dir = [sub '/Session_' int2str(baseSess(si)) '/GLM/'];
    command = ['rm ' glm_dir '*Positive*.nii.gz '];
    system(command)
end
