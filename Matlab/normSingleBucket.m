subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1]; 

% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
mni_template = '/ace/old-ace/8tb/sshankar/Categorization/Templates/MNI-small.nii.gz';
common_prefix = 'PEAbsDistMinusAbsCoh';
norm_prefix = ['' common_prefix];
glm_file = ['_' common_prefix '.nii.gz'];

% MNI file names of output files
beta_prenorm = 'beta_prenorm.nii.gz';
thresh_prenorm = 'thresh_prenorm.nii.gz';
beta_norm = 'beta_norm.nii.gz';
thresh_norm = 'thresh_norm.nii.gz';

for si = 1:length(subs)
    sub = subs{si};
    buc_prefix = [sub '_' norm_prefix '_MNI.nii.gz'];
    glm_dir = ['/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/GLM/'];
    op_dir = ['/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/MNI/'];
    fnirt_dir = ['/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/NIFTIS/'];
    fnirt_file = [fnirt_dir sub '_fnirt.nii.gz'];
    premat_filename = [fnirt_dir sub '_flirt.txt'];
    cd(glm_dir)

    % Warp beta bucket to MNI space
    command = ['applywarp --ref=' mni_template ' --in=' sub glm_file ...
                ' --warp=' fnirt_file ' --out=' op_dir buc_prefix]; % ' --premat=' premat_filename];
    system(command)    
end
