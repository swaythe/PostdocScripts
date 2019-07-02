format compact;
subs = 'Sub05';
sessId = 1:4;
baseSess = 2;
nStim = 7;
tr = 1800;

main_dir = '/home/sshankar/Categorization/';
script_dir = [main_dir, 'Scripts/'];
data_dir = [main_dir 'Data/Imaging/'];
template_dir = [main_dir, 'Templates/'];
subj_dir = [data_dir subs '/']; 
epi_dir = 'NIFTIS/';
nifti_dir = [subj_dir 'Session_' int2str(baseSess) '/' epi_dir];
glm_dir = [subj_dir 'Session_' int2str(baseSess) '/GLM/'];
stimTime_dir = [subj_dir 'Session_' int2str(baseSess) '/StimTimes/'];

mask_suffix = '_Mask.nii.gz';
commonMid = 'ParamCohDir';
commonSuffix = 'Correct';
stimFile = ['StimTimes' commonMid commonSuffix '.1D'];
stimLabel = [commonMid commonSuffix];
glm_prefix = ['_GLM_' commonMid commonSuffix];
errts_prefix = ['_errts_' commonMid];
mask_prefix = [subj_dir 'Session_' int2str(baseSess) '/' epi_dir subs mask_suffix];
% mask_prefix = [subj_dir 'Session_' int2str(1) '/' epi_dir subs mask_suffix];

runList = [];
for sessi = 1:length(sessId)
    sess_dir = [subj_dir 'Session_' num2str(sessId(sessi)) '/'];
    cd([sess_dir epi_dir]);
    gFiles = dir('EPI*Smooth*');
    for gi = 1:length(gFiles)
        runList = [runList sess_dir epi_dir gFiles(gi).name ' '];
    end
end

PathOut = [glm_dir subs glm_prefix '.nii.gz'];
PathOutCR = [glm_dir subs glm_prefix '_RegCoeff.nii.gz'];
PathOut1D = [glm_dir subs glm_prefix '_x1D.txt'];
DesMat = [glm_dir subs '_design_matrix' glm_prefix '.jpg'];
errOut = [glm_dir subs errts_prefix '.nii.gz'];

% cd(nifti_dir);

% diary([subj_dir subs '_diary_GLM1_' date]);

count = 1;
stims = [' -stim_times_AM2 ' int2str(count) ' ' stimTime_dir stimFile ' GAM -stim_label 1 ' stimLabel];

command = ['3dDeconvolve -input ' runList ' ' ... 
    '-mask ' mask_prefix ' -num_stimts ' num2str(nStim) ' -local_times' ...
    stims ' '];

% Remove these TRs from the analysis - excessive motion was observed in
% them
% command = [command '-CENSORTR 5:294..295,8:213..299,11:268..269,17:297,23:246 '];

nuis_files = dir([glm_dir 'nuis*.1D']);
for l1 = 1:length(nuis_files)
    count = count+1;
    command = [command '-stim_file ' int2str(count) ' ' glm_dir nuis_files(l1).name ' '];
    command = [command '-stim_label ' int2str(count) ' mvmt_' int2str(l1) ' '];

    % The next line ensures that nuisance variables don't get included
    % in the baseline / as an effect of interest.
    command = [command '-stim_base ' int2str(count) ' '];
end
    
% command = [command '-errts ' errOut ' '];
command = [command '-polort A -fout -tout -nobout -jobs 15 ' ...
    '-bucket ' PathOut ' -xsave -cbucket ' PathOutCR ' -xjpeg ' DesMat ' ' ...
    '-x1D ' PathOut1D]; % ' -allzero_OK -GOFORIT 99']; % Try the command with and without the GOFORIT option
system(command)

system(['mv *.xsave ' glm_dir])
