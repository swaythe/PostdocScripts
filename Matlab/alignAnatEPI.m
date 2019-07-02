subs = 'Sub05';
sessions = 1;
baseSess = 2;

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
% addpath(script_dir, [script_dir 'Nifti_Functions/']);

for sessId = 1:length(sessions)
    subj_dir = [data_dir subs '/Session_' num2str(sessions(sessId)) '/'];
    nifti_dir = [subj_dir 'NIFTIS/'];
    cd(nifti_dir);
    
    anat_prefix = [subs '_mprage'];
    anat_cut_filename = [anat_prefix, '_Cut.nii.gz'];
    anat_align_filename = [anat_prefix, '_AlignEpi.nii.gz'];

    command = ['3dZcutup -keep 80 240 -prefix ' anat_prefix '_Cut.nii.gz ' ...
                anat_prefix '.nii.gz'];
    system(command);
    command = ['3drefit -deoblique -xorigin cen -yorigin cen -zorigin cen ' ...
                anat_prefix '_Cut.nii.gz'];
    system(command);
    command = ['3dresample -orient LPI -prefix ' anat_prefix ...
                '_Cut_LPI.nii.gz -inset ' anat_prefix '_Cut.nii.gz'];
    system(command);
    system(['mv ' anat_prefix '_Cut_LPI.nii.gz ' anat_prefix '_Cut.nii.gz']);

    command = ['align_epi_anat.py -anat ' anat_prefix '_Cut.nii.gz ' ...
                   '-epi ' subs '_Mean.nii.gz -epi_base 5 -giant_move'];
    system(command)
    system('rename Cut.nii.gz_al Giant_AlignEpi *Cut.nii.gz_al*');
end