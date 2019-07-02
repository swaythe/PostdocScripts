format compact;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub05'};
% baseSess = 2;
sessId = 1:4;
nStim = 47; 

main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
stimFile_prefix = 'STNonRoi';

% Stimulus file names
stimFiles = cell(nStim-6,1);
% For correct trial stim times
for sti = 1:20
    stimFiles{sti} = [stimFile_prefix 'Corr' int2str(sti) '.1D'];
end
% For incorrect trial stim times
for sti = 21:40
    stimFiles{sti} = [stimFile_prefix 'Inc' int2str(sti-20) '.1D'];
end
stimFiles{41} = 'STAbortedNonRoi.1D';

% Stimulus set labels
stimLabels = cell(nStim-6,1);
% For correct trials
for sti = 1:20
    stimLabels{sti} = ['TCCorr' int2str(sti)];
end
% For incorrect trials
for sti = 21:40
    stimLabels{sti} = ['TCInc' int2str(sti-20)];
end
stimLabels{41} = 'STAborted';

% Impulse response file names
irespFiles = cell(nStim-7,1);
% For correct trial CD combos
for sti = 1:20
    irespFiles{sti} = ['TCNonRoiCorr' int2str(sti) '.nii.gz'];
end
% For incorrect trial CD combos
for sti = 21:40
    irespFiles{sti} = ['TCNonRoiInc' int2str(sti-20) '.nii.gz'];
end

% SD of impulse response files
srespFiles = cell(nStim-7,1);
% For correct trial CD combos
for sti = 1:20
    srespFiles{sti} = ['TCsdNonRoiCorr' int2str(sti) '.nii.gz'];
end
% For incorrect trial CD combos
for sti = 21:40
    srespFiles{sti} = ['TCsdNonRoiInc' int2str(sti-20) '.nii.gz'];
end

for si = 1:length(subs)
    sub = subs{si};
    subj_dir = [data_dir sub '/']; 
    
    runList = [];
    for sessi = 1:length(sessId)
        sess_dir = [subj_dir 'Session_' num2str(sessId(sessi)) '/'];
        cd([sess_dir 'NIFTIS/']);
        gFiles = dir('EPI*Smooth*');
        gFiles = gFiles(3:end);
        for gi = 1:length(gFiles)
            runList = [runList sess_dir 'NIFTIS/' gFiles(gi).name ' '];
        end
    end

    nifti_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/NIFTIS/'];
    glm_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/GLM_TC/'];
    nuis_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/Nuisance_params/'];
    stimTime_dir = [subj_dir 'Session_' int2str(baseSess(si)) '/StimTimes/'];
    
    cd(nifti_dir);

    stims = [];
    for count = 1:nStim-7
        stims = [stims '-stim_times ' int2str(count) ' ' stimTime_dir stimFiles{count} ' ''CSPLIN(0,20,10)'' -stim_label ' int2str(count) ' ' stimLabels{count} ' '];
    end
    count = count + 1;
    stims = [stims '-stim_times ' int2str(count) ' ' stimTime_dir stimFiles{count} ' GAM -stim_label ' int2str(count) ' ' stimLabels{count} ' '];

    irsp = [];
    for count = 1:nStim-7
        irsp = [irsp '-iresp ' int2str(count) ' ' glm_dir irespFiles{count} ' '];
    end
    
    srsp = [];
    for count = 1:nStim-7
        srsp = [srsp '-sresp ' int2str(count) ' ' glm_dir srespFiles{count} ' '];
    end

    command = ['3dDeconvolve -input ' runList ' '...
        ' -num_stimts ' num2str(nStim) ' -local_times ' stims ...
        '-TR_times 0.1 -float ' irsp ' ' srsp];

    % Specify the nuisance files (motions parameters)
    count = count + 1;
    nuis_files = dir([nuis_dir 'NuisanceNonROI*.1D']);
    for l1 = 1:length(nuis_files)
        count = count + 1;
        command = [command '-stim_file ' int2str(count) ' ' nuis_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
    end

    command = [command '-allzero_OK -GOFORIT 99 -polort A -fout -tout -nobout -jobs 15 ' ...
        '-nobucket'];

    system(command)
end