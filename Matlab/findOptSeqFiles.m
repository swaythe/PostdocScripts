subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
osFile = zeros(9*4*6,1);

main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';
cd(main_dir)
ctr = 1;

for si = 1:length(subs)
    sub = subs{si};
    cd(sub)
    for sessi = 1:4
        cd(['Session_' int2str(sessi)])
        rd = dir('run*');
        for ri = 1:length(rd)
            cd(rd(ri).name)
            f = fopen([sub '.txt'],'r');
            txt = textscan(f,'%s',3,'Delimiter','\n');
            txt = txt{1,1};
            osFile(ctr) = str2double(txt{3}(end-5:end-4));
            ctr = ctr + 1;
            fclose(f);
            cd ..
        end
        cd ..
    end
    cd ..
end

osFile = osFile(1:ctr-1);
