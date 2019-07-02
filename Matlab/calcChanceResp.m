% This script calculates the number of left and right button presses made
% by subjects on trials where either perceptual or categorical information
% was absent

subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
nSub = length(subs);
nSess = 4;

main_dir = '/mnt/8tb/sshankar/Categorization/Data/Behavior/';

nd = 9; % number of unique distances; subsequently pool together 15 and 75 etc.
nc = 4; 

resp_0c = zeros(nd,2,nSub);
resp_0d = zeros(nc,2,nSub);

for si = 1:nSub
    cd(main_dir)
    load(['DirCoh' subs{si}])
    dirs = unique(abs(DirCoh(:,1)));
    cohs = unique(DirCoh(:,2)) .* 100;
    for sessi = 1:nSess
        % This hack is needed for Sub05 because they have 2 values of 90-ID
        % by mistake
        if si==4 && sessi>2
            dirs(4) = 78;
        end
        cd(fullfile(main_dir, 'Scanner', subs{si}, ['Session_', num2str(sessi)]))
        runs = dir('run*');
        for ri = 1:length(runs)
            cd(runs(ri).name)
            load([subs{si} '.mat'])
            % Find button press statistics for all distances when coherence
            % = 0
            for di = 1:nd
                % Left button presses
                ids = sum(abs(trialTab(:,6))==dirs(di) & trialTab(:,8)==0 & trialTab(:,9)==49);
                resp_0c(di,1,si) = resp_0c(di,1,si) + ids;
                % Right button presses
                ids = sum(abs(trialTab(:,6))==dirs(di) & trialTab(:,8)==0 & trialTab(:,9)==50);
                resp_0c(di,2,si) = resp_0c(di,2,si) + ids;
            end
            % Find button press statistics for all coherences when distance
            % = 0. This requires a few special conditions
            for ci = 1:nc
                % Left button presses when distance = 0
                ids = sum(trialTab(:,6)==0 & trialTab(:,8)==cohs(ci) & trialTab(:,9)==49);
                resp_0d(ci,1,si) = resp_0d(ci,1,si) + ids;
                % Left button presses when distance = 180
                ids = sum(trialTab(:,6)==180 & trialTab(:,8)==cohs(ci) & trialTab(:,9)==49);
                resp_0d(ci,1,si) = resp_0d(ci,1,si) + ids;
                % Right button presses when distance = 0
                ids = sum(trialTab(:,6)==0 & trialTab(:,8)==cohs(ci) & trialTab(:,9)==50);
                resp_0d(ci,2,si) = resp_0d(ci,2,si) + ids;
                % Right button presses when distance = 180
                ids = sum(trialTab(:,6)==180 & trialTab(:,8)==cohs(ci) & trialTab(:,9)==50);
                resp_0d(ci,2,si) = resp_0d(ci,2,si) + ids;
            end
            cd ..
        end
    end
    % Combine angles that are the same distance from 0 and 180
    resp_0c(1,:,si) = resp_0c(1,:,si) + resp_0c(9,:,si);
    resp_0c(2,:,si) = resp_0c(2,:,si) + resp_0c(8,:,si);
    resp_0c(3,:,si) = resp_0c(3,:,si) + resp_0c(7,:,si);
    resp_0c(4,:,si) = resp_0c(4,:,si) + resp_0c(6,:,si);
end

% Trim the resp_0c matrix by removing the last 4 distances (because they
% have been pooled with the first 4 distances)
resp_0c = resp_0c(1:5,:,:);

% Calculate the fraction of left responses per condition, per subject
f_resp_0d = resp_0d(:,1,:) ./ sum(resp_0d,2);
f_resp_0c = resp_0c(:,1,:) ./ sum(resp_0c,2);

% Calculate the fraction of left responses per subject
fsub_resp_0d = sum(squeeze(resp_0d(:,1,:)),1) ./ squeeze(sum(sum(resp_0d,2),1))';
fsub_resp_0c = sum(squeeze(resp_0c(:,1,:)),1) ./ squeeze(sum(sum(resp_0c,2),1))';

save(fullfile('/mnt/8tb/sshankar/Categorization/Data/Behavior/Scanner','lowCD_resp'), 'resp_0d', 'resp_0c', 'f_resp_0d', 'f_resp_0c', 'fsub_resp_0d', 'fsub_resp_0c');

