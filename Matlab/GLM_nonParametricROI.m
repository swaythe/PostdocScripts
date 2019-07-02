format compact;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 2 1 1 1 1 1];
% subs = {'Sub01'};
% baseSess = 1;
sessId = 1:4;
nStim = 47; 

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
glm_prefix = '_ComboCDRoiAlt';
stimFile_prefix = 'STRoiAlt';

% Stimulus time files
stimFiles = cell(nStim-6,1);
% Correct stimulus times
for sti = 1:20
    stimFiles{sti} = [stimFile_prefix 'Corr' int2str(sti) '.1D'];
end
% Incorrect stimulus times
for sti = 21:40
    stimFiles{sti} = [stimFile_prefix 'Inc' int2str(sti-20) '.1D'];
end
% Aborted stimulus times
stimFiles{sti+1} = 'STAbortedRoiAlt.1D';

% Stimulus labels
stimLabels = cell(nStim-6,1);
% Correct labels
for sti = 1:20
    stimLabels{sti} = ['CDRoiCorr',int2str(sti)];
end
% Incorrect labels
for sti = 21:40
    stimLabels{sti} = ['CDRoiInc',int2str(sti-20)];
end
% Aborted labels
stimLabels{sti+1} = 'AbortedRoi';


for si = 1:length(subs)
    sub = subs{si};
    subj_dir = [data_dir sub '/']; 

    runList = [];
    for sessi = 1:length(sessId)
        sess_dir = [subj_dir 'Session_' num2str(sessId(sessi)) '/'];
        cd([sess_dir 'NIFTIS/']);
        gFiles = dir('EPI*Smooth*');
        gFiles = gFiles(end-1:end);
%         gFiles = gFiles(3:end);
        
        for gi = 1:length(gFiles)
            runList = [runList sess_dir 'NIFTIS/' gFiles(gi).name ' '];
        end
    end

    glm_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/GLM/'];
    nuis_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/Nuisance_params/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];
    PathOut = [glm_dir sub glm_prefix '.nii.gz'];
    PathOutCR = [glm_dir sub glm_prefix '_RegCoeff.nii.gz'];
    PathOut1D = [glm_dir sub glm_prefix '_x1D.txt'];
    DesMat = [glm_dir sub '_design_matrix' glm_prefix '.jpg'];

    diary([subj_dir sub '_diary_GLM1_' date]);
    mask_prefix = [subj_dir 'Session_' int2str(baseSess(si)) '/NIFTIS/' sub '_Mask.nii.gz'];
    stims = [];

    for count = 1:nStim-6
        stims = [stims '-stim_times ' int2str(count) ' ' stimTime_dir stimFiles{count} ' GAM -stim_label ' int2str(count) ' ' stimLabels{count} ' '];
    end

    command = ['3dDeconvolve -input ' runList ' '...
        '-mask ' mask_prefix ' -num_stimts ' num2str(nStim) ' -local_times ' ...
        stims ' '];

    % Specify the nuisance files (motions parameters)
    nuis_files = dir([nuis_dir 'NuisanceROIAlt*.1D']);
    for l1 = 1:length(nuis_files)
        count = count+1;
        command = [command '-stim_file ' int2str(count) ' ' nuis_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
    end

    % Finish up the command
    command = [command '-polort A -allzero_OK -GOFORIT 99 -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; 

    system(command)
    system(['mv *.xsave ' glm_dir])
end