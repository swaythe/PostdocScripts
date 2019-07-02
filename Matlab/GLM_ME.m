format compact;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02'};
% baseSess = 1;
sessId = 1:4;

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
glm_prefix = '_ME_ROI';

nStim = 9; % 26 when all coh-dir combos go into one GLM file
stimFiles = cell(nStim-6,1);
stimFiles{1} = 'STMECorrRoi.1D';
stimFiles{2} = 'STMEIncRoi.1D';
stimFiles{3} = 'STAbortedRoi.1D';

stimLabels = cell(nStim-6,1);
stimLabels{1} = 'CorrectROI';
stimLabels{2} = 'IncorrectROI';
stimLabels{3} = 'AbortedROI';

for si = 1:length(subs)
    sub = subs{si};
    subj_dir = [data_dir sub '/']; 

    runList = [];
    for sessi = 1:length(sessId)
        sess_dir = [subj_dir 'Session_' num2str(sessId(sessi)) '/'];
        cd([sess_dir 'NIFTIS/']);
        gFiles = dir('EPI*Smooth*');
        gFiles = gFiles([1 2]);
        for gi = 1:length(gFiles)
            runList = [runList sess_dir 'NIFTIS/' gFiles(gi).name ' '];
        end
    end

    nifti_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/NIFTIS/'];
    glm_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/GLM/'];
    nuis_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/Nuisance_params/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];
    PathOut = [glm_dir sub glm_prefix '.nii.gz'];
    PathOut1D = [glm_dir sub glm_prefix '_x1D.txt'];
    DesMat = [glm_dir sub '_design_matrix' glm_prefix '.jpg'];

    cd(nifti_dir);

%     diary([subj_dir sub '_diary_GLM1_' date]);
    mask_prefix = [subj_dir 'Session_' int2str(baseSess(si)) '/NIFTIS/' sub '_Mask.nii.gz'];

    stims = [];
    for count = 1:nStim-6
        stims = [stims '-stim_times ' int2str(count) ' ' stimTime_dir stimFiles{count} ' GAM -stim_label ' int2str(count) ' ' stimLabels{count} ' '];
    end
    
    command = ['3dDeconvolve -input ' runList ' '...
        '-mask ' mask_prefix ' -num_stimts ' num2str(nStim) ' -local_times ' ...
        stims ' '];

    % Specify the nuisance files (motions parameters)
    nuis_files = dir([nuis_dir 'NuisanceROI*.1D']);
    for l1 = 1:length(nuis_files)
        count = count+1;
        command = [command '-stim_file ' int2str(count) ' ' nuis_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
    end

    % Finish up the command
    command = [command '-polort A -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; 

    system(command)
end