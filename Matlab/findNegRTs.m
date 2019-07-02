% main_dir = '/home/sshankar/Categorization/Data/Behavior/Training/'; 
main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/'; 
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
subs = {'Sub01','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};

for si = 1:length(subs)
    cd([main_dir subs{si} '/']);
    sessions = dir('Sess*');
    for sessId = 1:length(sessions)
        cd(sessions(sessId).name);
        rd = dir('run*');
        for rdi=1:length(rd)
            cd(rd(rdi).name);
            load(subs{si});
            rts = trialTab(:,10) - trialTab(:,3);
            ids = find(rts<0);
            if ~isempty(ids)
                sprintf('Sub %s; Session %s; Run %s\n', subs{si}, sessions(sessId).name, rd(rdi).name)
            end
            cd ..
        end
        cd ..
    end
end