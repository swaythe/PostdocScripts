subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02'};
% baseSess = 1;

folder_prefix = 'AnovaCorr';
roi_common = 'AnovaRoiCorr';
main_dir = '/home/sshankar/Categorization/Data/Imaging/';
roi_name = ['ROI_' folder_prefix '_005unc'];
glm_name = 'GLM/';
group_dir = [main_dir 'All/' roi_name '/'];
tbrik = 1; % T-statistic brik for map of interest
sOrder = 'descend'; % Order of sorting of thresholds: descend = more +ve to less +ve; ascend = more -ve to less -ve

cd(group_dir)

% Get the number of ROIs in this set
load nVox_native;
vMat = eval(['nVox_' folder_prefix 'Positive']);
nROI = size(vMat,2);
minROIvox = 15; % Minimum number of voxels the ROI should contain
nTSvox = 15; % Number of voxels extracted to evaluate timeseries, per ROI

for si = 1:length(subs)    
    sub = subs{si};
    glm_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' glm_name];
    roi_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' roi_name];
    afile = [glm_dir sub '_ME_ROI.nii.gz[' int2str(tbrik) ']'];
    
    cd(roi_dir)
    top_vox = zeros(nROI,nTSvox,3);

    rds = dir(['*' roi_common 'Positive*']);
    for ri = 1:length(rds)
        bfile = rds(ri).name;
        if vMat(si,ri) >= minROIvox
            % Extract the voxels corresponding to each ROI 
            % The base dataset is the one corresponding to 'afile'
            command = ['3dcalc -a ' afile ' -b ' bfile ' -expr ''a*b'' -prefix temp.nii.gz '];
            system(command)
            command = 'gunzip temp.nii.gz';
            system(command)
            roi_vol = load_nii('temp.nii');
            roi_vol = roi_vol.img;
            ids = find(roi_vol ~= 0);
            thresh = roi_vol(ids);
            [s sIds] = sort(thresh,sOrder);

            [x y z] = ind2sub(size(roi_vol), ids(sIds));
            top_vox(ri,:,1) = x(1:nTSvox);
            top_vox(ri,:,2) = y(1:nTSvox);
            top_vox(ri,:,3) = z(1:nTSvox);
            
            command = 'rm temp.nii';
            system(command);
        end
    end
    save([sub '_' roi_common 'Coord.mat'],'top_vox');
end
