% This program calculates the mean and deviations of the first task EPI of
% each subject
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
nifti_prefix = 'NIFTIS';

nSub = length(subs);
op_prefix = 'std';

for si = 1:nSub
    sub = subs{si};
    nifti_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' nifti_prefix '/'];
    cd(nifti_dir)
    d = dir('EPI*Smooth*');
    first_epi = [d(1).name(1:9) '.nii.gz'];
    mean_epi = [main_dir sub '/' sub '_mean.nii.gz'];
    std_epi = [main_dir sub '/' sub '_std.nii.gz'];
    command = ['3dTstat -mean -prefix ' mean_epi ' ' first_epi];
    system(command)
    command = ['3dTstat -stdev -prefix ' std_epi ' ' first_epi];
    system(command)
end
