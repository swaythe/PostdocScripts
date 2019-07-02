subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% subs = {'Sub04'};
pcs = zeros(20,9);
bins = zeros(20,9);
rks = zeros(20,9);
nBin = 6;

main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';
cd(main_dir)
ctr = 1;

% Rank the accuracies into nBin bins
for si = 1:length(subs)
    sub = subs{si};
    cd(sub)
    load([sub '_behavData'])
    pcs(:,si) = reshape(pc_cond,4*5,1);
    [rks(:,si), t] = tiedrank(pcs(:,si));
    bins(:,si) = ceil(nBin*rks(:,si)/length(rks(:,si)));
    cd ..
end

% Find the mean accuracy values per bin. These mean values will
% subsequently be used to find weights for the coh-dir pairs
binMean = zeros(nBin,9);
for si = 1:9
    for bi = 1:nBin
        binMean(bi,si) = mean(pcs(bins(:,si)==bi,si));
    end
end

% Find the weight associated with each coh-dir pair based on bin means
binWts = zeros(nBin,9);
for si = 1:9
    wt_val = binMean(:,si);
    m = mean(wt_val);
    mult = sqrt(sum((wt_val-m).^2));
    binWts(:,si) = (wt_val-m)./mult;
end

rankBin = reshape(bins,4,5,9);
rankBinMean = binMean;
rankBinWt = binWts;
save(['PCRankandBinMeanWts' int2str(nBin)], 'rankBin', 'rankBinMean', 'rankBinWt')
