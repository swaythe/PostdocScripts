allsubs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
subs = {'Sub01','Sub02','Sub04','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 1 1 1 1 1];
% subs = {'Sub05'};
% baseSess = 2;
% subs = {'Sub01'};
% baseSess = 1;
sessions = 1:4;
corr = 0; % Correct trials = 1; Incorrect trials = 0
stimFile = 'ST_CDRTAccIncorrect.1D';

cd('/home/sshankar/Categorization/Data/Behavior/Scanner/'); 
load('cdWts')
load('rtWts')
load('PCRankandBinMeanWts4')
cd ..

for si = 1:length(subs)
    sub = subs{si};
    subNo = find(strcmp(allsubs,sub)==1);
    load(['DirCoh' sub '.mat']);
    cd(['Scanner/' sub '/'])
    if corr == 1
        rts = rtcQ(:,subNo);
        rtregs = rtcWt(:,subNo);
    else
        rts = rtiQ(:,subNo);
        rtregs = rtiWt(:,subNo);
    end
    
    cohs = unique(DirCoh(:,2))*100; 
    dirs = unique(abs(DirCoh(:,1)));
    cregs = cWt(:,subNo);
    dreg = dWt(:,subNo)';
    dregs = [dreg(1:end) fliplr(dreg(1:end-1))];
    accBin = rankBin(:,:,subNo);
    accWts = rankBinWt(:,subNo);
    
    fid = fopen(stimFile, 'w');

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        cohIds = ones(length(rd), 64);
        dirIds = ones(length(rd), 64);
        rtIds = ones(length(rd), 64);
        stimTimes = zeros(length(rd), 64);

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
                vIds = find(trialTab(:,9) ~= 48 & trialTab(:,11) == corr & (trialTab(:,10)-trialTab(:,3))>0);
                stimTimes(rdi,1:length(vIds)) = trialTab(vIds,3) - scanTTLtimes1(1);
                cohIds(rdi,1:length(vIds)) = trialTab(vIds,8);
                dirIds(rdi,1:length(vIds)) = abs(trialTab(vIds,6));
                rtIds(rdi,1:length(vIds)) = trialTab(vIds,10) - trialTab(vIds,3);
            end
            cd ..
        end

        cIds = ones(length(rd), 64) * -1;
        dIds = ones(length(rd), 64) * -1;
        rIds = ones(length(rd), 64) * -1;
        acIds = ones(length(rd), 64) * -1;
        adIds = ones(length(rd), 64) * -1;

        for rdi = 1:length(rd)
            for ci = 1:length(cohs)
                id = (cohIds(rdi,:) == cohs(ci));
                cIds(rdi,id) = cregs(ci);
                acIds(rdi,id) = ci;
            end

            for di = 1:length(dirs)
                id = (dirIds(rdi,:) == dirs(di));
                if di == 4
                    % This weirdness is needed only Sessions 3&4 of Sub05 
                    % because I mistakenly created directions of 68 and -68
                    % instead of 78 and -78
%                     id = (dirIds(rdi,:) == 78);
                end
                dIds(rdi,id) = dregs(di);
                if di <= 5
                    adIds(rdi,id) = di;
                else
                    adIds(rdi,id) = 10 - di;
                end
            end
            
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
                if cIds(i,j) ~= -1 && dIds(i,j) ~= -1
                    rCtr = rCtr + 1;
                    if length(cohs) == 1
                        fprintf(fid, '%d*%d,%d ', stimTimes(i,j), dIds(i,j), rIds(i,j));
                    elseif length(dirs) == 1 || length(dirs) == 2 || length(dirs) == 3
                        fprintf(fid, '%d*%d,%d ', stimTimes(i,j), cIds(i,j), rIds(i,j));
                    else
                        fprintf(fid, '%d*%d,%d,%d,%d ', stimTimes(i,j), cIds(i,j), dIds(i,j), rIds(i,j), accWts(accBin(acIds(i,j),adIds(i,j))));
%                         fprintf(fid, '%d*%d,%d ', stimTimes(i,j), cIds(i,j), dIds(i,j));
                    end
        %         fprintf(fid, '%d ', stimTimes(i,j));
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