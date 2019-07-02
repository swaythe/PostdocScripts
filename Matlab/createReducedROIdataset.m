% Combine the ROI files listed in <rois> into one dataset. These ROIs
% were created from the split GLMs of parametric effects of coherence 
% and distance. The selected ROIs are the ones with >= 15 voxels per ROI in
% at least one subject.

roi_prefix = 'Combined_reduced_ROIs';
rois = [7, 12, 13, 17, 22:24, 26, 30, 32, 36:39, 46:48, 54, 60:62, 64, 67:73];
op_prefix = [roi_prefix '_valid.nii.gz'];
roi_dir = '/home/sshankar/Categorization/Data/Imaging/All/ROI_3x3_005unc_ParamSplit';
cd(roi_dir);

command = ['3dmerge -prefix ' op_prefix ' -gorder '];
for ri = 1:length(rois)
    if rois(ri) < 10
        roi_name = [roi_prefix '0' int2str(rois(ri)) '.nii.gz'];
    else
        roi_name = [roi_prefix int2str(rois(ri)) '.nii.gz'];
    end
    
    command = [command roi_name ' '];
end
system(command)