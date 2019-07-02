subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub05'};
% baseSess = 2;
sessions = 1:4;
corr = 1; % Correct trials = 1; Incorrect trials = 0
stimFile_prefix = 'STCD';

for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    load(['DirCoh' sub '.mat']);
    cohs = unique(DirCoh(:,2))*100; 
%     cohs = cohs(3);
    dirs = unique(abs(DirCoh(:,1)));
    dirNo = [1 2 3 4 5 4 3 2 1];
%     dirs = dirs([4 6]);
%     dirNo = dirNo([4 6]);

    cd(['Scanner/' sub '/']);
    nFiles = length(cohs)*length(unique(dirNo));
    fid = zeros(nFiles,1);

    for cdComb = 1:nFiles
        stimFile = [stimTimes_folder stimFile_prefix int2str(cdComb) '.1D'];
        fid(cdComb) = fopen(stimFile, 'w');
    end

    for sessId = 1:length(sessions)
        if srtcmp(sub,'Sub05') && (sessions(sessId)==3 || sessions(sessId)==4)
            dirs(4) = 78;
        end
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
            end

            cdComb = 1;
            stimTimes = [];
            for ci = 1:length(cohs)
                for di = 1:length(unique(dirNo))
                    dIdx = find(dirNo == dirNo(di));
                    for ddi = 1:length(dIdx)
                        ids = find(trialTab(:,8)==cohs(ci) & abs(trialTab(:,6))==dirs(dIdx(ddi)) & trialTab(:,9)~=48 & trialTab(:,11)==corr & (trialTab(:,10)-trialTab(:,3))>0);
                        stimTimes = [stimTimes; trialTab(ids,3)-scanTTLtimes1(1)];
                    end
                    stimTimes = sort(stimTimes);
                    if isempty(stimTimes)
                        fprintf(fid(cdComb), '*');
                    else
                        for sti = 1:length(stimTimes)
                            fprintf(fid(cdComb), '%d ', stimTimes(sti));
                        end
                    end
                    fprintf(fid(cdComb), '\n');

                    cdComb = cdComb + 1;
                    stimTimes = [];
                end
            end
            cd ..
        end
        cd ..
    end

    for cdComb = 1:nFiles
        fclose(fid(cdComb));
    end
end