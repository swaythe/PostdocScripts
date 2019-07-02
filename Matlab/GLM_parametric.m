format compact;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1];
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub08'};
% baseSess = 1;
sessId = 1:4;
tr = 1800;

nStim = 9;
stimFile1 = 'STCohAllDir90_Corr.1D';
stimLabel1 = 'D90ParamCohCorrect';
stimFile2 = 'STnotD90.1D';
stimLabel2 = 'AllOtherCorrect';
stimFile3 = 'STIncAbort.1D';
stimLabel3 = 'IncorrectAbort';
glm_prefix = '_D90ParamCohCorrect';
errts_prefix = [glm_prefix '_errts'];
mask_suffix = '_Mask.nii.gz';

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
epi_dir = 'NIFTIS/';

for si = 1:length(subs)
    sub = subs{si};
    subj_dir = [data_dir sub '/']; 
    nifti_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/' epi_dir];
    glm_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/GLM/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];

    mask_prefix = [subj_dir 'Session_' int2str(baseSess(si)) '/' epi_dir sub mask_suffix];
    
    runList = [];
    for sessi = 1:length(sessId)
        sess_dir = [subj_dir 'Session_' num2str(sessId(sessi)) '/'];
        cd([sess_dir epi_dir]);
        gFiles = dir('EPI*Smooth*');
        for gi = 1:length(gFiles)
            runList = [runList sess_dir epi_dir gFiles(gi).name ' '];
        end
    end

    PathOut = [glm_dir sub glm_prefix '.nii.gz'];
    PathOutCR = [glm_dir sub glm_prefix '_RegCoeff.nii.gz'];
    PathOut1D = [glm_dir sub glm_prefix '_x1D.txt'];
    DesMat = [glm_dir sub '_design_matrix' glm_prefix '.jpg'];
    errOut = [glm_dir sub errts_prefix '.nii.gz'];

    % diary([subj_dir sub '_diary_GLM1_' date]);

    stims = [' -stim_times_AM2 1 ' stimTime_dir stimFile1 ' GAM -stim_label 1 ' stimLabel1];
    stims = [stims ' -stim_times 2 ' stimTime_dir stimFile2 ' GAM -stim_label 2 ' stimLabel2];
    stims = [stims ' -stim_times 3 ' stimTime_dir stimFile3 ' GAM -stim_label 3 ' stimLabel3];
    count = 3;

    command = ['3dDeconvolve -input ' runList ' ' ... 
        '-mask ' mask_prefix ' -num_stimts ' num2str(nStim) ' -local_times' ...
        stims ' '];

    nuis_files = dir([glm_dir 'nuis*.1D']);
    for l1 = 1:length(nuis_files)
        count = count+1;
        command = [command '-stim_file ' int2str(count) ' ' glm_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];

        % The next line ensures that nuisance variables don't get included
        % in the baseline as an effect of interest.
        command = [command '-stim_base ' int2str(count) ' '];
    end

%     command = [command '-errts ' errOut ' '];
    command = [command '-polort A -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D ' -GOFORIT 99']; % ' -allzero_OK -GOFORIT 99']; % Try the command with and without the GOFORIT option
    system(command)

    system(['mv *.xsave ' glm_dir])
end
