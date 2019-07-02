roi_input = 'Combined_reduced';
roiRad = 9; % in mm; = 3 voxels used in createROI
roi_prefix_mni = [roi_input '_ROIs.nii.gz'];

main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/All/'];
roi_dir = [data_dir 'ROI_3x3_005unc_ParamSplit/'];

template_dir = [main_dir, 'Templates/'];
MNI_brain = [template_dir 'MNI-small.nii.gz'];
MNI_mask = [template_dir 'MNI-small-mask.nii.gz'];

cd(roi_dir);

command = ['3dUndump -prefix ' roi_prefix_mni ' -master ' MNI_brain ' -mask ' MNI_mask ' -xyz -fval 0 -orient RAI -srad ' int2str(roiRad) ' ' roi_input]
system(command)
