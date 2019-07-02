% This program compares accuracy values from the intermediate coherence and
% distance conditions between any two subjects.
% If the z value is less than -1.96 or greater than +1.96 then the two
% subjects are significantly different at an alpha of 0.05

subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
home_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/';

cd(home_dir)
zcoh = zeros(length(subs)-1,5,4,length(subs));
zdir = zeros(length(subs)-1,4,5,length(subs));

for si = 1:length(subs)
    zctr = 1;
    for sj = 1:length(subs)
        if si~=sj
            d1 = load([subs{si} '/' subs{si} '_behavData']);
            d2 = load([subs{sj} '/' subs{sj} '_behavData']);
            for nC = 1:4
                pc1coh = d1.pc_cond(nC,:);
                pc2coh = d2.pc_cond(nC,:);
                
                x1coh = d1.ct_cond(nC,:);
                x2coh = d2.ct_cond(nC,:);
                
                n1coh = x1coh + d1.it_cond(nC,:);
                n2coh = x2coh + d2.it_cond(nC,:);
                
                pcoh = (x1coh + x2coh)./(n1coh + n2coh);
                
                zcoh(zctr,:,nC,si) = (pc1coh - pc2coh)./sqrt(pcoh.*(1-pcoh).*(1./n1coh+1./n2coh));
            end
            for nD = 1:5
                pc1dir = d1.pc_cond(:,nD)';
                pc2dir = d2.pc_cond(:,nD)';
                
                x1dir = d1.ct_cond(:,nD)';
                x2dir = d2.ct_cond(:,nD)';
                
                n1dir = x1dir + d1.it_cond(:,nD)';
                n2dir = x2dir + d2.it_cond(:,nD)';
                
                pdir = (x1dir + x2dir)./(n1dir + n2dir);

                zdir(zctr,:,nD,si) = (pc1dir - pc2dir)./sqrt(pdir.*(1-pdir).*(1./n1dir+1./n2dir));
            end
            zctr = zctr + 1;
        end
    end
end
