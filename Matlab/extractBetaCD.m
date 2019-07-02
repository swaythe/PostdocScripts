subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

% subs = {'Sub05'};
% baseSess = 2;

main_dir = '/home/sshankar/Categorization/Data/';
im_dir = 'Imaging/';
beh_dir = 'Behavior/Scanner/';
roi_dir = 'ROI_MECorr_005corr_bigROI';
coord_file = 'MECorrCoord';

% rois = [10, 12, 13, 20, 22, 24, 27]; % For MECorr_005corr
rois = [4, 5, 6, 8, 9, 10, 11, 12, 13]; % For MECorr_005corr_bigROI

nVox = 15;
betas = cell(length(subs),length(rois),20,2);
idxs = cell(length(subs),length(rois),20);
coords = zeros(nVox,3,length(rois),length(subs));

for si = 1:length(subs)
    % Load the behavior file 
    load([main_dir beh_dir subs{si} '/' subs{si} '_allTT'])
    cohs = unique(collData(:,3));
    dirs = unique(abs(collData(:,2)));

    % Load the single trial betas file from GLM_TC
    dat = load_nii([main_dir im_dir subs{si} '/Session_' int2str(baseSess(si)) '/GLM_TC/' subs{si} '_SingleTrial.nii']);
    dat = dat.img;
    
    % Load the ROI voxel coordinates from the Coord file in the ROI
    % directory
    load([main_dir im_dir subs{si} '/Session_' int2str(baseSess(si)) '/' roi_dir '/' subs{si} '_' coord_file])
    for ri = 1:length(rois)
        coords(:,:,ri,si) = squeeze(top_vox(ri,:,:));
    end
    
    cdCtr = 1;
    for ci = 1:length(cohs)
        for di = 1:ceil(length(dirs)/2)
            for ri = 1:length(rois)
                top_coord = squeeze(coords(1,:,ri,si));
                % To deal with Sub05 distance weirdness, first make sure
                % subject in question is Sub05
                if strcmp(subs{si},'Sub05')==0
                    ids = find((abs(collData(:,2))==dirs(di) | abs(collData(:,2))==dirs(10-di)) & collData(:,3)==cohs(ci) & collData(:,4)==1);
                % Weirdness is in di=4 and di=5 (which should be considered
                % the same
                elseif di~=4 || di~=5
                    ids = find((abs(collData(:,2))==dirs(di) | abs(collData(:,2))==dirs(11-di)) & collData(:,3)==cohs(ci) & collData(:,4)==1);
                elseif di~=5
                    % Pool together data from di = 4, 5, 7
                    ids = find((abs(collData(:,2))==dirs(4) | abs(collData(:,2))==dirs(5) | abs(collData(:,2))==dirs(7)) & collData(:,3)==cohs(ci) & collData(:,4)==1);
                else
                    % And now address di = 6 (90 deg)
                    ids = find(abs(collData(:,2))==dirs(6) & collData(:,3)==cohs(ci) & collData(:,4)==1);
                end
                betas{si,ri,cdCtr,1} = squeeze(dat(top_coord(1),top_coord(2),top_coord(3),1,ids.*2-1));
                cs = squeeze(coords(:,:,ri,si));
                for cdi = 1:nVox
                    betas{si,ri,cdCtr,2} = [betas{si,ri,cdCtr,2} squeeze(dat(cs(cdi,1),cs(cdi,2),cs(cdi,3),1,ids.*2-1))];
                end
                idxs{si,ri,cdCtr} = ids;
            end
            cdCtr = cdCtr + 1;
        end
    end
end
save([main_dir im_dir 'All/' roi_dir '/betasCD'],'betas','coords','idxs')
