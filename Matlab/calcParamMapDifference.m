% This script calculates the difference maps of 
% 1. parametric coherence - parametric distance
% 2. parametric distance - parametric coherence

subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
nSub = length(subs);

main_dir = '/ace/old-ace/8tb/sshankar/Categorization/Data/Imaging/';

for si = 1:nSub
    sub = subs{si};
    cd(fullfile(main_dir,sub,['Session_' num2str(baseSess(si))],'GLM'))
%     command = ['3dcalc -a ''' sub '_CD.nii.gz[3]'' -b ''' sub '_CD.nii.gz[5]'' -expr ''a-b'' -prefix ' sub '_PECohMinusDist.nii.gz'];
%     system(command)
%     command = ['3dcalc -a ''' sub '_CD.nii.gz[3]'' -b ''' sub '_CD.nii.gz[5]'' -expr ''b-a'' -prefix ' sub '_PEDistMinusCoh.nii.gz'];
%     system(command)
%     command = ['3dcalc -a ''' sub '_CD.nii.gz[3]'' -b ''' sub '_CD.nii.gz[5]'' -expr ''b+a'' -prefix ' sub '_PEDistPlusCoh.nii.gz'];
%     system(command)
    command = ['3dcalc -a ''' sub '_CD.nii.gz[3]'' -b ''' sub '_CD.nii.gz[5]'' -expr ''abs(b)-abs(a)'' -prefix ' sub '_PEAbsDistMinusAbsCoh.nii.gz'];
    system(command)
end
