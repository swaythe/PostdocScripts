subs = {'Sub02'};%,'Sub04','Sub05','Sub06'};
baseSess = [1];% 1 2 1];

errts_file = 'errts.nii.gz'; %'_errts_ParamCohDir.nii.gz';
fwhmout_file = 'fwhmOut.1D'; %'_fwhmOutParamCohDir.1D';
clust_file = 'ClustOut'; %'_ClustOutParamCohDir';
    
% for si = 1:length(subs)
%     sub = subs{si};
%     glm_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/GLM/'];
%     nifti_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/NIFTIS/'];
%     mask_file = [nifti_dir sub '_Mask.nii.gz'];
%     cd(glm_dir);
% 
%     % % If using the errts file obtained from 3dDeconvolve
%     command = ['3dFWHMx -automask -combine -input ' sub errts_file ' -out ' sub fwhmout_file];
%     system(command)
% end

% Using smoothness values provided by 3dFWHMx using errts file as input
% fwhm_vals = [8.11939 7.94686 7.61233; ...
%                 8.31629 7.85597 7.4223; ...
%                 7.80353 7.88528 7.29752; ...
%                 8.89508 8.6338 7.55358; ...
%                 8.53823 8.26414 6.93415; ...
%                 8.24676 8.07235 7.46281; ...
%                 8.53073 8.2753 7.46167; ...
%                 8.3014 8.23224 7.72586
%             ];
fwhm_vals = [8.14507  7.71921  7.38872]; % Sub02 ROI GLM

for si = 1:length(subs)
    sub = subs{si};
    glm_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/GLM/'];
    nifti_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/NIFTIS/'];
    mask_file = [nifti_dir sub '_Mask.nii.gz'];
    cd(glm_dir);

    command = ['3dClustSim -mask ' mask_file ' -nxyz 70 70 32 -fwhmxyz ' num2str(fwhm_vals(si,:)) ' -NN 123 -nodec -prefix ' sub clust_file];
    system(command)
end