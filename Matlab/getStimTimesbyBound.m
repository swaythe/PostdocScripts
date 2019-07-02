subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
sessions = 1:4;
bound = 135;
corr = 1; % Correct trials = 1; Incorrect trials = 0
stimFile_prefix = 'STB2vert';

for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    load(['DirCoh' sub '.mat']);
    cohs = unique(DirCoh(:,2))*100; 
%     cohs = cohs(3);
    dirs = unique(DirCoh(:,1));
%     dirs = dirs([6 14]); % For bound = 45
    dirs = dirs([2 10]); % For bound = 135
    
    cd(['Scanner/' sub '/']);
    nFiles = length(cohs);
    fid = zeros(nFiles,1);

    for cdComb = 1:nFiles
        stimFile = [stimTimes_folder stimFile_prefix 'c' int2str(cdComb) '.1D'];
        fid(cdComb) = fopen(stimFile, 'w');
    end

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
            end

            stimTimes = [];
            for ci = 1:length(cohs)
                ids = [];
                for di = 1:length(dirs)
                    ids = [ids; find(trialTab(:,5)==bound & trialTab(:,8)==cohs(ci) & trialTab(:,6)==dirs(di) & trialTab(:,9)~=48 & (trialTab(:,10)-trialTab(:,3))>0 & trialTab(:,11)==corr)];
                end
                stimTimes = [stimTimes; trialTab(ids,3)-scanTTLtimes1(1)];
                stimTimes = sort(stimTimes);
                if isempty(stimTimes)
                    fprintf(fid(ci), '*');
                else
                    for sti = 1:length(stimTimes)
                        fprintf(fid(ci), '%d ', stimTimes(sti));
                    end
                end
                fprintf(fid(ci), '\n');
                stimTimes = [];                
            end
            cd ..
        end
        cd ..
    end

    for cdComb = 1:nFiles
        fclose(fid(cdComb));
    end
end