subs = {'Sub05'};
main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';
cd(main_dir)

for si = 1:length(subs)
    load([subs{si} '/' subs{si} '_behavData'])
    rtByCoh = cell(1,4);
    rtmByCoh = zeros(1,4);
    rtsdByCoh = zeros(1,4);
    for i=1:4
        for j=4:5
            rtByCoh{i} = [rtByCoh{i}; rts_cond{i,j}];
        end
        rtmByCoh(i) = mean(rtByCoh{i});
        rtsdByCoh(i) = std(rtByCoh{i});
    end

    rtByDir = cell(1,5);
    rtmByDir = zeros(1,5);
    rtsdByDir = zeros(1,5);
    for j=1:5
        for i=4:4
            rtByDir{j} = [rtByDir{j}; rts_cond{i,j}];
        end
        rtmByDir(j) = mean(rtByDir{j});
        rtsdByDir(j) = std(rtByDir{j});
    end
    save([subs{si} '/' subs{si} '_RTbyCohDirHigh'],'rtByCoh','rtmByCoh','rtsdByCoh','rtByDir','rtmByDir','rtsdByDir');
end