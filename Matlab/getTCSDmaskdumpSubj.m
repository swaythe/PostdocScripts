subs = {'Sub02'};
baseSess = 1;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
nStim = 1; %20; 

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
tcdir_prefix = 'GLM_TC';
roi_common = 'Anova005unc';
folder_prefix = '';
roidir_prefix = ['ROI_3x3_005unc' folder_prefix];
op_file = [roi_common '_TC'];

for si = 1:length(subs)
    sub = subs{si};
    tc_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' tcdir_prefix '/'];
    roi_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' roidir_prefix '/'];
    coord = load([roi_dir sub '_' roi_common 'Coord']);
    coord = coord.top_vox;
    
    fRoi = dir([roi_dir '*' roi_common 'Positive*']);
    tcMatSD = zeros(nStim,201,8,length(fRoi));
    
    for ri = 1:1 %length(fRoi)
        crd = squeeze(coord(ri,:,:));
        if crd(1,1) ~= 0
            for ti = 1:nStim
                command = ['3dmaskdump -mask ' roi_dir fRoi(ri).name ' -o ' tc_dir 'TCROI ' tc_dir 'TC' int2str(ti) 'sd.nii.gz'];
                system(command)
                tc_temp = load([tc_dir 'TCROI']);

                for ci = 1:size(crd,1)
                        idx = find(tc_temp(:,1)==crd(ci,1)-1 & tc_temp(:,2)==crd(ci,2)-1 & tc_temp(:,3)==crd(ci,3)-1);
                        if ~isempty(idx)
                            tcMat(ti,:,ci,ri) = tc_temp(idx,4:end);
                        else
                            disp('boo')
                        end
                end

                command = ['rm ' tc_dir 'TCROI'];
                system(command)
            end
        else
            tcMatSD(:,:,:,ri) = NaN;
            sprintf('Empty ROI %d ', ri)
        end
    end    
%     save([tc_dir sub '_' op_file], 'tcMat')
    tcAvgSD = squeeze(nanmean(tcMatSD,3));
%     save([tc_dir sub '_' op_file 'Avg'], 'tcAvg')
end