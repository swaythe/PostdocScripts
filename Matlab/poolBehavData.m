subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
behav_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';

inc_trials = zeros(4,5);
corr_trials = zeros(4,5);
rt_trials = cell(4,5);
rtc_trials = cell(4,5);
rti_trials = cell(4,5);

for si = 1:length(subs)
    sub = subs{si};
    cd([behav_dir sub '/'])
    load([sub '_behavData'])
    corr_trials = corr_trials + ct_cond;
    inc_trials = inc_trials + it_cond;
    for ci = 1:4
        for di = 1:5
            rt_trials{ci,di} = [rt_trials{ci,di}; rts_cond{ci,di}];
            rtc_trials{ci,di} = [rtc_trials{ci,di}; rtc_cond{ci,di}];
            rti_trials{ci,di} = [rti_trials{ci,di}; rti_cond{ci,di}];
        end
    end
end

pc_trials = corr_trials ./ (corr_trials+inc_trials);

rtm_trials = zeros(4,5);
rtsd_trials = zeros(4,5);
rtcm_trials = zeros(4,5);
rtcsd_trials = zeros(4,5);
rtim_trials = zeros(4,5);
rtisd_trials = zeros(4,5);

for ci = 1:4
    for di = 1:5
        rtm_trials(ci,di) = mean(rt_trials{ci,di});
        rtsd_trials(ci,di) = std(rt_trials{ci,di});
        rtcm_trials(ci,di) = mean(rtc_trials{ci,di});
        rtcsd_trials(ci,di) = std(rtc_trials{ci,di});
        rtim_trials(ci,di) = mean(rti_trials{ci,di});
        rtisd_trials(ci,di) = std(rti_trials{ci,di});
    end
end

cd(behav_dir);
ct_cond = corr_trials;
it_cond = inc_trials;
pc_cond = pc_trials;
rts_cond = rt_trials;
rtc_cond = rtc_trials;
rti_cond = rti_trials;
rtm_cond = rtm_trials;
rtsd_cond = rtsd_trials;
rtcm_cond = rtcm_trials;
rtcsd_cond = rtcsd_trials;
rtim_cond = rtim_trials;
rtisd_cond = rtisd_trials;

save('All_behavData.mat', 'ct_cond', 'it_cond', 'rts_cond', 'rtc_cond', 'rti_cond', 'pc_cond', 'rtm_cond', 'rtsd_cond', 'rtcm_cond', 'rtcsd_cond', 'rtim_cond', 'rtisd_cond');
