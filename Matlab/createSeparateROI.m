num_roi = 28;
input_prefix = 'PEDist';
folder_prefix = 'PEDistCorr';
roi_folder = ['/home/sshankar/Categorization/Data/Imaging/All/FullDataROI_' folder_prefix '_005corr/'];

input_file = [roi_folder input_prefix '.nii.gz'];

for ri = 1:num_roi
    if ri>=10
        output_file = [roi_folder input_prefix int2str(ri) '.nii.gz'];
    else
        output_file = [roi_folder input_prefix '0' int2str(ri) '.nii.gz'];
    end
    command = ['3dcalc -a ' input_file ' -expr ''iszero(a-' int2str(ri) ')'' -prefix ' output_file];
    system(command)
end