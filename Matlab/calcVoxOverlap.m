% To find the number of subjects that show an overlap of ROI i.e., the
% number of subjects that have at least 15 voxels per ROI.

roi_common = 'nVox_PEDistPositive';
folder_prefix = 'PEDistCorr_005corr';

main_dir = ['/home/sshankar/Categorization/Data/Imaging/All/FullDataROI_' folder_prefix '/'];
cd(main_dir)

load('nVox_native')
minVox = 15;

nVox_overlap = sum(eval(roi_common) >= minVox, 1);
