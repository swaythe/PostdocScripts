format compact;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
subs = {'Sub05','Sub10','Sub11'};
baseSess = [2 1 1];
sessId = 1:4;
nStim = 47;

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
glm_prefix = '_ComboCDRoi';
stimFile_prefix = 'STRoi';

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
stimFiles{sti+1} = 'STAbortedRoi.1D';

% Stimulus labels
stimLabels = cell(nStim-6,1);
% Correct labels
for sti = 1:20
    stimLabels{sti} = ['CDRoi',int2str(sti)];
end
% Incorrect labels
for sti = 21:40
    stimLabels{sti} = ['CDRoi',int2str(sti)];
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
    nuis_files = dir([nuis_dir 'NuisanceROI*.1D']);
    for l1 = 1:length(nuis_files)
        count = count+1;
        command = [command '-stim_file ' int2str(count) ' ' nuis_dir nuis_files(l1).name ' '];
        command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];
        command = [command '-stim_base ' int2str(count) ' '];
    end

    % And now for the contrasts
    % num_contrasts = 7;
    % ccount = 1;
    % command = [command '-num_glt ' int2str(num_contrasts) ' '];
    % command = [command '-gltsym ''SYM: ' stimLabels{19} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' EasyCat '];
    % ccount = ccount + 1;
    % 
    % command = [command '-gltsym ''SYM: ' stimLabels{17} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' DiffCat '];
    % ccount = ccount + 1;
    % 
    % command = [command '-gltsym ''SYM: ' stimLabels{18} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' EasyCoh '];
    % ccount = ccount + 1;
    % 
    % command = [command '-gltsym ''SYM: ' stimLabels{3} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' DiffCoh '];
    % ccount = ccount + 1;
    % 
    % command = [command '-gltsym ''SYM: ' stimLabels{19} ' -' stimLabels{17} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' EasyMinusDiffCat '];
    % ccount = ccount + 1;
    % 
    % command = [command '-gltsym ''SYM: ' stimLabels{18} ' -' stimLabels{3} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' EasyMinusDiffCoh '];
    % ccount = ccount + 1;

    % (Cat 90 - Cat 0) - (Cohh 100 - Coh 0)
    % command = [command '-gltsym ''SYM: ' stimLabels{5} ' +' stimLabels{10} ' +' stimLabels{15} ' +' stimLabels{20} ' -'];
    % command = [command stimLabels{1} ' -' stimLabels{6} ' -' stimLabels{11} ' -' stimLabels{16} ' -'];
    % command = [command stimLabels{16} ' -' stimLabels{17} ' -' stimLabels{18} ' -' stimLabels{19} ' -' stimLabels{20} ' +'];
    % command = [command stimLabels{1} ' +' stimLabels{2} ' +' stimLabels{3} ' +' stimLabels{4} ' +' stimLabels{5} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' CatEffect '];

    % (Cat 75/105:Coh 100 - Cat -15/15:Coh 100) - (Coh 100:Cat 45 - Coh 0:Cat 45)
    % command = [command '-gltsym ''SYM: ' stimLabels{19} ' -' stimLabels{17} ' -' stimLabels{18} ' +' stimLabels{3} ''' '];
    % command = [command '-glt_label ' int2str(ccount) ' CatEffect '];

    % Finish up the command
    command = [command '-polort A -allzero_OK -GOFORIT 99 -fout -tout -nobout -jobs 15 ' ...
        '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
        '-x1D ' PathOut1D]; 

    system(command)
    system(['mv *.xsave ' glm_dir])
end