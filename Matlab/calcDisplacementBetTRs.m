sub = 'Sub11';

home_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/'];
cd(home_dir)

dispDiff = zeros(24,299);
voxSz = 3; % Voxel size, in mm
sess = dir('Session_*');
ctr = 1;

for si = 1:length(sess)
    cd([home_dir sess(si).name '/NIFTIS/'])
    mdFiles = dir('*MD1D.mat');
    for mi = 1:length(mdFiles)
        load(mdFiles(mi).name);
        dispDiff(ctr,:) = diff(MD1D);
        ctr = ctr + 1;
    end
end

cd(home_dir)

% Find indices (TRs) with displacement greater than 1 voxel (3mm) 
ids = find(abs(dispDiff)>=voxSz);
[maxi maxj] = ind2sub(size(dispDiff),ids);

save('Displacements.mat', 'dispDiff', 'maxi', 'maxj');

