data_dir = '/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/';
cd(data_dir)

% mask_file = '/home/sshankar/Categorization/Templates/MNI-Mask.nii.gz';
mask_file = '/ace/old-ace/8tb/sshankar/Categorization/Templates/MNI-small-mask.nii.gz';
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub01','Sub02','Sub04'}; % Group 1
% baseSess = [1 1 1];
% subs = {'Sub05','Sub08','Sub10'}; % Group 2
% baseSess = [2 1 1];
% subs = {'Sub04','Sub06','Sub10'}; % Group 3
% baseSess = [1 1 1];
% subs = {'Sub02','Sub05','Sub08'}; % Group 4
% baseSess = [1 2 1];

% % T-test to get group activations for each individual condition
% 
% Command for parametric Coh-Dir
glm_common = 'PEAbsDistMinusAbsCoh_MNI';
% glm_prefix = [glm_common '.nii.gz'];
% glm_prefix = [glm_common '_MNI+tlrc'];
bucno = 0;
glm_prefix = [glm_common '.nii.gz' '''[' int2str(bucno) ']'''];
group_prefix = [fullfile(data_dir,'All') '/' glm_common '_Group.nii.gz'];
% group_prefix = ['/home/sshankar/Categorization/Data/Imaging/All/C100allVsD90Dall_Group.nii.gz'];

command = ['3dttest++ -prefix ' group_prefix ' -mask ' mask_file ' -setA '];
for si = 1:length(subs)
    sub = subs{si};
    glm_dir = [sub '/Session_' int2str(baseSess(si)) '/MNI/'];
    command = [command glm_dir sub '_' glm_prefix ' '];
end
system(command)

% Command for individual Coh-Dir combinations
% glm_common = 'ComboCD';
% for bucno = 1:19
% % bucno = 1;
%     glm_prefix = ['_' glm_common '_MNI+tlrc''[' int2str(bucno) ']'''];
%     group_prefix = ['/home/sshankar/Categorization/Data/Imaging/All/' glm_common int2str(bucno+1) '.nii.gz'];
% 
%     command = ['3dttest++ -prefix ' group_prefix ' -mask ' mask_file ' -setA '];
%     for si = 1:length(subs)
%         sub = subs{1,si};
%         glm_dir = [sub '/Session_' int2str(baseSess(si)) '/MNI/'];
%         command = [command glm_dir sub glm_prefix ' '];
%     end
%     system(command)
% end

% % Command to get group activations for boundary comparisons
% glm_common = 'B1vs2';
% for bucno = 0:3
%     glm_prefix = ['_' glm_common '_MNI+tlrc''[' int2str(bucno) ']'''];
%     group_prefix = ['/home/sshankar/Categorization/Data/Imaging/All/' glm_common 'c' int2str(bucno+1) '_Group.nii.gz'];
% 
%     command = ['3dttest++ -prefix ' group_prefix ' -mask ' mask_file ' -setA '];
%     for si = 1:length(subs)
%         sub = subs{1,si};
%         glm_dir = [sub '/Session_' int2str(baseSess(si)) '/GLM/'];
%         command = [command glm_dir sub glm_prefix ' '];
%     end
%     system(command)
% end
% 
% for bucno = 4:5
%     glm_prefix = ['_' glm_common '_MNI+tlrc''[' int2str(bucno) ']'''];
%     group_prefix = ['/home/sshankar/Categorization/Data/Imaging/All/B' int2str(bucno-3) 'c2vs3_Group.nii.gz'];
% 
%     command = ['3dttest++ -prefix ' group_prefix ' -mask ' mask_file ' -setA '];
%     for si = 1:length(subs)
%         sub = subs{1,si};
%         glm_dir = [sub '/Session_' int2str(baseSess(si)) '/GLM/'];
%         command = [command glm_dir sub glm_prefix ' '];
%     end
%     system(command)
% end
% 
