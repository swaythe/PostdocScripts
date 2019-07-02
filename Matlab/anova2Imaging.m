main_dir = '/home/sshankar/Categorization/Data/Imaging/'; 
gp_dir = [main_dir 'All/'];
mask_file = '/home/sshankar/Categorization/Templates/MNI-Mask.nii.gz';


subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
baseSess = [1 1 1 2 1 1 1 1];

% common_prefix = 'MedCohDist45';
% input_prefix = ['_' common_prefix '_MNI+tlrc'];
input_prefix = '_ComboCD_MNI+tlrc';
bucs = [4 14]; % The ComboCD bucket of interest; 16=100/0 C/D, 20=100/90 C/D
% output_file = ['Anova' common_prefix '.nii.gz'];
output_file = 'Anova_Dist90CohLoHi.nii.gz';
a_type = 3; % A fixed, B random
amax = 2; % Boundary 45 and 135
bmax = 8; % Subjects
ctr = 1;

command = ['3dANOVA2 -DAFNI_FLOATIZE=YES -type ' int2str(a_type) ' -alevels ' int2str(amax) ' -blevels ' int2str(bmax) ' '];
for ai = 1:amax
    for bi = 1:bmax
        sub_dir = [main_dir subs{bi} '/Session_' int2str(baseSess(bi)) '/GLM/'];
        command = [command '-dset ' int2str(ai) ' ' int2str(bi) ' ''' sub_dir subs{bi} input_prefix '[' int2str(bucs(ai)) ']'' '];
    end
end
command = [command '-mask ' mask_file ' '];
command = [command '-fa Coh '];
command = [command '-acontr 1 -1 A_contrast '];
command = [command '-bucket ' gp_dir output_file];
cd(gp_dir);
system(command)
