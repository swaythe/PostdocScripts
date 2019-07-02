% subs = {'Sub01','Sub02','Sub04','Sub06','Sub08','Sub10','Sub11','Sub13','Sub05'};
% baseSess = [1 1 1 1 1 1 1 1 2];
% subs = {'Sub01','Sub02','Sub04','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 1 1 1 1 1];
% subs = {'Sub05'};
% baseSess = 2;
subs = {'Sub11'};
baseSess = 1;
sessions = 1:4;
corr = 1; % Correct trials = 1; Incorrect trials = 0
stimFile = 'STparamCDnonroi.1D';

for si = 1:length(subs)
    sub = subs{si};
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    load(['DirCoh' sub '.mat']);
    cohs = unique(DirCoh(:,2))*100; 
%     cohs = cohs(1);
    coh_param = cohs;
    dirs = unique(abs(DirCoh(:,1)));
%     dirs = dirs([4 6]);
    % dirs = dirs([4 5 6]);
    % For Sub05 sessions 3&4
%     dirs = [78 dirs(6)'];

    dir_param = dirs(1:5);
%     dir_param = dirs(1);
%     dir_param = dirs(1:2);
    % dirs = dirs(2:end-1);

    makeparametricweights;
    cregs = creg;
    if length(dreg)>1
        dregs = [dreg(1:end) fliplr(dreg(1:end-1))];
    else
        if length(dirs)==2
            dregs = [dreg dreg];
        elseif length(dirs)==3
            dregs = [dreg dreg dreg];
        else
            dregs = dreg;
        end
    end

    cd(['Scanner/' sub '/']);
    fid = fopen(stimFile, 'w');

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');
        if sessions(sessId)==1 || sessions(sessId)==2
            rd = rd(3:end);
        else
            rd = rd(2:end);
        end
        cohIds = ones(length(rd), 64);
        dirIds = ones(length(rd), 64);
        stimTimes = zeros(length(rd), 64);

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
                vIds = find(trialTab(:,9) ~= 48 & trialTab(:,11) == corr & (trialTab(:,10)-trialTab(:,3))>0);
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
                cIds(rdi,id) = cregs(ci);
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
            for j = 1:64
                if cIds(i,j) ~= -1 && dIds(i,j) ~= -1
                    if length(cohs) == 1
                        fprintf(fid, '%d*%d ', stimTimes(i,j), dIds(i,j));
                    elseif length(dirs) == 1 || length(dirs) == 2 || length(dirs) == 3
                        fprintf(fid, '%d*%d ', stimTimes(i,j), cIds(i,j));
                    else
                        fprintf(fid, '%d*%d,%d ', stimTimes(i,j), cIds(i,j), dIds(i,j));
                    end
        %         fprintf(fid, '%d ', stimTimes(i,j));
                else
                    continue
                end
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