subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1]; 
% subs = {'Sub11'};
% baseSess = 1;

% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
mni_template = '/home/sshankar/Categorization/Templates/MNI-small.nii.gz';
common_prefix = 'BoundContrast';
norm_prefix = ['' common_prefix];
glm_file = ['_' common_prefix '.nii.gz'];
% glm_file = '_GLM_ExtremeCDcontrast.nii.gz';

% MNI file names of output files
beta_buc = 10;
beta_prenorm = 'beta_prenorm.nii.gz';
thresh_prenorm = 'thresh_prenorm.nii.gz';
beta_norm = 'beta_norm.nii.gz';
thresh_norm = 'thresh_norm.nii.gz';

for si = 1:length(subs)
    sub = subs{si};
    buc_prefix = [sub '_' norm_prefix '_MNI.nii.gz'];
    glm_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/GLM/'];
    op_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/MNI/'];
    fnirt_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/NIFTIS/'];
    fnirt_file = [fnirt_dir sub '_fnirt.nii.gz'];
    premat_filename = [fnirt_dir sub '_flirt.txt'];
    cd(glm_dir)

    % Extract beta bucket of interest
    command = ['3dbuc2fim -prefix ' beta_prenorm ' ' sub glm_file '[' int2str(beta_buc) ']'];
    system(command)

    % Extract threshold bucket of interest
    command = ['3dbuc2fim -prefix ' thresh_prenorm ' ' sub glm_file '[' int2str(beta_buc+1) ']'];
    system(command)

    % Warp beta bucket to MNI space
    command = ['applywarp --ref=' mni_template ' --in=' beta_prenorm ...
                ' --warp=' fnirt_file ' --out=' beta_norm]; % ' --premat=' premat_filename];
    system(command)

    % Warp threshold bucket to MNI space
    command = ['applywarp --ref=' mni_template ' --in=' thresh_prenorm ...
                ' --warp=' fnirt_file ' --out=' thresh_norm]; % ' --premat=' premat_filename];
    system(command)

    % Create MNI file with AFNI buckets of interest
    command = ['3dbucket -prefix ' op_dir buc_prefix ' -fbuc ' beta_norm ' -fbuc ' thresh_norm];
    system(command)
    
    % Delete temporary files
    command = ['rm ' beta_prenorm ' ' beta_norm ' ' thresh_prenorm ' ' thresh_norm];
    system(command)
    
end
