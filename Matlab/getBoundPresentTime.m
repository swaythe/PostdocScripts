subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
sessions = 1:4;
stimFile_prefix = 'BoundPres';

nFiles = length(subs);
fid = zeros(nFiles,1);

for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd(['/home/sshankar/Categorization/Data/Behavior/Scanner/' sub '/']); 

    stimFile1 = [stimTimes_folder stimFile_prefix '_45.1D'];
    stimFile2 = [stimTimes_folder stimFile_prefix '_135.1D'];
    fid(si) = fopen(stimFile1, 'w');
    fid(si+length(subs)) = fopen(stimFile2, 'w');

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');
        
        for rdi=1:length(rd)
            load([rd(rdi).name '/' sub])
            if trialTab(1,5)==45
                fprintf(fid(si), '%d\n', 0);
                fprintf(fid(si+length(subs)), '*\n');
            else
                fprintf(fid(si+length(subs)), '%d\n', 0);
                fprintf(fid(si), '*\n');
            end
            
        end
        cd ..
    end

  fclose(fid(si));
end