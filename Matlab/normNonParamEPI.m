subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub01'};
% baseSess = 1;

mni_template = '/home/sshankar/Categorization/Templates/MNI-small.nii.gz';
glm_prefix = '_ME_ROI'; 
glm_file = [glm_prefix '.nii.gz'];

% MNI file names of output files
beta_buc = 1; 
% beta_buc = [1 3 6 8];
% beta_buc = 1:3:61; % For parametric GLMs when you want all intensities in one file
beta_prenorm = 'beta_prenorm.nii.gz';
beta_norm = 'beta_norm.nii.gz';
mni_prefix = [glm_prefix 'Corr_MNI.nii.gz'];

for si = 1:length(subs)
    sub = subs{si};
    buc_prefix = [sub mni_prefix];
    glm_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/GLM/'];
    mni_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/MNI/'];
    fnirt_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/NIFTIS/'];
    fnirt_file = [fnirt_dir sub '_fnirt.nii.gz'];
    premat_filename = [fnirt_dir sub '_flirt.txt'];
    cd(glm_dir)
    
    % The aglueto option of 3dbucket is not working properly so create the
    % first bucket and then use glueto to append subsequent buckets to the
    % file.
    command = ['3dbuc2fim -prefix ' beta_prenorm ' ' sub glm_file '[' int2str(beta_buc(1)) ']'];
    system(command)

    command = ['applywarp --ref=' mni_template ' --in=' beta_prenorm ...
                ' --warp=' fnirt_file ' --out=' beta_norm]; % ' --premat=' premat_filename];
    system(command)

    command = ['3dbucket -prefix ' mni_dir sub mni_prefix(1:end-7) '+tlrc -fbuc ' beta_norm];
    system(command)

    command = ['rm ' beta_prenorm ' ' beta_norm];
    system(command)
    
    for bi = 2:length(beta_buc)
        command = ['3dbuc2fim -prefix ' beta_prenorm ' ' sub glm_file '[' int2str(beta_buc(bi)) ']'];
        system(command)

        command = ['applywarp --ref=' mni_template ' --in=' beta_prenorm ...
                    ' --warp=' fnirt_file ' --out=' beta_norm]; % ' --premat=' premat_filename];
        system(command)
        
        command = ['3dbucket -overwrite -glueto ' mni_dir sub mni_prefix(1:end-7) '+tlrc ' beta_norm];
        system(command)
        
        command = ['rm ' beta_prenorm ' ' beta_norm];
        system(command)
    end
end