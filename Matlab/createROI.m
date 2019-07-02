cd('/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/All');

% When the main effects are used to create ROIs
% roi_dir = 'ROI_MECorr_005corr_bigROI';
% input_prefix = 'ME_ROICorr_Group'; 
% short_prefix = [input_prefix '_short'];
% output_file = [roi_dir '/MECorr.nii.gz'];
% dindex = 0; % Bucket 0 = intensity, 1 = T-stat
% tindex = 1;
% thresh = 3.84; % 5.044: p=0.001; 3.84: p=0.005; 3.359: p=0.01
% clust = 42; %42; % 20: p=0.001; 42: p=0.005; 61: p=0.01

% % When the overall parametric maps are used to create ROIs
% roi_dir = ''; %FullDataROI_PEDistCorr_005corr';
% input_prefix = 'PE_Acc4binAll_GroupPositiveP05'; 
% short_prefix = [input_prefix '_short'];
% output_file = [roi_dir '/temp.nii.gz']; %'/PEDist_P05_p.nii.gz'];
% dindex = 0; % Bucket 0 = intensity, 1 = T-stat
% tindex = 1;
% thresh = 3.968; % 3.968: p=0.001; 3.228: p=0.005; 2.901: p=0.01
% clust = 20; % 20: p=0.001; 42: p=0.005; 61: p=0.01

% % When the full-data ANOVA is used to create ROIs
% roi_dir = 'FullDataROI_AnovaCorr_005corr';
% input_prefix = 'AnovaCorrInteractionPositiveP05'; 
% short_prefix = [input_prefix '_short'];
% dindex = 0; % Bucket 4 = intensity, 5 = F-stat
% tindex = 1;
% output_file = [roi_dir '/temp.nii.gz']; % 'AnovaCorrPositiveP05.nii.gz'];
% thresh = 3.09; % 3.09: p<0.001; 2.596: p<0.005; 2.378: p<0.01
% clust = 20; 

% When the no-low salience-data ANOVA is used to create ROIs
roi_dir = 'FullDataROI_AnovaCorr_005corr';
input_prefix = 'AnovaNoLowCD_interactionPositiveP05'; 
short_prefix = [input_prefix '_short'];
dindex = 0; % Bucket 4 = intensity, 5 = F-stat
tindex = 1;
output_file = [roi_dir '/temp.nii.gz']; % 'AnovaCorrPositiveP05.nii.gz'];
thresh = 4.551; % 4.551: p<0.001; 3.607: p<0.005
clust = 20; 

% When the difference of parametric maps are used to create ROIs
% roi_dir = ''; %FullDataROI_PEDistCorr_005corr';
% input_prefix = 'PEDistMinusCoh_MNI_GroupPositiveP05'; 
% short_prefix = [input_prefix '_short'];
% output_file = [roi_dir '/temp.nii.gz']; %'/PEDist_P05_p.nii.gz'];
% dindex = 0; % Bucket 0 = intensity, 1 = T-stat
% tindex = 1;
% thresh = 5.046; % 5.046: p=0.001; 3.84: p=0.005; 3.359: p=0.01
% clust = 20; % 20: p=0.001; 42: p=0.005; 61: p=0.01

rad = 4; % 6 when smaller MNI voxel size is used
overlap = 8; % If overlap = 2*rad, ROIs do not overlap
thresh_prefix = [input_prefix '_thresh'];

% 3dmerge requires data of type short while nifti images are float or
% double or something. The statement below does type conversion.
command = ['3dcalc -a ' input_prefix '.nii.gz -prefix ' short_prefix ' -expr a -datum short'];
system(command)

command = ['3dmerge -dxyz=1 -1clust 1 ' int2str(clust) ' -1thresh ' num2str(thresh) ' -1tindex ' int2str(tindex) ' -1dindex ' int2str(dindex) ' -prefix ' thresh_prefix ' ' short_prefix '+tlrc'];
% command = ['3dmerge -dxyz=1 -1thresh ' num2str(thresh) ' -1tindex ' int2str(tindex) ' -1dindex ' int2str(dindex) ' -prefix ' thresh_prefix ' ' short_prefix '+tlrc'];
system(command)

% spheres1toN says that the most extreme ROI gets number 1, next extreme gets 2 etc. 
command = ['3dmaxima -input ' thresh_prefix '+tlrc -prefix ' output_file ' -spheres_1toN -min_dist ' int2str(overlap) ' -out_rad ' int2str(rad) ' -true_max'];% 
% command = ['3dmaxima -input ' thresh_prefix '+tlrc -prefix ' output_file ' -spheres_1toN -min_dist ' int2str(overlap) ' -out_rad ' int2str(rad) ' -true_max -neg_ext'];
system(command)

command = 'rm *short* *thresh*';
system(command)
