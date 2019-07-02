subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
main_dir = '/home/sshankar/Categorization/Data/Behavior/';
cd(main_dir)
ctr = 1;
cWt = zeros(4,length(subs));
dWt = zeros(5,length(subs));

for si = 1:length(subs)
    sub = subs{si};    
    load(['DirCoh' sub])
    cohs = unique(DirCoh(:,2))*100;
    dirs = unique(abs(DirCoh(:,1)));
    coh_param = cohs;
    dir_param = dirs(1:5);
    makeparametricweights;
    cWt(:,si) = creg;
    dWt(:,si) = dreg;
end

save('Scanner/cdWts', 'cWt', 'dWt');
