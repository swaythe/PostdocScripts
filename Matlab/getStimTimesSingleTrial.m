subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub11'};
% baseSess = 1;
sessions = 1:4;
stimFile_prefix = 'STSingleTrial';

for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd('/home/sshankar/Categorization/Data/Behavior/'); 
 
    cd(['Scanner/' sub '/']);
    
    stimFile = [stimTimes_folder stimFile_prefix '.1D'];
    fid = fopen(stimFile, 'w');

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');
        
        for rdi=1:length(rd)
            cd(rd(rdi).name);
            if exist([sub '.mat'],'file') == 2
                load([sub '.mat']);
            end
     
            stimTimes = trialTab(:,3)-scanTTLtimes1(1);

            for sti = 1:length(stimTimes)
                fprintf(fid, '%d ', stimTimes(sti));
            end
            fprintf(fid, '\n');

            cd ..
        end
        cd ..
    end

    fclose(fid);
end