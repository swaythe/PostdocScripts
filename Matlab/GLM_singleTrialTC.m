format compact;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 2 1 1 1 1 1];
subs = {'Sub01'};
baseSess = 1;
sessId = 1:4;

main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
stimFile_prefix = 'STSingleTrial';
glmFile = '_SingleTrial.nii.gz';
fitFile = '_SingleTrialFit.nii.gz';
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
    glm_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/GLM_TC/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];

    cd(glm_dir);
        
%     stims = ['-stim_times_IM 1 ' stimTime_dir stimFile_prefix '.1D ''CSPLIN(0,8,4)'' -stim_label 1 ' stimFile_prefix];
    stims = ['-stim_times_IM 1 ' stimTime_dir stimFile_prefix '.1D GAM -stim_label 1 ' stimFile_prefix];
    
    command = ['3dDeconvolve -input ' runList ' -num_stimts ' num2str(nStim) ...
        ' -local_times ' stims ' -float -polort A -tout -nobout -jobs 15' ...
        ' -fitts ' glm_dir sub fitFile ' -nobucket']; % ' glm_dir sub glmFile];


    system(command)
end
