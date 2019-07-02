subs = 'Sub05';
sessions = 1;
baseSess = 2;

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
base_dir = [data_dir subs '/Session_' num2str(baseSess) '/NIFTIS/'];
% addpath(script_dir, [script_dir 'Nifti_Functions/']);


for sessId = 1:length(sessions)
    subj_dir = [data_dir subs '/Session_' num2str(sessions(sessId)) '/'];
    nifti_dir = [subj_dir 'NIFTIS/'];
    cd(nifti_dir);
    
    % Now normalize realigned anatomical to the base anatomical template
    prenorm_prefix = [subs '_mprage_Giant_AlignEpi'];
    prenorm_filename = [prenorm_prefix '.nii.gz'];
    norm_prefix = [subs '_mprage_session1to2'];
    norm_filename = [norm_prefix '.nii.gz'];

    anat_template = [base_dir subs '_mprage_Giant_AlignEpi.nii.gz'];
    omat_file = [subs '_flirt_session' int2str(sessions(sessId)) 'to' int2str(baseSess) '.txt'];
    command = ['flirt -ref ' anat_template ' -in ' prenorm_filename ...
                ' -omat ' omat_file];
    system(command)
    
    fnirt_file = [subs '_fnirt_session' int2str(sessions(sessId)) 'to' int2str(baseSess) '.nii.gz'];
    
    command = ['fnirt --in=' prenorm_filename ' --aff=' omat_file ' --ref=' anat_template ...
                ' --cout=' fnirt_file]; % ' --config=' config_file];
    system(command)
    command = ['applywarp --ref=' anat_template ' --in=' prenorm_filename ...
                ' --warp=' fnirt_file ' --out=' norm_filename];
    system(command)
    cd ..
end
