sub = 'Sub11';

% cd(['/home/sshankar/Categorization/Data/Behavior/Training/' sub])
cd(['/home/sshankar/Categorization/Data/Behavior/Scanner/' sub])

sess = dir('Session_*');
nIncButton = zeros(length(sess),6);
for si = 1:length(sess)
    cd(sess(si).name)
    runs = dir('run*');
    
    for ri = 1:length(runs)
        cd(runs(ri).name)
        load(sub)
        ids = find(trialTab(:,9)~=49 & trialTab(:,9)~=50);
        nIncButton(si,ri) = length(ids);
        cd ..
    end
    cd ..
end
