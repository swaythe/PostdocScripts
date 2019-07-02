subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub01','Sub02','Sub05','Sub06','Sub08','Sub10','Sub13'};
% baseSess = [1 1 2 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;
sess = 1:4;
roi_base = 'ROI_MECorr_005corr';
behav_file = '_BehavForTCNonRoi.mat';

corr = 1; % Correct (1) or incorrect (0) trials
tr = 1.8;
nRuns = length(sess)*4;

main_dir = '/home/sshankar/Categorization/Data/';

for subi = 1:length(subs)
    sub = subs{subi};
    imag_dir = [main_dir 'Imaging/' sub '/'];
    roi_dir = [imag_dir 'Session_' int2str(baseSess(subi)) '/' roi_base '/'];
    behav_dir = [main_dir 'Behavior/Scanner/' sub '/'];
    
    dirCohIds = zeros(64,nRuns);
    stimTimeIds = zeros(64,nRuns);
    residueST = zeros(64,nRuns);
    rCtr = 1;

    % Load behavioral data
    cd(behav_dir);
    for si = 1:length(sess)
        cd(['Session_' int2str(sess(si)) '/']);
        runs = dir('run*');
        % Get all the runs not used to create the ROIs originally
        runs = runs(3:end);
        
        for ri = 1:length(runs)
            cd(runs(ri).name);
            load([sub '.mat']);
            [temp dirCohIds(:,rCtr)] = sortrows(trialTab, [6 8]);
            if corr == 1
                stimTimeIds(:,rCtr) = ceil((temp(:,3) - scanTTLtimes1(1))/tr) .* temp(:,11); % Only correct trials
            else
                stimTimeIds(:,rCtr) = ceil((temp(:,3) - scanTTLtimes1(1))/tr) .* ~temp(:,11); % Only incorrect trials
            end
            residueST(:,rCtr) = stimTimeIds(:,rCtr) - ((temp(:,3) - scanTTLtimes1(1))/tr);
            rCtr = rCtr + 1;
            cd ..
        end
        cd ..
    end
    save([roi_dir sub behav_file], 'dirCohIds', 'stimTimeIds', 'residueST','sub', 'sess');
end