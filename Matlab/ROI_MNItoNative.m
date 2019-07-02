% subs = {'Sub01'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub11','Sub13'};
% baseSess = [1 1];

roi_common = 'PEDist';
main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
roi_dir = 'FullDataROI_PEDistCorr_005corr/';
group_dir = [data_dir 'All/' roi_dir];
cd(group_dir);
rois = dir([roi_common '*.nii.gz']);

for si = 1:length(subs)
    for ri = 2:length(rois) 
        sub = subs{si};
        subj_dir = [data_dir sub '/Session_' int2str(baseSess(si)) '/'];

        roi_mni = [group_dir rois(ri).name];
        roi_native = [sub rois(ri).name];
        nifti_dir = [subj_dir 'NIFTIS/'];
        glm_dir = [subj_dir 'GLM/'];

        anat_ref = [nifti_dir sub '_mprage_Giant_AlignEpi.nii.gz'];
        warp_file = [nifti_dir sub '_fnirt.nii.gz'];
        invWarp_file = [nifti_dir sub '_invWarp.nii.gz'];
        epi_mask_file = [nifti_dir sub '_Mask.nii.gz'];

        cd(subj_dir);
        if ~exist(roi_dir,'dir')
            system(['mkdir ' roi_dir]);
        end
        cd(roi_dir)
        
%         command = ['invwarp --ref=' anat_ref ' --warp=' warp_file ' --out=' invWarp_file]
%         system(command)

        command = ['applywarp --ref=' anat_ref ' --in=' roi_mni ' --warp=' invWarp_file ' --out=roi_temp.nii.gz'];
        system(command);

        command = ['3dresample -prefix Resample.nii.gz -master ' nifti_dir sub '_Mean.nii.gz -inset roi_temp.nii.gz'];
        system(command);

        command = ['3dcalc -a Resample.nii.gz -b ' epi_mask_file ' -expr ''step(b)*a'' -prefix ' roi_native];
        system(command);

        command = 'rm Resample.nii.gz roi_temp.nii.gz';
        system(command);
    end
end