subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
sessions = 1:4;
corr = 0; % Correct trials = 1; Incorrect trials = 0
stimFile = 'STMEIncNonRoi.1D';

for si = 1:length(subs)
    sub = subs{si};
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    cd(['Scanner/' sub '/']);
    fid = fopen(stimFile, 'w');

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');
        rd = rd(3:end);

        stimTimes = zeros(length(rd), 64);

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
                vIds = find(trialTab(:,9) ~= 48 & (trialTab(:,10)-trialTab(:,3))>0 & trialTab(:,11) == corr);
                stimTimes(rdi,1:length(vIds)) = trialTab(vIds,3) - scanTTLtimes1(1);
            end
            cd ..
        end

        for i = 1:length(rd)
            rCtr = 0;
            for j = 1:64
                if stimTimes(i,j) ~= 0
                    rCtr = rCtr + 1;
                    fprintf(fid, '%d ', stimTimes(i,j));
                else
                    continue
                end
            end
            if rCtr == 0
                disp(sub)
                fprintf(fid, '*');
            end
            fprintf(fid, '\n');
        end
        cd ..
    end
    fclose(fid);

    stimDir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];

    if ~exist(stimDir, 'dir')
        system(['mkdir ' stimDir]);
    end
    system(['cp ' stimFile ' ' stimDir]);
end