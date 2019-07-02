subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub01','Sub02','Sub05','Sub06','Sub08','Sub10','Sub13'};
% baseSess = [1 1 2 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;
sess = 1:4;
roi_base = 'ROI_3x3_005unc';

roi_common = 'Anova005unc';
roi_coord = [roi_common 'Coord'];
tc_file = ['_' roi_common 'TCGranger_all.mat'];
% behav_file = '_BehavForTC_full';
run_file = 'EPI_Task*Smooth*';
% corr = 1; % Correct (1) or incorrect (0) trials
tr = 1.8;
nRuns = length(sess)*6-6;

main_dir = '/home/sshankar/Categorization/Data/';

for subi = 1:length(subs)
    sub = subs{subi};
    imag_dir = [main_dir 'Imaging/' sub '/'];
    roi_dir = [imag_dir 'Session_' int2str(baseSess(subi)) '/' roi_base '/'];
    
%     % Load stimulus onset times from behavioral data
%     load([roi_dir sub behav_file]);

    % Get timecourses for the coordinates (voxels) extracted
    load([roi_dir sub '_' roi_coord])
    
    % Load imaging data
    % Data is stored in timecourse as follows:
    % Each column is a task run
    % Each row is the beta value at a TR
    % The third dimension is each ROI
    timecourse = zeros(300,nRuns,size(top_vox,1));
    
    cd(imag_dir);
    rCtr = 1;
    for si = 1:length(sess)
        cd(['Session_' int2str(sess(si)) '/NIFTIS/']);
%         command = ['gunzip ' run_file];
%         system(command);
        runs = dir(run_file); % List all unzipped CoReg files
        % Get all the runs not used to create the ROIs originally
        if sess(si)==1 || sess(si)==2
            runs = runs(3:end);
        else
            runs = runs(2:end);
        end
        
        for ri = 1:length(runs)
            epi = load_nii(runs(ri).name);
            epi = epi.img; % Image matrix
            for roi = 1:size(top_vox,1) % Each ROI
                for ci = 1:size(top_vox,2) % Each coordinate in each ROI
                    if ci == 1
                        tc = zeros(300,8);
                    end
                    % Extract the timeseries for the coordinate, but only
                    % if the coordinate exists (i.e, is not 0).
                    if top_vox(roi,ci,1) ~= 0 
                        tc(:,ci) = squeeze(epi(top_vox(roi,ci,1),top_vox(roi,ci,2),top_vox(roi,ci,3),:));
                    end
                end
                timecourse(:,rCtr,roi) = mean(tc,2);
            end
            rCtr = rCtr + 1;
        end
        cd ../..
    end

    save([roi_dir sub tc_file], 'timecourse', 'sub', 'sess', 'rCtr');
end