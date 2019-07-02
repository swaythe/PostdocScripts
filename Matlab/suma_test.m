% suma_dir = '/home/suma/';
% data_dir = '/home/sshankar/Categorization/Data/Imaging/All/';
% 
% spec_file = [suma_dir 'fsaverage_lh.spec'];
% sv_file = [suma_dir 'fsaverage_SurfVol+orig'];
% gp_file = [data_dir 'ME_CDCorr_Group.nii.gz'];
% surfA = [suma_dir 'lh.smoothwm.asc'];
% surfB = [suma_dir 'lh.inflated.asc'];
% out1D_file = [data_dir 'test_lh_smoothwm_inf.1D'];
% outniml_file = [data_dir 'test_lh_smoothwm_inf.niml.dset'];
% 
% % command = ['3dVol2Surf ' ...
% %     '-spec 101-T1-Spec-MI.spec -surf_A smoothwm -surf_B pial -sv 101_SurfVol+orig ' ...
% %     '-grid_parent 101-GLM-All-GLT+orig[22] -map_func ave -f_steps 5 -f_index nodes ' ...
% %     '-f_p1_fr -0.2 -f_pn_fr 0.2 -skip_col_i -skip_col_j -skip_col_k ' ...
% %     '-out_1D -out_1D 101-GLM-Surface-1D -out_niml 101-GLM-L-Surface.niml.dset'];
% 
% command = ['3dVol2Surf -spec ' spec_file ' -surf_A ' surfA ' -surf_B ' surfB ' -sv ' sv_file ...
%     ' -grid_parent ' gp_file ' -map_func ave -f_steps 5 -f_index nodes' ...
%     ' -f_p1_fr -0.2 -f_pn_fr 0.2 -skip_col_i -skip_col_j -skip_col_k' ...
%     ' -out_1D ' out1D_file ' -out_niml ' outniml_file];
%     
% % ' -surf_B ' surfB 
% % -f_steps 5 -f_index nodes' ...
% %     ' -f_p1_fr -0.2 -f_pn_fr 0.2 -skip_col_i -skip_col_j -skip_col_k' ...
% system(command)

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
suma_dir = [main_dir 'suma_mni/'];
data_dir = [main_dir 'All/'];

spec_file = [suma_dir 'N27_lh.spec'];
sv_file = [suma_dir 'MNI_N27+tlrc'];
gp_file = [data_dir 'ME_CDCorr_Group.nii.gz'];
surfA = [suma_dir 'lh.smoothwm.asc'];
surfB = [suma_dir 'lh.pial.asc'];
out1D_file = [data_dir 'test_lh_wmp.1D'];
outniml_file = [data_dir 'test_lh_wmp.niml.dset'];

% command = ['3dVol2Surf ' ...
%     '-spec 101-T1-Spec-MI.spec -surf_A smoothwm -surf_B pial -sv 101_SurfVol+orig ' ...
%     '-grid_parent 101-GLM-All-GLT+orig[22] -map_func ave -f_steps 5 -f_index nodes ' ...
%     '-f_p1_fr -0.2 -f_pn_fr 0.2 -skip_col_i -skip_col_j -skip_col_k ' ...
%     '-out_1D -out_1D 101-GLM-Surface-1D -out_niml 101-GLM-L-Surface.niml.dset'];

command = ['3dVol2Surf -spec ' spec_file ' -surf_A ' surfA ' -surf_B ' surfB ' -sv ' sv_file ...
    ' -grid_parent ' gp_file ' -map_func ave -f_steps 5 -f_index nodes' ...
    ' -f_p1_fr -0.2 -f_pn_fr 0.2 -skip_col_i -skip_col_j -skip_col_k' ...
    ' -out_1D ' out1D_file ' -out_niml ' outniml_file];

% command = ['3dVol2Surf -spec ' spec_file ' -surf_A ' surfA ' -sv ' sv_file ...
%     ' -grid_parent ' gp_file ' -map_func mask' ...
%     ' -out_1D ' out1D_file ' -out_niml ' outniml_file];
    
% ' -surf_B ' surfB 
% -f_steps 5 -f_index nodes' ...
%     ' -f_p1_fr -0.2 -f_pn_fr 0.2 -skip_col_i -skip_col_j -skip_col_k' ...
system(command)