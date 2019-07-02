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
glm_prefix = '_75Dist100CohContrast';

nStim = 10; % 26 when all coh-dir combos go into one GLM file
stimFiles = cell(nStim-6,1);
stimFiles{1} = 'STCohAllDir75_Corr.1D';
stimFiles{2} = 'STDirAllCoh100_Corr.1D';
stimFiles{3} = 'STNonC100D75Corr.1D';
stimFiles{4} = 'STIncAbort.1D';

stimLabels = cell(nStim-6,1);
stimLabels{1} = 'Dir75ParamCoh';
stimLabels{2} = 'Coh100ParamDir';
stimLabels{3} = 'NonCoh100Dist75Correct';
stimLabels{4} = 'IncAbort';

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
    nuis_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/Nuisance_params/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];
    PathOut = [glm_dir sub glm_prefix '.nii.gz'];
    PathOutCR = [glm_dir sub glm_prefix '_RegCoeff.nii.gz'];
    PathOut1D = [glm_dir sub glm_prefix '_x1D.txt'];
    DesMat = [glm_dir sub '_design_matrix' glm_prefix '.jpg'];

    cd(nifti_dir);

%     diary([subj_dir sub '_diary_GLM1_' date]);
    mask_prefix = [subj_dir 'Session_' int2str(baseSess(si)) '/NIFTIS/' sub '_Mask.nii.gz'];

    stims = [];
    for count = 1:2
        stims = [stims '-stim_times_AM2 ' int2str(count) ' ' stimTime_dir stimFiles{count} ' GAM -stim_label ' int2str(count) ' ' stimLabels{count} ' '];
    end
    for count = 3:nStim-6
        stims = [stims '-stim_times ' int2str(count) ' ' stimTime_dir stimFiles{count} ' GAM -stim_label ' int2str(count) ' ' stimLabels{count} ' '];
    end

    command = ['3dDeconvolve -input ' runList ' '...
        '-mask ' mask_prefix ' -num_stimts ' num2str(nStim) ' -local_times ' ...
        stims ' '];

    % Specify the nuisance files (motions parameters)
    nuis_files = dir([nuis_dir 'nuis*.1D']);
    for l1 = 1:length(nuis_files)
        count = count+1;
        command = [command '-stim_file ' int2str(count) ' ' nuis_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
    end

    % And now for the contrasts
    num_contrasts = 1;
    ccount = 1;
    % Contrast parametric distance at coherences of 0 and 100%
    command = [command '-num_glt ' int2str(num_contrasts) ' '];
    command = [command '-gltsym ''SYM: ' stimLabels{2} ' -' stimLabels{1} ''' '];
    command = [command '-glt_label ' int2str(ccount) ' 100Coh75Dist '];
    ccount = ccount + 1;
    
%     % Contrast parametric coherence at distances of 0 and 90 deg
%     command = [command '-gltsym ''SYM: ' stimLabels{3} ' -' stimLabels{4} ''' '];
%     command = [command '-glt_label ' int2str(ccount) ' ParamCohExtremeDist '];
%     ccount = ccount + 1;
%     
%     % Contrast parametric distance at coherence of 0% and parametric coherence at distance of 0 deg
%     command = [command '-gltsym ''SYM: ' stimLabels{1} ' -' stimLabels{3} ''' '];
%     command = [command '-glt_label ' int2str(ccount) ' ParamDistC0ParamCohD0 '];
%     ccount = ccount + 1;
%     
%     % Contrast parametric distance at coherence of 100% and parametric coherence at distance of 90 deg
%     command = [command '-gltsym ''SYM: ' stimLabels{2} ' -' stimLabels{4} ''' '];
%     command = [command '-glt_label ' int2str(ccount) ' ParamDistC100ParamCohD90 '];
%     ccount = ccount + 1;
    
    % Finish up the command
    command = [command '-polort A -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; 

    system(command)
end