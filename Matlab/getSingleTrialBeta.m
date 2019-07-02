% subs = {'Sub01'};
% baseSess = 1;
% subs = {'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 2 1 1 1 1 1];
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

roi_common = 'AnovaCorr';
coord_prefix = ['ROI_' roi_common '_005unc/'];
betaMat_prefix = ['_betaMat_' roi_common];
main_dir = '/home/sshankar/Categorization/Data/';
im_dir = [main_dir 'Imaging/'];
beh_dir = [main_dir 'Behavior/Scanner/'];
glm_prefix = 'GLM_TC/';
singTr_prefix = 'SingleTrial/';

% Do the following for every subject
for si = 1:length(subs)
    sub = subs{si};
    glm_dir = [im_dir sub '/Session_' int2str(baseSess(si)) '/' glm_prefix];
    coord_dir = [im_dir sub '/Session_' int2str(baseSess(si)) '/' coord_prefix];
    singTr_dir = [im_dir sub '/Session_' int2str(baseSess(si)) '/' singTr_prefix];
    tt_dir = [beh_dir sub];
    
    % Load behavioral data
    cd(tt_dir)
    load([sub '_allTT'])
    % Load the ROI coordinate matrix
    cd(coord_dir)
    cFile = dir('*Coord*');
    load(cFile.name)
    % Load the GLM file
    cd(glm_dir)
    system('gunzip *SingleTrial.nii.gz');
    betas = load_nii([sub '_SingleTrial.nii']);
    betas = betas.img();
    x = betas(:,:,:,:,2:2:size(betas,5));
    betas = squeeze(x);
    system('gzip *SingleTrial.nii');
    
    % Create output matrix
    betaMat = zeros(size(betas,4),size(top_vox,1),size(top_vox,2)+1);
        
    % Do the following for every trial
    for ti = 1:size(betas,4)
        % Do the following for every ROI
        for roi = 1:size(top_vox,1)
            vox = squeeze(top_vox(roi,:,:));
            roiBeta = zeros(1,size(vox,1));
            % Do the following for every coordinate in each non-zero ROI
            if vox(1,1) ~= 0
                for cdi = 1:size(vox,1)
                    roiBeta(cdi) = betas(vox(cdi,1),vox(cdi,2),vox(cdi,3),ti);
                    betaMat(ti,roi,cdi+1) = roiBeta(cdi);
                end
            end
            betaMat(ti,roi,1) = mean(roiBeta);
        end
    end
    
    cd([main_dir '/Behavior/'])
    load(['DirCoh' sub])
    cohs = unique(DirCoh(:,2))*100;
    dist = unique(abs(DirCoh(:,1)));
    betas = cell(length(cohs),ceil(length(dist)/2),size(top_vox,1));
    betac = cell(length(cohs),ceil(length(dist)/2),size(top_vox,1));
    betai = cell(length(cohs),ceil(length(dist)/2),size(top_vox,1));
    rts = cell(length(cohs),ceil(length(dist)/2));
    rtc = cell(length(cohs),ceil(length(dist)/2));
    rti = cell(length(cohs),ceil(length(dist)/2));
    
    for ci = 1:length(cohs)
        for di = 1:length(dist)
            ids = find(collData(:,3)==cohs(ci) & abs(collData(:,2))==dist(di));
            idc = find(collData(:,3)==cohs(ci) & abs(collData(:,2))==dist(di) & collData(:,4)==1);
            idi = find(collData(:,3)==cohs(ci) & abs(collData(:,2))==dist(di) & collData(:,4)==0);
            if di > 5
                dii = 10 - di;
            else
                dii = di;
            end
            rts{ci,dii} = [rts{ci,dii}; collData(ids,5)];
            rtc{ci,dii} = [rtc{ci,dii}; collData(idc,5)];
            rti{ci,dii} = [rti{ci,dii}; collData(idi,5)];
            for roi = 1:size(top_vox,1)
                betas{ci,dii,roi} = [betas{ci,dii,roi}; squeeze(betaMat(ids,roi,1))];
                betac{ci,dii,roi} = [betac{ci,dii,roi}; squeeze(betaMat(idc,roi,1))];
                betai{ci,dii,roi} = [betai{ci,dii,roi}; squeeze(betaMat(idi,roi,1))];
            end
        end
    end
    
    betaCs = cell(length(cohs),size(top_vox,1));
    betaCc = cell(length(cohs),size(top_vox,1));
    betaCi = cell(length(cohs),size(top_vox,1));
    
    for ci = 1:length(cohs)
        for ri = 1:size(top_vox,1)
            betaCs{ci,ri} = cat(1,betas{ci,:,ri});
            betaCc{ci,ri} = cat(1,betac{ci,:,ri});
            betaCi{ci,ri} = cat(1,betai{ci,:,ri});
        end
    end
    
    betaDs = cell(ceil(length(dist)/2),size(top_vox,1));
    betaDc = cell(ceil(length(dist)/2),size(top_vox,1));
    betaDi = cell(ceil(length(dist)/2),size(top_vox,1));
    
    for di = 1:ceil(length(dist)/2)
        for ri = 1:size(top_vox,1)
            betaDs{di,ri} = cat(1,betas{:,di,ri});
            betaDc{di,ri} = cat(1,betac{:,di,ri});
            betaDi{di,ri} = cat(1,betai{:,di,ri});
        end
    end
    
    rtMat = collData(:,5);
    
    save([singTr_dir sub betaMat_prefix], 'betaMat', 'rtMat', 'betas', 'betac', 'betai', 'rts', 'rtc', 'rti', 'betaCs', 'betaCc', 'betaCi', 'betaDs', 'betaDc', 'betaDi')
end

