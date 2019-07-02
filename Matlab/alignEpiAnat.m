subs = 'Sub05';
sessions = 2;
baseSess = 2;

main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
base_dir = [data_dir subs '/Session_' num2str(baseSess) '/NIFTIS/'];
template_dir = [main_dir, 'Templates/'];

for sessId = 1:length(sessions)
    subj_dir = [data_dir subs '/Session_' num2str(sessions(sessId)) '/'];
    nifti_dir = [subj_dir 'NIFTIS/'];
    cd(nifti_dir);
%     anat_template = [subs '_mprage_session' int2str(sessions(sessId))
%     'to' int2str(baseSess) '.nii.gz'];
%     anat_template = [base_dir subs '_mprage_Giant_AlignEpi.nii.gz'];
    anat_template = [template_dir 'MNI-small-lpi.nii.gz'];
%     anat_template = [base_dir subs '_Mean.nii.gz'];
    
%     fnirt_file = [subs '_fnirt_session' int2str(sessions(sessId)) 'to' int2str(baseSess) '.nii.gz'];
    if sessions(sessId) == 1
        fnirt_file = [subs '_fnirt.nii.gz'];
    else
        fnirt_file = [base_dir subs '_fnirt.nii.gz'];
    end
    
%     runs = dir('EPI_Task*CoReg.nii.gz');
    runs = dir('*Mask*.nii.gz');
    for ri = 1:length(runs)
        % Now normalize realigned anatomical to the base anatomical template
        prenorm_filename = runs(ri).name;
        norm_filename = [runs(ri).name(1:end-7) '_MNI.nii.gz'];
        command = ['applywarp --ref=' anat_template ' --in=' prenorm_filename ...
                    ' --warp=' fnirt_file ' --out=' norm_filename];
        system(command)
        
        command = ['3drefit -TR 1.8 -deoblique ' norm_filename];
        system(command)
        
        command =  ['3dresample -orient LPI -prefix ' norm_filename(1:end-7) '_resample.nii.gz -inset ' norm_filename];
        system(command)
    end
    cd ..
end