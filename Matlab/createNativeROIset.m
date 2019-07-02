% subs = {'Sub11'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub11','Sub13'};
% baseSess = [1 1];

roi_common = 'MEPosPositive';
folder_prefix = 'ME';
main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
roi_dir = ['ROI_3x3_005unc_' folder_prefix '/'];

for si = 1:length(subs)
    sub = subs{si};
    op_prefix = [sub roi_common '.nii.gz'];
    subj_dir = [data_dir sub '/Session_' int2str(baseSess(si)) '/' roi_dir];
    cd(subj_dir);
    
    rois = dir(['*' roi_common '*.nii.gz']);
    command = ['3dmerge -prefix ' op_prefix ' -gorder '];
    
    for ri = 1:length(rois)
        calc_command = ['3dcalc -overwrite -a ' rois(ri).name ' -expr ''a*' int2str(ri) ''' -prefix ' rois(ri).name];
        system(calc_command)
        command = [command rois(ri).name ' '];
    end
    system(command)
end