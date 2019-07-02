format compact;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
subs = {'Sub02'};
baseSess = 1;
sessId = 1:4;
nStim = 14; % 26 when all coh-dir combos go into one GLM file

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
glm_prefix = '_GLM_B2vs1';

for si = 1:length(subs)
    sub = subs{si};
    subj_dir = [data_dir sub '/']; 

    stimFiles = cell(nStim-6,1);
    stimFiles{1} = ['STB1vertc1.1D'];
    stimFiles{2} = ['STB1vertc2.1D'];
    stimFiles{3} = ['STB1vertc3.1D'];
    stimFiles{4} = ['STB1vertc4.1D'];
    stimFiles{5} = ['STB2vertc1.1D'];
    stimFiles{6} = ['STB2vertc2.1D'];
    stimFiles{7} = ['STB2vertc3.1D'];
    stimFiles{8} = ['STB2vertc4.1D'];
    
    stimLabels = cell(nStim-6,1);
    stimLabels{1} = 'B1c1';
    stimLabels{2} = 'B1c2';
    stimLabels{3} = 'B1c3';
    stimLabels{4} = 'B1c4';
    stimLabels{5} = 'B2c1';
    stimLabels{6} = 'B2c2';
    stimLabels{7} = 'B2c3';
    stimLabels{8} = 'B2c4';

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

    cd(nifti_dir);

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
    nuis_files = dir([glm_dir 'nuis*.1D']);
    for l1 = 1:length(nuis_files)
        count = count+1;
        command = [command '-stim_file ' int2str(count) ' ' glm_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
    end

    % And now for the contrasts
    num_contrasts = 6;
    ccount = 1;
    % Contrast bound 1 and 2, coherence 0%
    command = [command '-num_glt ' int2str(num_contrasts) ' '];
    command = [command '-gltsym ''SYM: ' stimLabels{5} ' -' stimLabels{1} ''' '];
    command = [command '-glt_label ' int2str(ccount) ' B1v2c1 '];
    ccount = ccount + 1;
    
    % Contrast bound 1 and 2, coherence ~12%
    command = [command '-gltsym ''SYM: ' stimLabels{6} ' -' stimLabels{2} ''' '];
    command = [command '-glt_label ' int2str(ccount) ' B1v2c2 '];
    ccount = ccount + 1;
    
    % Contrast bound 1 and 2, coherence ~25%
    command = [command '-gltsym ''SYM: ' stimLabels{7} ' -' stimLabels{3} ''' '];
    command = [command '-glt_label ' int2str(ccount) ' B1v2c3 '];
    ccount = ccount + 1;
    
    % Contrast bound 1 and 2, coherence 100%
    command = [command '-gltsym ''SYM: ' stimLabels{8} ' -' stimLabels{4} ''' '];
    command = [command '-glt_label ' int2str(ccount) ' B1v2c4 '];
    ccount = ccount + 1;
    
    % Contrast bound 1, coherence 12% and 25%
    command = [command '-gltsym ''SYM: ' stimLabels{3} ' -' stimLabels{2} ''' '];
    command = [command '-glt_label ' int2str(ccount) ' B1c2v3 '];
    ccount = ccount + 1;
    
    % Contrast bound 2, coherence 12% and 25%
    command = [command '-gltsym ''SYM: ' stimLabels{7} ' -' stimLabels{6} ''' '];
    command = [command '-glt_label ' int2str(ccount) ' B2c2v3 '];
    ccount = ccount + 1;

    % Finish up the command
    command = [command '-polort A -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; 

    system(command)
end