main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/'; 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};

output_file = 'FriedmanCD_PC.mat';
nCoh = 4;
nDir = 5;
nSub = 8;
cdmat = zeros(nCoh, nDir, nSub);
friedMat = zeros(nCoh*nSub, nDir);
ctr = 1;

for si = 1:nSub
    load([main_dir subs{si} '/' subs{si} '_behavData'])
    cdmat(:,:,si) = ct_cond./(ct_cond+it_cond);
end

for ci = 1:nCoh
    for si = 1:nSub
        friedMat(ctr,:) = cdmat(ci,:,si);
        ctr = ctr + 1;
    end
end

[p table stats] = friedman(friedMat, nSub, 'on');
[mcomp, means, h, gnames] = multcompare(stats, 'Dimension', [1 2]);