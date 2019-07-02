allsubs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};

% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
subs = {'Sub01','Sub02','Sub04','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 1 1 1 1 1];
% subs = {'Sub05'};
% baseSess = 2;

sessions = 1:4;
corr = 0; % Correct trials = 1; Incorrect trials = 0
stimFile = 'STAcc4binAll.1D';
dregs = [1 2 3 4 5 4 3 2 1];

main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';
cd(main_dir)
load('PCRankandBinMeanWts6')

ctr = 1;

for si = 1:length(subs)
    sub = subs{si};
    subNo = find(strcmp(allsubs,sub)==1);
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    load(['DirCoh' sub '.mat']);
    cohs = unique(DirCoh(:,2))*100;
    dirs = unique(abs(DirCoh(:,1)));
    
    rkBin = rankBin(:,:,subNo);
    wts = rankBinWt(:,subNo);
    
    cd([main_dir sub])
    fid = fopen(stimFile, 'w');

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        cohIds = ones(length(rd), 64);
        dirIds = ones(length(rd), 64);
        stimTimes = zeros(length(rd), 64);

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
                vIds = find(trialTab(:,9) ~= 48 & (trialTab(:,10)-trialTab(:,3))>0);% & trialTab(:,11) == corr);
                stimTimes(rdi,1:length(vIds)) = trialTab(vIds,3) - scanTTLtimes1(1);
                cohIds(rdi,1:length(vIds)) = trialTab(vIds,8);
                dirIds(rdi,1:length(vIds)) = abs(trialTab(vIds,6));
            end
            cd ..
        end

        cIds = ones(length(rd), 64) * -1;
        dIds = ones(length(rd), 64) * -1;

        for rdi = 1:length(rd)
            for ci = 1:length(cohs)
                id = (cohIds(rdi,:) == cohs(ci));
                cIds(rdi,id) = ci;
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
            end
        end

        for i = 1:length(rd)
            rCtr = 0;
            for j = 1:64
                if cIds(i,j) ~= -1 && dIds(i,j) ~= -1
                    rCtr = rCtr + 1;
                    fprintf(fid, '%d*%d ', stimTimes(i,j), wts(rkBin(cIds(i,j),dIds(i,j))));
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
    system(['cp ' stimFile ' ' stimDir]);
end
