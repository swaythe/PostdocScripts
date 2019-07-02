sub = 'Sub11';
% cd(['/home/sshankar/Categorization/Data/Behavior/Training/' sub])
cd(['/home/sshankar/Categorization/Data/Behavior/Scanner/' sub])

xTick = 1:16;
xTickLab = ['-168';'-135';'-102';' -90';' -78';' -45';' -12';'   0';'  12';'  45';'  78';'  90';' 102';' 135';' 168';' 180'];
% xTickLab = ['-165';'-135';'-102';' -90';' -75';' -45';' -15';'   0';'  15';'  45';'  75';'  90';' 105';' 135';' 165';' 180'];
% xTickLab = ['-170';'-135';'-100';' -90';' -80';' -45';' -10';'   0';'  10';'  45';'  80';'  90';' 100';' 135';' 170';' 180'];

symb = ['o' 'd' '<' 's' '>' 'v'];
cs = ['r' 'g' 'b' 'c' 'm' 'k'];

sess = dir('Session_*');
nIncButton = zeros(length(sess),6);
for si = 1:length(sess)
    cd(sess(si).name)
    figure
    runs = dir('run*');
    delta = 0;

    for ri = 1:length(runs)
        cd(runs(ri).name)
        load(sub)
        ids = find(trialTab(:,8)==100);
        dirs = trialTab(ids,6);
        [sdir i] = sort(dirs);
        f = subplot(1,1,1);
        hold on
        plot(f, xTick+delta, trialTab(ids(i),11), symb(ri), 'color', cs(ri), 'LineStyle', '-');
        delta = delta + 0.1;
        set(f, 'Xtick', xTick, 'XtickLabel', xTickLab)
        cd ..
    end
    cd ..
end

