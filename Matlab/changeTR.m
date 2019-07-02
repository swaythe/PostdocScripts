subs = 'Sub05';
sessions = 1:4;
tr = 1.8;
main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
epi_dir = 'NIFTIS_MNI/';

for sessId = 1:length(sessions)
    subj_dir = [data_dir subs '/Session_' num2str(sessions(sessId)) '/'];
    nifti_dir = [subj_dir epi_dir];
    cd(nifti_dir);

    runs = dir('*Smooth_MNI*.nii.gz');
    for ri = 1:length(runs)
        command = ['3drefit -TR ' int2str(tr) ' ' runs(ri).name];
        system(command)
    end
end