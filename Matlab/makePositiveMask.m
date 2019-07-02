data_dir = '/home/sshankar/Categorization/Data/Imaging/';
cd(data_dir)

% To create mask at subject level for native space buckets

% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1];
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub11'};
% baseSess = 1;

common = 'CD';
effects_file = ['_' common '.nii.gz[1]'];
% mask_prefix = ['_' common 'Positive_Mask.nii.gz'];
mask_prefix = ['_' 'ME' 'Positive_Mask.nii.gz'];

for si = 1:length(subs)
    sub = subs{si};
    glm_dir = [sub '/Session_' int2str(baseSess(si)) '/GLM/'];
    command = ['3dcalc -a ' glm_dir sub effects_file ' -expr ' '''ispositive(a)''' ' -prefix ' glm_dir sub mask_prefix];
    system(command)
end


% % To create mask at group level
% 
% cd('All/')
% common = 'ME_ROICorr';
% effects_file = [common '_Group.nii.gz'];
% mask_file = [common 'Positive_Mask.nii.gz'];
% 
% command = ['3dcalc -a ' effects_file ' -expr ' '''ispositive(a)''' ' -prefix ' mask_file];
% system(command)


% % To create mask at subject level for MNI space buckets
% 
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1];
% 
% common = 'MainEffect';
% effects_file = ['_' common 'Correct_MNI.nii.gz'];
% mask_prefix = [common 'Positive_Mask.nii.gz'];
% 
% for si = 1:length(subs)
%     sub = subs{si};
%     glm_dir = [sub '/Session_' int2str(baseSess(si)) '/GLM/'];
%     command = ['3dcalc -a ' glm_dir sub effects_file ' -expr ' '''ispositive(a)''' ' -prefix ' glm_dir sub mask_prefix];
%     system(command)
% end
