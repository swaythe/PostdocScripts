% Find the direction and coherence values of missed trials and save this
% information sorted by coherence and direction
sub = 'Sub04';
save_file = ['DirCohMiss_' sub '_Scan'];

% cd(['/home/sshankar/Categorization/Data/Behavior/Training/' sub '/'])
cd(['/home/sshankar/Categorization/Data/Behavior/Scanner/' sub '/'])
dirCohMiss = [];

sess = dir('Session*');
for sid = 1:length(sess)
    cd(sess(sid).name)
    runs = dir('run*');
    for rid = 1:length(runs)
        load([runs(rid).name '/' sub])
        mid = find(trialTab(:,9) == 48);
        dirCohMiss = [dirCohMiss; repmat(sid,length(mid),1) repmat(rid,length(mid),1) mid trialTab(mid,6) trialTab(mid,8)];
    end
    cd ..
end

sr = sortrows(dirCohMiss, [5 4 1 2 3]);
save(save_file, 'sr')