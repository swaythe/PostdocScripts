subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
fig = 0;

main_dir = '/home/sshankar/Categorization/Data/';
im_dir = [main_dir 'Imaging/'];
beh_dir = [main_dir 'Behavior/Scanner/'];
roi_dir = [im_dir 'All/ROI_3x3_005unc/'];
roi_var = 'nVoxAnova005uncPositive';
beta_prefix = 'SingleTrial/';

cd(roi_dir)
load('nVox_native')
nROI = size(eval(roi_var),2);

for si = 1:length(subs)
    sub = subs{si};
    beta_dir = [im_dir sub '/Session_' int2str(baseSess(si)) '/' beta_prefix];
    rt_dir = [beh_dir sub];
       
    % Load the beta and RT matrices
    % This loads the following variables into the workspace:
    % betas, betac, betai, rts, rtc, rti
    cd(beta_dir)
    load([sub '_betaMat'])
    
    cohs = size(rts,1);
    dist = size(rts,2);
    
    if si == 1
        % Number of all/correct/inccorect trials when all coherences and
        % distances are considered
        nTCall = zeros(3,cohs);
        nTDall = zeros(3,dist);
        
        % Number of all/correct/inccorect trials when 0% coherence and 0
        % deg distances are not considered
        nTCno0D = zeros(3,cohs);
        nTDno0C = zeros(3,dist);
    end

    for di = 1:dist
        nTDall(1,di) = nTDall(1,di) + length(cat(1,rts{:,di}));
        nTDno0C(1,di) = nTDno0CD(1,di) + length(cat(1,rts{2:end,di}));

        nTDall(2,di) = nTDall(2,di) + length(cat(1,rtc{:,di}));
        nTDno0C(2,di) = nTDno0CD(2,di) + length(cat(1,rtc{2:end,di}));

        nTDall(3,di) = nTDall(3,di) + length(cat(1,rti{:,di}));
        nTDno0C(3,di) = nTDno0CD(3,di) + length(cat(1,rti{2:end,di}));
    end

    for ci = 1:cohs
        nTCall(1,ci) = nTCall(1,ci) + length(cat(1,rts{ci,:}));
        nTCno0D(1,ci) = nTCno0CD(1,ci) + length(cat(1,rts{ci,2:end}));

        nTCall(2,ci) = nTCall(2,ci) + length(cat(1,rtc{ci,:}));
        nTCno0D(2,ci) = nTCno0CD(2,ci) + length(cat(1,rtc{ci,2:end}));

        nTCall(3,ci) = nTCall(3,ci) + length(cat(1,rti{ci,:}));
        nTCno0D(3,ci) = nTCno0CD(3,ci) + length(cat(1,rti{ci,2:end}));
    end
end