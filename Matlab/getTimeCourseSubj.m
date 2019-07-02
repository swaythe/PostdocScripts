subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub01','Sub02','Sub05','Sub06','Sub08','Sub10','Sub13'};
% baseSess = [1 1 2 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;
sess = 1:4;
roi_base = 'ROI_MECorr_005corr';

roi_common = 'MECorr';
roi_coord = [roi_common 'Coord'];
tc_file = ['_' roi_common 'TC_CoReg.mat'];
behav_file = '_BehavForTCNonRoi';
run_file = 'EPI_Task*CoReg*';
% corr = 1; % Correct (1) or incorrect (0) trials
tr = 1.8;
nRuns = length(sess)*4;

main_dir = '/home/sshankar/Categorization/Data/';

for subi = 1:length(subs)
    sub = subs{subi};
    imag_dir = [main_dir 'Imaging/' sub '/'];
    roi_dir = [imag_dir 'Session_' int2str(baseSess(subi)) '/' roi_base '/'];
    tc_dir = [imag_dir 'Session_' int2str(baseSess(subi)) '/GLM_TC/'];
    
    % Load stimulus onset times from behavioral data
    load([roi_dir sub behav_file]);

    % Get timecourses for the coordinates (voxels) extracted
    load([roi_dir sub '_' roi_coord])
    
    % Load imaging data
    % Data is stored in timecourse as follows:
    % Each column is the intensity values for 10 TRs following stimulus onset
    % Each row is the coh-dir combination in ascending order
    % The third dimension is each individual run
    % The fourth dimension is each individual voxel 
    % The fifth dimension is each individual ROI
    timecourse = zeros(64,10,nRuns,size(top_vox,2),size(top_vox,1));
    timecourse_norm = zeros(64,10,nRuns,size(top_vox,2),size(top_vox,1));
    
    cd(imag_dir);
    rCtr = 1;
    for si = 1:length(sess)
        cd(['Session_' int2str(sess(si)) '/NIFTIS/']);
%         command = ['gunzip ' run_file];
%         system(command);
        runs = dir(run_file); % List all unzipped CoReg files
        % Get all the runs not used to create the ROIs originally
        runs = runs(3:end);
        
        for ri = 1:length(runs)
            epi = load_nii(runs(ri).name);
            epi = epi.img; % Image matrix
            for roi = 1:size(top_vox,1) % Each ROI
                for ci = 1:size(top_vox,2) % Each coordinate in each ROI
                    % Extract the timeseries for the coordinate, but only
                    % if the coordinate exists (i.e, is not 0).
                    if top_vox(roi,ci,1) ~= 0 
                        tc = squeeze(epi(top_vox(roi,ci,1),top_vox(roi,ci,2),top_vox(roi,ci,3),:));
                        for i = 1:64
                            if stimTimeIds(i,rCtr) ~= 0 && max(tc(stimTimeIds(i,rCtr):stimTimeIds(i,rCtr)+9)) ~= 0
                                timecourse(i,:,rCtr,ci,roi) = tc(stimTimeIds(i,rCtr):stimTimeIds(i,rCtr)+9)';
                                timecourse_norm(i,:,rCtr,ci,roi) = (tc(stimTimeIds(i,rCtr):stimTimeIds(i,rCtr)+9)/max(tc(stimTimeIds(i,rCtr):stimTimeIds(i,rCtr)+9)))';
                            end
                        end
                    end
                end
            end
            rCtr = rCtr + 1;
        end
%         command = ['gzip ' run_file];
%         system(command);
        cd ../..
    end

    save([tc_dir sub tc_file], 'timecourse', 'timecourse_norm', 'sub', 'sess', 'rCtr');
end