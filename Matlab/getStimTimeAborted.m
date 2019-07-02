subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
sessions = 1:4;
stimFile = 'STAbortedNonRoi.1D';

for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    load(['DirCoh' sub])
    cohs = unique(DirCoh(:,2))*100;
    dirs = unique(abs(DirCoh(:,1)));
    cd(['Scanner/' sub '/']);
    fid = fopen([stimTimes_folder stimFile], 'w');
    
    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');
        % To get stim times for ROI runs
%         rd = rd(1:2);
        % To get stim times for non ROI runs
        rd = rd(3:end);
        if strcmp(sub,'Sub05') && (sessions(sessId)==3 || sessions(sessId)==4)
            dirs(4) = 78;
        end
        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
            end
            % To calculate aborted trials
            ids = find(trialTab(:,9)==48 | (trialTab(:,10)-trialTab(:,3))<=0);

            % To calculate aborted and incorrect trials
%             ids = find(trialTab(:,9)==48 | (trialTab(:,10)-trialTab(:,3))<=0 | trialTab(:,11)==0);

            % To calculate correct trials not of some coh-dist combination
%             ids = find(((abs(trialTab(:,6))~=dirs(1) & abs(trialTab(:,6))~=dirs(9)) & trialTab(:,8)~=cohs(1)) & trialTab(:,9)~=48 & (trialTab(:,10)-trialTab(:,3))>0 & trialTab(:,11)==1);
%             ids = find((abs(trialTab(:,6))~=dirs(5) & trialTab(:,8)~=cohs(4)) & trialTab(:,9)~=48 & (trialTab(:,10)-trialTab(:,3))>0 & trialTab(:,11)==1);

            % To calculate correct trials of some coh-dist combination
%             ids = find(((abs(trialTab(:,6))==dirs(4) | abs(trialTab(:,6))==dirs(6)) & trialTab(:,8)==cohs(4)) & trialTab(:,9)~=48 & (trialTab(:,10)-trialTab(:,3))>0 & trialTab(:,11)==1);
%             ids = find((abs(trialTab(:,6))==dirs(5) & trialTab(:,8)==cohs(4)) & trialTab(:,9)~=48 & (trialTab(:,10)-trialTab(:,3))>0 & trialTab(:,11)==1);

            stimTimes = trialTab(ids,3)-scanTTLtimes1(1);
            stimTimes = sort(stimTimes);
            if isempty(stimTimes)
                fprintf(fid, '*');
            else
                for sti = 1:length(stimTimes)
                    fprintf(fid, '%d ', stimTimes(sti));
                end
            end
            fprintf(fid, '\n');

            cd ..
        end
        cd ..
    end

    fclose(fid);
end