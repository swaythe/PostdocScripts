% subs = {'Sub01'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
nStim = 20; 

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
tcdir_prefix = 'GLM_TC';
roi_common = 'AnovaRoiCorr';
roidir_prefix = 'ROI_AnovaCorr_005unc';
file_prefix = 'Corr';
op_file = [roi_common '_TC' file_prefix];

for si = 1:length(subs)
    sub = subs{si};
    tc_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' tcdir_prefix '/'];
    roi_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' roidir_prefix '/'];
    coord = load([roi_dir sub '_' roi_common 'Coord']);
    coord = coord.top_vox;
    
    fRoi = dir([roi_dir '*' roi_common 'Positive*']);
    tcMat = zeros(nStim,201,15,length(fRoi));
    tcMatSD = zeros(nStim,201,15,length(fRoi));
    
    for ri = 1:length(fRoi)
        crd = squeeze(coord(ri,:,:));
        if crd(1,1) ~= 0
            for ti = 1:nStim
                command = ['3dmaskdump -mask ' roi_dir fRoi(ri).name ' -o ' tc_dir 'TCROI ' tc_dir 'TCNonRoi' file_prefix int2str(ti) '.nii.gz'];
                system(command)
                tc_temp = load([tc_dir 'TCROI']);
                
                command = ['3dmaskdump -mask ' roi_dir fRoi(ri).name ' -o ' tc_dir 'TCROIsd ' tc_dir 'TCsdNonRoi' file_prefix int2str(ti) '.nii.gz'];
                system(command)
                tc_temp_sd = load([tc_dir 'TCROIsd']);

                for ci = 1:size(crd,1)
                    idx = find(tc_temp(:,1)==crd(ci,1)-1 & tc_temp(:,2)==crd(ci,2)-1 & tc_temp(:,3)==crd(ci,3)-1);
                    if ~isempty(idx)
                        tcMat(ti,:,ci,ri) = tc_temp(idx,4:end);
                        tcMatSD(ti,:,ci,ri) = tc_temp_sd(idx,4:end);
                    else
                        disp('boo')
                    end
                end

                command = ['rm ' tc_dir 'TCROI ' tc_dir 'TCROIsd'];
                system(command)
            end
        else
            tcMat(:,:,:,ri) = NaN;
            tcMatSD(:,:,:,ri) = NaN;
            sprintf('Empty ROI %d ', ri)
        end
    end    
    save([tc_dir sub '_' op_file], 'tcMat', 'tcMatSD')
    cd(tc_dir)
    load([sub '_' op_file])
    tcMax = nanmax(nanmax(nanmax(nanmax(tcMat))));
    tcAvg = squeeze(nanmean(tcMat,3));
    ntcAvg = tcAvg/tcMax;
    tcSD1 = squeeze(nanmean(tcMatSD,3));
    tcSD = squeeze(sqrt(nansum(tcMatSD.*tcMatSD,3)))/8;
    ntcSD = tcSD/tcMax;
    save([tc_dir sub '_' op_file 'Avg'], 'tcAvg', 'tcSD', 'ntcAvg', 'ntcSD')
end