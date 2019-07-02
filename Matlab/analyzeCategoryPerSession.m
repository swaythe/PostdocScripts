cd('/home/sshankar/Categorization/Data/Behavior/')
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
sv = 1; % Save data yes/no?
data_file = '_behavData';

%% Behavioral parameters

bounds = [45 135];
resp1 = 49;
resp2 = 50;
dir3 = [0, 180];

for subi = 1:length(subs)
    sub = subs{subi};
    load(['DirCoh' sub])
    cohs = unique(DirCoh(:,2))*100;
    d = unique(abs(DirCoh(:,1)));
    dir1 = d(2:end-1); % All +ve distances from boundary, except 0 & 180
    dir2 = -dir1; % All -ve distances from boundary
    
    %% Get data from each run for the subject for each session
    cd(['Scanner/' sub])
    sess = dir('Session_*');
    for si = 1:length(sess)
        % Analysis variables
        ct = zeros(length(cohs),length(dir1)+1);
        it = zeros(length(cohs),length(dir1)+1);
        rtsc = cell(length(cohs),length(dir1)+1);
        rtsi = cell(length(cohs),length(dir1)+1);

        cd(sess(si).name)
        runs = dir('run*');
        for ri = 1:length(runs)
            cd(runs(ri).name);
            d = dir('*.mat');
            for di = 1:length(d)
               load (d(di).name);
               sessBound = unique(trialTab(:,5));
               for cohi = 1:length(cohs)
                   for diri = 1:length(dir1)
                       idneg = find(trialTab(:,10)-trialTab(:,3)<0);
                       if ~isempty(idneg)
                           sprintf('Session %s, Run %s', sess(si).name, runs(ri).name)
                       end
                       idc = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir1(diri) & trialTab(:,9)==resp1 & (trialTab(:,10)-trialTab(:,3))>0);
                       idi = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir1(diri) & trialTab(:,9)==resp2 & (trialTab(:,10)-trialTab(:,3))>0);
                       ct(cohi, diri) = ct(cohi, diri) + length(idc);
                       it(cohi, diri) = it(cohi, diri) + length(idi);
                       if ~isempty(idc)
                           rtsc{cohi, diri} = [rtsc{cohi, diri}; trialTab(idc,10)-trialTab(idc,3)];
                       end
                       if ~isempty(idi)
                           rtsi{cohi, diri} = [rtsi{cohi, diri}; trialTab(idi,10)-trialTab(idi,3)];
                       end
                   end
                   for diri = 1:length(dir2)
                       idc = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir2(diri) & trialTab(:,9)==resp2 & (trialTab(:,10)-trialTab(:,3))>0);
                       idi = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir2(diri) & trialTab(:,9)==resp1 & (trialTab(:,10)-trialTab(:,3))>0);
                       ct(cohi, diri) = ct(cohi, diri) + length(idc);
                       it(cohi, diri) = it(cohi, diri) + length(idi);
                       if ~isempty(idc)
                           rtsc{cohi, diri} = [rtsc{cohi, diri}; trialTab(idc,10)-trialTab(idc,3)];
                       end
                       if ~isempty(idi)
                           rtsi{cohi, diri} = [rtsi{cohi, diri}; trialTab(idi,10)-trialTab(idi,3)];
                       end
                   end
                   for diri = 1:length(dir3)
    %                    sprintf('%d %d',cohs(cohi), dir3(diri))
                       ids = find(trialTab(:,8)==cohs(cohi) & trialTab(:,6)==dir3(diri) & (trialTab(:,9)==resp1 | trialTab(:,9)==resp2) & (trialTab(:,10)-trialTab(:,3))>0);
                       rs = rand(1,length(ids))>0.5;
                       idc = ids(rs==1);
                       idi = ids(rs==0);
                       ct(cohi, 8) = ct(cohi, 8) + length(idc);
                       it(cohi, 8) = it(cohi, 8) + length(idi);
                       if ~isempty(idc)
                           rtsc{cohi, 8} = [rtsc{cohi, 8}; trialTab(idc,10)-trialTab(idc,3)];
                       end
                       if ~isempty(idi)
                           rtsi{cohi, 8} = [rtsi{cohi, 8}; trialTab(idi,10)-trialTab(idi,3)];
                       end
                   end
               end
            end
            cd ..
        end

        %% RT stuff

        rtc_cond = cell(4,5);
        rti_cond = cell(4,5);
        rts_cond = cell(4,5);
        rtm_cond = zeros(4,5);
        rtsd_cond = zeros(4,5);
        for cohi = 1:length(cohs)
            rtc_cond{cohi,1} = rtsc{cohi,8};
            rtc_cond{cohi,2} = [rtsc{cohi,1}; rtsc{cohi,7}];
            rtc_cond{cohi,3} = [rtsc{cohi,2}; rtsc{cohi,6}];
            rtc_cond{cohi,4} = [rtsc{cohi,3}; rtsc{cohi,5}];
            rtc_cond{cohi,5} = rtsc{cohi,4};

            rti_cond{cohi,1} = rtsi{cohi,8};
            rti_cond{cohi,2} = [rtsi{cohi,1}; rtsi{cohi,7}];
            rti_cond{cohi,3} = [rtsi{cohi,2}; rtsi{cohi,6}];
            rti_cond{cohi,4} = [rtsi{cohi,3}; rtsi{cohi,5}];
            rti_cond{cohi,5} = rtsi{cohi,4};
        end

        for cohi = 1:length(cohs)
            for diri = 1:5
                rts_cond{cohi,diri} = [rtc_cond{cohi,diri}; rti_cond{cohi,diri}];
                rtm_cond(cohi,diri) = mean(rts_cond{cohi,diri});
                rtsd_cond(cohi,diri) = std(rts_cond{cohi,diri});
            end
        end

        %% Accuracy stuff

        pc = ct./(ct+it);
        ct_cond = zeros(4,5);
        ct_cond(:,1) = ct(:,8);
        ct_cond(:,2) = ct(:,1)+ct(:,7);
        ct_cond(:,3) = ct(:,2)+ct(:,6);
        ct_cond(:,4) = ct(:,3)+ct(:,5);
        ct_cond(:,5) = ct(:,4);
        it_cond = zeros(4,5);
        it_cond(:,1) = it(:,8);
        it_cond(:,2) = it(:,1)+it(:,7);
        it_cond(:,3) = it(:,2)+it(:,6);
        it_cond(:,4) = it(:,3)+it(:,5);
        it_cond(:,5) = it(:,4);
        pc_cond = ct_cond./(ct_cond+it_cond);

        %% Data saving stuff
        if sv == 1
            save([sub data_file], 'dir1', 'dir2', 'dir3', 'cohs', 'ct_cond', 'it_cond', 'pc_cond', 'rtc_cond', 'rti_cond', 'rts_cond', 'rtm_cond', 'rtsd_cond'); 
        end
        cd ..
    end
    cd ../..
end