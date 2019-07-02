allsubs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};

subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

sessions = 1:4;
corr = 0; % Correct trials = 1; Incorrect trials = 0
stimFile = 'STRTIncorrect.1D';
dregs = [1 2 3 4 5 4 3 2 1];

main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';
cd(main_dir)
load('rtWts')

for si = 1:length(subs)
    sub = subs{si};
    subNo = find(strcmp(allsubs,sub)==1);
    
    if corr == 1
        rts = rtcQ(:,subNo);
        rtregs = rtcWt(:,subNo);
    else
        rts = rtiQ(:,subNo);
        rtregs = rtiWt(:,subNo);
    end

    cd([main_dir sub])
    fid = fopen(stimFile, 'w');

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        rtIds = ones(length(rd), 64);
        stimTimes = zeros(length(rd), 64);

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
                vIds = find(trialTab(:,9) ~= 48 & trialTab(:,11) == corr & (trialTab(:,10)-trialTab(:,3))>0);
                stimTimes(rdi,1:length(vIds)) = trialTab(vIds,3) - scanTTLtimes1(1);
                rtIds(rdi,1:length(vIds)) = trialTab(vIds,10) - trialTab(vIds,3);
            end
            cd ..
        end

        rIds = ones(length(rd), 64) * -1;

        for rdi = 1:length(rd)    
            for rti = 1:length(rts)
                if rti == 1
                    id = (rtIds(rdi,:) <= rts(rti));
                else
                    id = ((rtIds(rdi,:) <= rts(rti))) & (rtIds(rdi,:) > rts(rti-1));
                end
                rIds(rdi,id) = rtregs(rti);
            end
        end

        for i = 1:length(rd)
            rCtr = 0;
            for j = 1:64
                if rIds(i,j) ~= -1
                    rCtr = rCtr + 1;
                    fprintf(fid, '%d*%d ', stimTimes(i,j), rIds(i,j));
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