subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub01'};
% baseSess = 1;
sessions = 1:4;
stimFile = 'STExtremeCDIncorrect.1D';

for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    
    cd(['Scanner/' sub '/']);
    fid = fopen([stimTimes_folder stimFile], 'w');
    
    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
            end

            ids = find((trialTab(:,8)==0 | trialTab(:,8)==100 | abs(trialTab(:,6))==0 | abs(trialTab(:,6))==180 | abs(trialTab(:,6))==90) & trialTab(:,11)==0 & trialTab(:,9)~=48 & (trialTab(:,10)-trialTab(:,3))>0);
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