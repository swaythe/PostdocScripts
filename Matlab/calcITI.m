subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};

main_dir = '/home/sshankar/Categorization/Data/Behavior/';
cd(main_dir)

for si = 1:length(subs)
    sub = subs{si};
    load(['DirCoh' sub])
    dirs = unique(abs(DirCoh(:,1)));
    cohs = unique(DirCoh(:,2))*100;
    cd(['Scanner/' sub])
    
    itis = cell(4,9);
    miti = zeros(4,9);
    nTr = zeros(4,9);

    for sessi = 1:4
        if si==4 && (sessi==3 || sessi==4)
            dirs(4) = 78;
        end
        cd(['Session_' int2str(sessi)])
        rd = dir('run*');
        for ri = 1:length(rd)
            cd(rd(ri).name)
            load(sub)
            for ti=1:64
                di = find(abs(trialTab(ti,6))==dirs,1);
                ci = find(trialTab(ti,8)==cohs,1);
                if ti==1
                    iti = 1.5;
                else
                    iti = trialTab(ti,12)-trialTab(ti-1,12);
                end
                itis{ci,di} = [itis{ci,di} iti];
                miti(ci,di) = miti(ci,di) + iti;
                nTr(ci,di) = nTr(ci,di) + 1;
            end
            cd ..
        end
        cd ..
    end
    miti = miti./nTr;
    save([sub '_ITI'], 'itis', 'miti', 'nTr')
    cd ../..
end
