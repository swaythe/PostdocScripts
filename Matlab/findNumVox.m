% To calculate number of voxels in individual subject ROIs
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02','Sub04'};
% baseSess = [1 1];

roi_common = 'PEDistPositive';
folder_prefix = 'PEDistCorr';
main_dir = '/home/sshankar/Categorization/Data/Imaging/';

for si = 1:length(subs)
    sub = subs{si};
    sub_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/FullDataROI_' folder_prefix '_005corr/'];
    cd(sub_dir)
    
    command = ['gunzip *' roi_common '*.gz'];
    system(command)
    
    rds = dir('*.nii');
    if si == 1
        num_vox = zeros(length(subs),length(rds));
    end

    for ri = 1:length(rds)
        a = load_nii(rds(ri).name);
        a = a.img;
        num_vox(si,ri) = length(find(a==1));
    end

    command = 'gzip *nii';
    system(command)
end

% % To calculate number of voxels in group ROIs
% roi_common = 'AnovaRoiCorr';
% folder_prefix = 'AnovaCorr';
% main_dir = ['/home/sshankar/Categorization/Data/Imaging/All/ROI_' folder_prefix '_005unc/'];
% 
% cd(main_dir)
% command = ['gunzip ' roi_common '*.gz'];
% system(command)
% rds = dir(['*' roi_common '*.nii']);
% num_vox = zeros(1,length(rds)-1);
% 
% % The for loop starts with 2 because the first file is the composite ROI
% % file containing all ROIs
% for ri = 2:length(rds)
%     a = load_nii(rds(ri).name);
%     a = a.img;
%     num_vox(ri-1) = length(find(a==1));
% end
% 
% command = 'gzip *nii';
% system(command)
