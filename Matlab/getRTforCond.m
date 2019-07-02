subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
baseSess = [1 1 1 2 1 1 1 1];
sessions = 1:4;
bound = 45;
% corr = 1; % Correct trials = 1; Incorrect trials = 0
rtCond = cell(length(subs),3);

for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
    load(['DirCoh' sub '.mat']);
    cohs = unique(DirCoh(:,2))*100; 
    cohs = cohs([1 3]);
    dirs = unique(abs(DirCoh(:,1)));
    dirs = dirs([5]);

    cd(['Scanner/' sub '/']);
    rts = [];

    for sessId = 1:length(sessions)
        % This weirdness only required for Sub05
    %     if sessId==3 || sessId==4
    %         dirs(4) = 78;
    %     end
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
            end

            stimTimes = [];
            for ci = 1:length(cohs)
                for di = 1:length(dirs)
                    ids = find(trialTab(:,5)==bound & trialTab(:,8)==cohs(ci) & abs(trialTab(:,6))==dirs(di) & trialTab(:,9) ~= 48 & (trialTab(:,10)-trialTab(:,3))>0);% & trialTab(:,11) == corr);
                    rtCond{si,ci} = [rtCond{si,ci}; trialTab(ids,10)-trialTab(ids,3)];
                end
            end
            cd ..
        end
        cd ..
    end
end

rtm = zeros(length(subs),2);
rtsd = zeros(length(subs),2);

for si = 1:length(subs)
    rtCond{si,1} = [rtCond{si,1}; rtCond{si,3}];
    for rti = 1:2
        rtm(si,rti) = mean(rtCond{si,rti});
        rtsd(si,rti) = std(rtCond{si,rti});
    end
end

figure
errorbar(rtm(:,1), rtsd(:,1), 'r')
hold on
errorbar(rtm(:,2), rtsd(:,2), 'b')