subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
sessions = 1:4;

cdgrid = reshape(1:64,4,16);
cds = cell(1,9);
colors = 'rgbcmykrg';
for si = 1:length(subs)
    sub = subs{si};
    stimTimes_folder = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/StimTimes/'];
    cd(['/home/sshankar/Categorization/Data/Behavior/Scanner/' sub '/']); 

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/']);
        rd = dir('run*');

        for rdi=1:length(rd)
            cd(rd(rdi).name)
            load([sub '.mat']);
            cohs = unique(trialTab(:,8))';
            dirs = unique(trialTab(:,6))';
            crep = repmat(cohs,64,1);
            drep = repmat(dirs,64,1);
            c = bsxfun(@eq,crep,trialTab(:,8));
            [i jc] = find(c==1);
            [x iidc] = sort(i);
            d = bsxfun(@eq,drep,trialTab(:,6));
            [i jd] = find(d==1);
            [x iidd] = sort(i);
            cd ..
            cds{1,si} = [cds{1,si}; diag(cdgrid(jc(iidc)',jd(iidd)'))];
        end
        cd ..
    end
    figure
    plot(cds{1,si},'.')
end