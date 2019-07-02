subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
home_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';

cd(home_dir)
zcoh = zeros(3,5,4,length(subs));
zdir = zeros(3,4,4,length(subs));

for subi = 1:length(subs)
    cd(subs{subi});
    sess = dir('Sess*');
    for si = 1:length(sess)
        zctr = 1;
        for sj = 1:length(sess)
            if si~=sj
                d1 = load([sess(si).name '/' subs{subi} '_behavData']);
                d2 = load([sess(sj).name '/' subs{subi} '_behavData']);
                pc1coh = d1.pc_cond(2,:);
                pc1dir = d1.pc_cond(:,4)';
                pc2coh = d2.pc_cond(2,:);
                pc2dir = d2.pc_cond(:,4)';

                x1coh = d1.ct_cond(2,:);
                x1dir = d1.ct_cond(:,4)';
                x2coh = d2.ct_cond(2,:);
                x2dir = d2.ct_cond(:,4)';

                n1coh = x1coh + d1.it_cond(2,:);
                n1dir = x1dir + d1.it_cond(:,4)';
                n2coh = x2coh + d2.it_cond(2,:);
                n2dir = x2dir + d2.it_cond(:,4)';

                pcoh = (x1coh + x2coh)./(n1coh + n2coh);
                pdir = (x1dir + x2dir)./(n1dir + n2dir);

                zcoh(zctr,:,si,subi) = (pc1coh - pc2coh)./sqrt(pcoh.*(1-pcoh).*(1./n1coh+1./n2coh));
                zdir(zctr,:,si,subi) = (pc1dir - pc2dir)./sqrt(pdir.*(1-pdir).*(1./n1dir+1./n2dir));
                zctr = zctr + 1;
            end
        end
    end
    cd ..
end