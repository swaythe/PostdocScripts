subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 2 1 1 1 1 1];
% subs = {'Sub01'};
% baseSess = 1;

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
glm1 = '_C0ParamDirCorrect.nii.gz[3]';
glm2 = '_D0ParamCohCorrect.nii.gz[3]';
output_file = 'LowDistMinusLowCoh.nii.gz';

for si = 1:length(subs)
    sub = subs{si};
    glm_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/GLM']; 
    cd(glm_dir)
    command = ['3dcalc -a ''' sub glm1 ''' -b ''' sub glm2 ''' -expr b-a -prefix ' sub '_' output_file];
    system(command);
end