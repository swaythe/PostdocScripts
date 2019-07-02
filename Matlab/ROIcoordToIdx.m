sub = 'Sub04';
baseSess = 1;

main_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess) '/'];
glm_dir = [main_dir 'GLM/'];
roi_dir = [main_dir 'ROI/'];
glm_prefix = '_GLM_ParamCohDir.nii.gz[1]';
roi_prefix = '_ROI_Coh_Mask_Native.nii.gz';
output_prefix = 'Coh_Voxels.nii.gz';

command = ['3dcalc -a ' glm_dir sub glm_prefix ' -b ' roi_dir sub roi_prefix ' -expr ''a*b'' -prefix ' roi_dir output_prefix];
system(command)

cd(roi_dir)
gunzip(output_prefix)
roi_vol = load_nii(output_prefix(1:end-3));
roi_vol = roi_vol.img;
ids = find(roi_vol>0);
intensity = roi_vol(ids);
[s sIds] = sort(intensity,'descend');

[x y z] = ind2sub(size(roi_vol), ids(sIds));
coords = [x(1:10) y(1:10) z(1:10)];

save([sub '_Coh_ROI_Coords.mat'], 'coords', 'sub');
gzip(output_prefix(1:end-3));