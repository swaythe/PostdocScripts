main_dir = '/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/'; 
gp_dir = [main_dir 'All/'];
mask_file = '/ace/old-ace/8tb/sshankar/Categorization/Templates/MNI-small-mask.nii.gz';


subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

input_prefix = '_ComboCD_MNI+tlrc';
output_file = 'AnovaNoLowCD.nii.gz';
amax = 4; % Coherence
bmax = 5; % Distance from boundary
cmax = length(subs); % Subjects
% ctr = 1;

command = ['3dANOVA3 -DAFNI_FLOATIZE=YES -type 4 -alevels ' int2str(amax-1) ' -blevels ' int2str(bmax-1) ' -clevels ' int2str(cmax) ' '];
for ai = 2:amax
    for bi = 2:bmax
        ctr = (ai-1)*5 + bi;
        for ci = 1:cmax
            sub_dir = [main_dir subs{ci} '/Session_' int2str(baseSess(ci)) '/MNI/'];
            command = [command '-dset ' int2str(ai-1) ' ' int2str(bi-1) ' ' int2str(ci) ' ''' sub_dir subs{ci} input_prefix '[' int2str(ctr-1) ']'' '];
        end
%         ctr = ctr + 1;
    end
end
command = [command '-mask ' mask_file ' '];
command = [command '-fa Coh -fb Dist -fab CohDir '];
% command = [command '-aBcontr -0.4537 -0.2593 -0.1296 0.8427 : 5 CvsHD ']; % Make these weights total 0
% command = [command '-Abcontr 4 : -0.5883 -0.3922 0 0.3922 0.5883 HCvsD ']; % Make these weights total 0
command = [command '-bucket ' gp_dir output_file];
cd(gp_dir);
system(command)
