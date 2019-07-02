format compact;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
subs = {'Sub01'};
baseSess = 1;
sessId = 1:4;
tr = 1800;
nTR = 300;

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
behav_dir = [main_dir 'Data/Behavior/Scanner/'];
data_dir = [main_dir 'Data/Imaging/'];
glm_prefix = '_GLM_SingleTrialTC';
stimFile_prefix = 'STSingleTrial';
irespFile = 'SingleTrialTC.nii.gz';
nStim = 1;

for si = 1:length(subs)
    sub = subs{si};
    subj_dir = [data_dir sub '/']; 

    runList = [];
    for sessi = 1:length(sessId)
        sess_dir = [subj_dir 'Session_' num2str(sessId(sessi)) '/'];
        cd([sess_dir 'NIFTIS/']);
        gFiles = dir('EPI*Smooth*');
        for gi = 1:length(gFiles)
            runList = [runList sess_dir 'NIFTIS/' gFiles(gi).name ' '];
        end
    end

    nifti_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/NIFTIS/'];
    glm_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/GLM/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];
    PathOut = [glm_dir sub glm_prefix '.nii.gz'];
    PathOutCR = [glm_dir sub glm_prefix '_RegCoeff.nii.gz'];
    PathOut1D = [glm_dir sub glm_prefix '_x1D.txt'];
    DesMat = [glm_dir sub '_design_matrix' glm_prefix '.jpg'];

    cd(glm_dir);
    mask_prefix = [subj_dir 'Session_' int2str(baseSess(si)) '/NIFTIS/' sub '_Mask.nii.gz'];
        
    stims = ['-stim_times_IM 1 ' stimTime_dir stimFile_prefix '.1D GAM -stim_label 1 ' stimFile_prefix];
    
    command = ['3dDeconvolve -input ' runList ' '...
        '-mask ' mask_prefix ' -num_stimts ' num2str(nStim+6) ' -local_times ' ...
        stims ' '];

    % Specify the nuisance files (motions parameters)
    nuis_files = dir([glm_dir 'nuisance*.1D']);
    count = nStim+1;
    for l1 = 1:length(nuis_files)
        command = [command '-stim_file ' int2str(count) ' ' glm_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
        count = count + 1;
    end

    command = [command '-iresp ' int2str(count) ' ' glm_dir irespFile ' '];
    
    % Finish up the command
    command = [command '-polort A -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; 

    system(command)
end
