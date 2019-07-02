% % Ok, 3dvolreg doesn't work to align EPIs to an MNI brain because the grids
% % for both brains are different:
% % EPI = 70 x 70 x 32
% % MNI = 91 x 109 x 91
cd('/home/sshankar/Categorization/Data/Imaging/Sub02/Trials');
% 
% base_prefix = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% command = ['3dvolreg -twopass -twodup -verbose -base ' base_prefix ...
%     ' -maxdisp1D MD1D.txt -1Dfile 1D.txt ' ...
%     ' -prefix Epi_Task1_Std.nii.gz EPI_Task1_CoReg.nii.gz'];
% system(command)

% % Next step is to try applywarp obtained from the anatomical realignment
% prenorm_filename = 'EPI_Task1.nii.gz';
% norm_filename = 'EPI_Task1NormAnat.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtMean.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)
% 
% prenorm_filename = 'EPI_Task1.nii.gz';
% norm_filename = 'EPI_Task1NormMean.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtMean2.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)
% 
% prenorm_filename = 'EPI_Task1.nii.gz';
% norm_filename = 'EPI_Task1NormVol3.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtVol3.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)

% prenorm_filename = 'EPI_Task1_Smooth.nii.gz';
% norm_filename = 'EPI_Task1NormSmoothAnat.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtMean.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)
% 
% prenorm_filename = 'EPI_Task1_Smooth.nii.gz';
% norm_filename = 'EPI_Task1NormSmoothMean.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtMean2.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)
% 
% prenorm_filename = 'EPI_Task1_Smooth.nii.gz';
% norm_filename = 'EPI_Task1NormSmoothVol3.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtVol3.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)
% command = '3dbuc2fim -prefix Sub02_GLM_Main.nii.gz Sub02_GLM_ParamCohDir.nii.gz[1]';
% system(command)
% 
% command = '3dbuc2fim -prefix Sub02_GLM_Coh.nii.gz Sub02_GLM_ParamCohDir.nii.gz[3]';
% system(command)
% 
% command = '3dbuc2fim -prefix Sub02_GLM_Dir.nii.gz Sub02_GLM_ParamCohDir.nii.gz[5]';
% system(command)

prenorm_filename = 'Sub02_GLM_ParamCohDir.nii.gz';
norm_filename = 'Sub02_NormGLM.nii.gz';
mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
fnirt_file = 'Sub02_fnirtMean.nii.gz';

command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
            ' --warp=' fnirt_file ' --out=' norm_filename];
system(command)

% prenorm_filename = 'Sub02_GLM_ParamCohDir.nii.gz';
% norm_filename = 'Sub02_NormGLMMean.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtMean2.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)
% 
% prenorm_filename = 'Sub02_GLM_ParamCohDir.nii.gz';
% norm_filename = 'Sub02_NormGLMVol3.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% fnirt_file = 'Sub02_fnirtVol3.nii.gz';
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)

% % Finally, use flirt, fnirt and applywarp on the Mean, CoReg and Smooth 
% % datasets to see if the warp dataset obtained is different from that 
% % obtained during anatomical realignment
% prenorm_filename = 'EPI_Task1_Vol3.nii.gz';
% norm_filename = 'Sub02_Task1Vol3Norm.nii.gz';
% mni_template = '/home/sshankar/Categorization/Templates/MNI-Brain.nii.gz';
% config_file = '/home/sshankar/Categorization/Templates/MNI-Brain.cnf';
% fnirt_file = 'Sub02_fnirtVol3.nii.gz';
% omat_file = 'Sub02_flirtVol3.txt';
% 
% command = ['flirt -ref ' mni_template ' -in ' prenorm_filename ...
%             ' -omat ' omat_file];
% system(command)
% 
% command = ['fnirt --in=' prenorm_filename ' --aff=' omat_file ...
%             ' --cout=' fnirt_file ' --config=' config_file];
% system(command)
% 
% command = ['applywarp --ref=' mni_template ' --in=' prenorm_filename ...
%             ' --warp=' fnirt_file ' --out=' norm_filename];
% system(command)
