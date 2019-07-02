subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub01','Sub02','Sub05','Sub06','Sub08','Sub10','Sub13'};
% baseSess = [1 1 2 1 1 1 1];
% subs = {'Sub04'};
% baseSess = 1;

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
roi_common = 'MECorr';
tc_file = ['_' roi_common 'TC_CoReg'];
avg_file = ['_' roi_common 'AvgTC_CoReg.mat'];

for si = 1:length(subs)
    sub = subs{si};
    tc_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/GLM_TC/'];
    cd(tc_dir);
    load([sub tc_file]);

    % Do the following to the raw timecourses
    
    % Change all zeros to NaNs to use nanmean
    timecourse(find(~timecourse)) = NaN;
    % Take the mean across all runs
    tc = squeeze(nanmean(timecourse,3));
    % Take the mean across all voxels within an ROI
    tc = squeeze(nanmean(tc,3));
    timecourse = tc;
    tc = zeros(20,size(timecourse,2),size(timecourse,3));
    
    % Now fold some rows into each other so we have 20 unique Coh-Dir pairs
    % rather than 64
    % Dir = 0, Coh = All
    tc(1,:,:) = nanmean(timecourse([29 61],:,:));
    tc(2,:,:) = nanmean(timecourse([30 62],:,:));
    tc(3,:,:) = nanmean(timecourse([31 63],:,:));
    tc(4,:,:) = nanmean(timecourse([32 64],:,:));
    
    % Dir = 15 (e.g.), Coh = All
    tc(5,:,:) = nanmean(timecourse([1 25 33 57],:,:));
    tc(6,:,:) = nanmean(timecourse([2 26 34 58],:,:));
    tc(7,:,:) = nanmean(timecourse([3 27 35 59],:,:));
    tc(8,:,:) = nanmean(timecourse([4 28 36 60],:,:));
    
    % Dir = 45, Coh = All
    tc(9,:,:) = nanmean(timecourse([5 21 37 53],:,:));
    tc(10,:,:) = nanmean(timecourse([6 22 38 54],:,:));
    tc(11,:,:) = nanmean(timecourse([7 23 39 55],:,:));
    tc(12,:,:) = nanmean(timecourse([8 24 40 56],:,:));
    
    % Dir = 75 (e.g.), Coh = All
    tc(13,:,:) = nanmean(timecourse([9 17 41 49],:,:));
    tc(14,:,:) = nanmean(timecourse([10 18 42 50],:,:));
    tc(15,:,:) = nanmean(timecourse([11 19 43 51],:,:));
    tc(16,:,:) = nanmean(timecourse([12 20 44 52],:,:));
    
    % Dir = 90, Coh = All
    tc(17,:,:) = nanmean(timecourse([13 45],:,:));
    tc(18,:,:) = nanmean(timecourse([14 46],:,:));
    tc(19,:,:) = nanmean(timecourse([15 47],:,:));
    tc(20,:,:) = nanmean(timecourse([16 48],:,:));
    
    timecourse = tc;
    
    % Now do the same for the normalized timecourses
    % Change all zeros to NaNs to use nanmean
    timecourse_norm(find(~timecourse_norm)) = NaN;
    % Take the mean across all runs
    tc = squeeze(nanmean(timecourse_norm,3));    
    % Take the mean across all voxels within an ROI
    tc = squeeze(nanmean(tc,3));
    timecourse_norm = tc;
    tc = zeros(20,size(timecourse_norm,2),size(timecourse_norm,3));
    
    % Now fold some rows into each other so we have 20 unique Coh-Dir pairs
    % rather than 64
    % Dir = 0, Coh = All
    tc(1,:,:) = nanmean(timecourse_norm([29 61],:,:));
    tc(2,:,:) = nanmean(timecourse_norm([30 62],:,:));
    tc(3,:,:) = nanmean(timecourse_norm([31 63],:,:));
    tc(4,:,:) = nanmean(timecourse_norm([32 64],:,:));
    
    % Dir = 15 (e.g.), Coh = All
    tc(5,:,:) = nanmean(timecourse_norm([1 25 33 57],:,:));
    tc(6,:,:) = nanmean(timecourse_norm([2 26 34 58],:,:));
    tc(7,:,:) = nanmean(timecourse_norm([3 27 35 59],:,:));
    tc(8,:,:) = nanmean(timecourse_norm([4 28 36 60],:,:));
    
    % Dir = 45, Coh = All
    tc(9,:,:) = nanmean(timecourse_norm([5 21 37 53],:,:));
    tc(10,:,:) = nanmean(timecourse_norm([6 22 38 54],:,:));
    tc(11,:,:) = nanmean(timecourse_norm([7 23 39 55],:,:));
    tc(12,:,:) = nanmean(timecourse_norm([8 24 40 56],:,:));
    
    % Dir = 75 (e.g.), Coh = All
    tc(13,:,:) = nanmean(timecourse_norm([9 17 41 49],:,:));
    tc(14,:,:) = nanmean(timecourse_norm([10 18 42 50],:,:));
    tc(15,:,:) = nanmean(timecourse_norm([11 19 43 51],:,:));
    tc(16,:,:) = nanmean(timecourse_norm([12 20 44 52],:,:));
    
    % Dir = 90, Coh = All
    tc(17,:,:) = nanmean(timecourse_norm([13 45],:,:));
    tc(18,:,:) = nanmean(timecourse_norm([14 46],:,:));
    tc(19,:,:) = nanmean(timecourse_norm([15 47],:,:));
    tc(20,:,:) = nanmean(timecourse_norm([16 48],:,:));
    
    timecourse_norm = tc;
    save([sub avg_file], 'timecourse','timecourse_norm');
end