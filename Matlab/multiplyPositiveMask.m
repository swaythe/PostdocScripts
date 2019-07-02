data_dir = '/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/';
cd(data_dir)

% % To apply positive mask at subject level for native space buckets
% 
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
% 
% roi_common = 'PEDist';
% mask_file = '_MEPositive_Mask.nii.gz';
% 
% glm_folder = '/GLM/';
% roi_folder = '/FullDataROI_PEDistCorr_005corr/';
% 
% for si = 1:length(subs)
%     sub = subs{si};
%     glm_dir = [data_dir sub '/Session_' int2str(baseSess(si)) glm_folder];
%     roi_dir = [data_dir sub '/Session_' int2str(baseSess(si)) roi_folder];
%     cd(roi_dir)
%     rds = dir(['*' roi_common '*']);
%     for ri = 1:length(rds)
%         input_file = rds(ri).name;
%         output_file = [rds(ri).name(1:end-9) 'Positive' rds(ri).name(end-8:end-7) '.nii.gz'];
%         command = ['3dcalc -a '  input_file ' -b ' glm_dir sub mask_file ' -expr ' '''a*b''' ' -prefix ' output_file];
%         system(command)
%     end
% end


% To apply positive mask at group level 

cd('All/')

common = 'PEAbsDistMinusAbsCoh_MNI_Group';
% common = 'AnovaNoLowCD_interaction';
% mask_file = ['ME_' common 'Positive_Mask.nii.gz'];
input_file = [common '.nii.gz'];
% output_file = ['PE_' common 'Positive_Group.nii.gz'];
mask_file = 'ME_CDCorrPositiveP05_Mask.nii.gz[0]';
% input_file = [common '_Group.nii.gz'];
output_file = [common 'PositiveP05.nii.gz'];
command = ['3dcalc -a ' mask_file ' -b ' input_file '[0] -expr ' '''a*b''' ' -prefix beta.nii.gz'];
system(command)

command = ['3dcalc -a ' mask_file ' -b ' input_file '[1] -expr ' '''a*b''' ' -prefix thresh.nii.gz'];
system(command)

command = ['3dbucket -prefix ' output_file ' -fbuc beta.nii.gz -fbuc thresh.nii.gz'];
system(command)

command = 'rm beta.nii.gz thresh.nii.gz';
system(command)


% % To apply positive mask at subject level for MNI space buckets
% 
% common = 'DirCorrect';
% mask_file = ['MainEffect' 'Positive_Mask.nii.gz'];
% input_file = ['_' common '_MNI.nii.gz'];
% output_file = ['_' common 'Positive_MNI.nii.gz'];
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
% 
% for si = 1:length(subs)
%     sub = subs{si};
%     glm_dir = [sub '/Session_' int2str(baseSess(si)) '/GLM/'];
%     command = ['3dcalc -a ' glm_dir sub mask_file ' -b ' glm_dir sub input_file ' -expr ' '''a*b''' ' -prefix ' glm_dir sub output_file];
%     system(command)
% end
