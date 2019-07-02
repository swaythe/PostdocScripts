sub = 'Sub11';

home_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/'];
cd(home_dir)

MD1D = zeros(1,300);
sess = dir('Session_*');

for si = 1:length(sess)
    cd([home_dir sess(si).name '/NIFTIS/'])
    mdFiles = dir('*MD1D.txt');
    for mi = 1:length(mdFiles)
        fid = fopen(mdFiles(mi).name);
        f = textscan(fid, '%s');
        temp = f{1};
        for i = 1:300
            MD1D(i) = str2double(temp{i+2});
        end
        save(mdFiles(mi).name(1:end-4), 'MD1D');
    end
end