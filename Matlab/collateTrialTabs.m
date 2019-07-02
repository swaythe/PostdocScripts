cd('/home/sshankar/Categorization/Data/Behavior/Scanner'); 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% subs = {'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% subs = {'Sub01'};

% Output file name: 
% _collatedTT contains all valid trials (i.e., trials that have
% a response and that have an RT > 0
% _allTT contains all trials (valid and invalid)

collFile = '_allTT';
sessions = 1:4;

% Collated file contains the following columns: TT columns in parentheses
% 1: Boundary (5)
% 2: Distance from boundary (6)
% 3: Coherence (8)
% 4: Accuracy (11) - -1 if aborted trial
% 5: RT (10-3)
% 6: Stimulus start (3 - Run start) # Since we need local times from run start
% 7: ITI start (12- Run start) # Since we need local times from run start
% 8: Run number

for si = 1:length(subs)
    sub = subs{si};
    cd(sub)
    nRuns = 0;
    collData = [];
    for sessi = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessi)) '/']);
        runs = dir('run*');
        for rdi = 1:length(runs)
            cd(runs(rdi).name);
            load(sub)
            % Use the following line for _collatedTT
%             vIds = trialTab(:,9)~=48 & (trialTab(:,10)-trialTab(:,3))>0;
            % Use the following line for _allTT
            vIds = ones(64,1)==1;
            collData = [collData; trialTab(vIds,[5 6 8 11]) (trialTab(vIds,10)-trialTab(vIds,3)) (trialTab(vIds,3)-scanTTLtimes1(1)) (trialTab(vIds,12)-scanTTLtimes1(1)) repmat(nRuns+rdi,sum(vIds),1)];
            cd ..
        end
        nRuns = nRuns + length(runs);
        cd ..
    end
    save([sub collFile], 'collData', 'nRuns')
    cd ..
end

