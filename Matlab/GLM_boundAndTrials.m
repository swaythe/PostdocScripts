format compact;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 2 1 1 1 1 1];
% subs = {'Sub01'};
% baseSess = 1;
sessId = 1:4;

main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
stimFile_prefix = 'STSingleTrial';
boundFile1_prefix = 'BoundPres_45';
boundFile2_prefix = 'BoundPres_135';
glm_prefix = '_BoundContrast';
nStim = 9;

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
    nuis_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/Nuisance_params/'];
    PathOut = [glm_dir sub glm_prefix '.nii.gz'];
    PathOutCR = [glm_dir sub glm_prefix '_RegCoeff.nii.gz'];
    PathOut1D = [glm_dir sub glm_prefix '_x1D.txt'];
    DesMat = [glm_dir sub '_design_matrix' glm_prefix '.jpg'];

    cd(glm_dir);
        
    stims = ['-stim_times 1 ' stimTime_dir boundFile1_prefix '.1D GAM -stim_label 1 ' boundFile1_prefix ' '];
    stims = [stims '-stim_times 2 ' stimTime_dir boundFile2_prefix '.1D GAM -stim_label 2 ' boundFile2_prefix ' '];
    stims = [stims '-stim_times 3 ' stimTime_dir stimFile_prefix '.1D GAM -stim_label 3 ' stimFile_prefix];
    
    command = ['3dDeconvolve -input ' runList ' -num_stimts ' num2str(nStim) ...
        ' -local_times ' stims ' '];
    
    % Specify the nuisance files (motions parameters)
    count = 3;
    nuis_files = dir([nuis_dir 'nuisance*.1D']);
    for l1 = 1:length(nuis_files)
        count = count + 1;
        command = [command '-stim_file ' int2str(count) ' ' nuis_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
    end

    % And now for the contrasts
    num_contrasts = 1;
    ccount = 1;
    % Contrast parametric distance at coherences of 0 and 100%
    command = [command '-num_glt ' int2str(num_contrasts) ' '];
    command = [command '-gltsym ''SYM: ' boundFile1_prefix ' -' boundFile2_prefix ''' '];
    command = [command '-glt_label ' int2str(ccount) ' Bound45vs135 '];
    
    command = [command '-polort A -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; 

    system(command)
end
