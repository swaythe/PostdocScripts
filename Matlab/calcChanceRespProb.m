main_dir = '/ace/old-ace/8tb/sshankar/Categorization/Data/Behavior/Scanner';
cd(main_dir)
load('lowCD_resp')

nSub = 9;
nc = 4;
nd = 5;

% Sum button presses for each subject, across all 0c and 0d conditions 
resp_0d_sub = squeeze(sum(resp_0d,1));
resp_0c_sub = squeeze(sum(resp_0c,1));

% Variables to store probability (calculated using binomial
% probability) of fraction being different from 0.5
pr_0d = zeros(nc,nSub);
pr_0c = zeros(nd,nSub);
pr_0d_sub = zeros(1,nSub);
pr_0c_sub = zeros(1,nSub);

% Calculate probability
for si = 1:nSub
    % For each CD pair
    for ci = 1:nc
        n = sum(resp_0d(ci,:,si));
        kl = resp_0d(ci,1,si);
        pr_0d(ci,si) = binprob(n,kl,0.5);
    end
    for di = 1:nd
        n = sum(resp_0c(di,:,si));
        kl = resp_0c(di,1,si);
        pr_0c(di,si) = binprob(n,kl,0.5);
    end
    % Combining all distances for 0 coherence, and vice versa
    n = sum(resp_0d_sub(:,si));
    kl = resp_0d_sub(1,si);
    pr_0d_sub(si) = binprob(n,kl,0.5);
    
    n = sum(resp_0c_sub(:,si));
    kl = resp_0c_sub(1,si);
    pr_0c_sub(si) = binprob(n,kl,0.5);
end

% Do a t-test on the fraction of L responses overall, per subject
[h, p, c, s] = ttest(fsub_resp_0d,0.5);
ptt_0d = p;

[h, p, c, s] = ttest(fsub_resp_0c,0.5);
ptt_0c = p;

f_resp_0c = squeeze(f_resp_0c);
f_resp_0d = squeeze(f_resp_0d);

save('lowCD_resp', 'resp_0c', 'resp_0d', 'f_resp_0c', 'f_resp_0d', 'fsub_resp_0c', 'fsub_resp_0d', 'pr_0c', ...
    'pr_0d', 'pr_0c_sub', 'pr_0d_sub', 'ptt_0c', 'ptt_0d');
