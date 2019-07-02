cd('/home/sshankar/Categorization/Data/Imaging/All/');

% To create composite maps of Coherence and Distance
% In the positive parametric maps of both coh and dir, find the threshold
% at which you want to look at the maps (p = 0.05, t = 2.13 in this
% example) and find voxels that show non-zero parametric effect.
% 1 = parametric effect of coherence alone
% 2 = parametric effect of distance from boundary alone
% 3 = both coherence and distance effects

% Uncorrected p = 0.05, t = 2.13
% Uncorrected p = 0.005, t = 3.29, and then apply a cluster size of ~42 with NN = 3
% Uncorrected p = 0.005, t = 4.033 for individual CD combination
th = 4.033;

% system(['3dcalc -a CohCorrectAllPositive_Group.nii.gz[0] -b CohCorrectAllPositive_Group.nii.gz[1] -c DirCorrectAllPositive_Group.nii.gz[0] -d DirCorrectAllPositive_Group.nii.gz[1] -expr ' '''and(notzero(a),ispositive(abs(b)-' num2str(th) '))+2*and(notzero(c),ispositive(abs(d)-' num2str(th) '))''' ' -prefix CDAll.nii.gz'])
% system(['3dcalc -a CohHighCorrectPositive_Group.nii.gz[0] -b CohHighCorrectPositive_Group.nii.gz[1] -c DirHighCorrectPositive_Group.nii.gz[0] -d DirHighCorrectPositive_Group.nii.gz[1] -expr ' '''and(notzero(a),ispositive(abs(b)-' num2str(th) '))+2*and(notzero(c),ispositive(abs(d)-' num2str(th) '))''' ' -prefix CDHigh005_3.nii.gz'])
% system(['3dcalc -a CohHighCorrectPositive_Group.nii.gz[0] -b CohHighCorrectPositive_Group.nii.gz[1] -c DirHighCorrectPositive_Group.nii.gz[0] -d DirHighCorrectPositive_Group.nii.gz[1] -expr ' '''and(ispositive(a),ispositive(abs(b)-' num2str(th) '))+2*and(ispositive(c),ispositive(abs(d)-' num2str(th) '))''' ' -prefix CDPosHigh005.nii.gz'])
% system(['3dcalc -a CohHighCorrectPositive_Group.nii.gz[0] -b CohHighCorrectPositive_Group.nii.gz[1] -c DirHighCorrectPositive_Group.nii.gz[0] -d DirHighCorrectPositive_Group.nii.gz[1] -expr ' '''and(isnegative(a),ispositive(abs(b)-' num2str(th) '))+2*and(isnegative(c),ispositive(abs(d)-' num2str(th) '))''' ' -prefix CDNegHigh005.nii.gz'])
system(['3dcalc -a ComboCD16.nii.gz[0] -b ComboCD16.nii.gz[1] -c ComboCD20.nii.gz[0] -d ComboCD20.nii.gz[1] -expr ' '''and(notzero(a),ispositive(abs(b)-' num2str(th) '))+2*and(notzero(c),ispositive(abs(d)-' num2str(th) '))''' ' -prefix BoundaryNearFar.nii.gz'])
