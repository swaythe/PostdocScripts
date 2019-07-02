% To create ROIs I'm using the first two runs from Session2 of each subject

format compact;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub11'};
% baseSess = 1;
sessId = 1:4;
nStim = 7;
tr = 1800;

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
epi_dir = 'NIFTIS/';

mask_suffix = '_Mask.nii.gz';
stimFile1 = 'STDallC100nonroi.1D';
stimLabel1 = 'STDallC100nonroi';
glm_prefix = '_GLM_STDallC100nonroi';
    
for si = 1:length(subs)
    sub = subs{si};
    subj_dir = [data_dir sub '/']; 
    nifti_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/' epi_dir];
    glm_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/GLM/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];

    mask_prefix = [subj_dir 'Session_' int2str(baseSess(si)) '/' epi_dir sub mask_suffix];
    % mask_prefix = [subj_dir 'Session_' int2str(1) '/' epi_dir sub mask_suffix];

    runList = [];
    for sessi = 1:length(sessId)
        sess_dir = [subj_dir 'Session_' num2str(sessId(sessi)) '/'];
        cd([sess_dir epi_dir]);
        gFiles = dir('EPI*Smooth*');
        if sessId(sessi)==1 || sessId(sessi)==2
            gFiles = gFiles(3:end);
        else
            gFiles = gFiles(2:end);
        end
        for gi = 1:length(gFiles)
            runList = [runList sess_dir epi_dir gFiles(gi).name ' '];
        end
    end
    
    PathOut = [glm_dir sub glm_prefix '.nii.gz'];
    PathOutCR = [glm_dir sub glm_prefix '_RegCoeff.nii.gz'];
    PathOut1D = [glm_dir sub glm_prefix '_x1D.txt'];
    DesMat = [glm_dir sub '_design_matrix' glm_prefix '.jpg'];

    count = 1;
    stims = [' -stim_times_AM2 ' int2str(count) ' ' stimTime_dir stimFile1 ' GAM -stim_label ' int2str(count) ' ' stimLabel1];
    
    command = ['3dDeconvolve -input ' runList ' ' ... 
        '-mask ' mask_prefix ' -num_stimts ' num2str(nStim) ' -local_times' ...
        stims ' '];

    nuis_files = dir([glm_dir 'NuisanceNonROI*.1D']);
    for l1 = 1:length(nuis_files)
        count = count+1;
        command = [command '-stim_file ' int2str(count) ' ' glm_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];

        % The next line ensures that nuisance variables don't get included
        % in the baseline / as an effect of interest.
        command = [command '-stim_base ' int2str(count) ' '];
    end

    command = [command '-polort A -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; % ' -allzero_OK -GOFORIT 99']; % Try the command with and without the GOFORIT option
    system(command)

    system(['mv *.xsave ' glm_dir])
end
