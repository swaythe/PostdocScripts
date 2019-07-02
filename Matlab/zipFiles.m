subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
baseDir = 'NIFTIS';

% sub = 'Sub04';
sess = 1:4;
zip_file = 'EPI*CoReg*gz';
command = ['gunzip ' zip_file];

for subi = 1:length(subs)
    sub = subs{subi};
    zip_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/'];
    cd(zip_dir);
    
    for si = 1:length(sess)
        cd(['Session_' int2str(sess(si)) '/NIFTIS/'])
        system(command)
        cd ../..
    end
end