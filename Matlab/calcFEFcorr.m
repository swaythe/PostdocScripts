% subs = {'Sub01'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
nSub = length(subs);

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
bdir_prefix = 'SingleTrial';
beta_common = 'AnovaCorr';
beta_prefix = ['betaMat_' beta_common];
roi = 12; % ROI # of the FEF ROI
CorrMat_prefix = ['CorrMat_' beta_common '_' int2str(roi)];

for si = 1:nSub
    sub = subs{si};
    beta_dir = [main_dir  sub '/Session_' int2str(baseSess(si)) '/' bdir_prefix '/'];
    cd(beta_dir)
    load([sub '_' beta_prefix])
    
    if si == 1
        nROI = size(betaMat,2);
        cohs = size(betac,1);
        dist = size(betac,2);
        
        ccs = zeros(cohs,dist,nROI,nSub);
        ccc = zeros(cohs,dist,nROI,nSub);
        cci = zeros(cohs,dist,nROI,nSub);
        
        ccCs = zeros(cohs,nROI,nSub);
        ccCc = zeros(cohs,nROI,nSub);
        ccCi = zeros(cohs,nROI,nSub);
        
        ccDs = zeros(dist,nROI,nSub);
        ccDc = zeros(dist,nROI,nSub);
        ccDi = zeros(dist,nROI,nSub);
    end
    
    for ri = 1:nROI
        for ci = 1:cohs
            for di = 1:dist
                if length(betas{ci,di,roi}) <= 10 || length(betas{ci,di,ri}) <= 10
                    ccs(ci,di,ri,si) = NaN;
                else
                    temp = corrcoef(betas{ci,di,roi},betas{ci,di,ri});
                    ccs(ci,di,ri,si) = temp(1,2);
                end
                
                if length(betac{ci,di,roi}) <= 10 || length(betac{ci,di,ri}) <= 10
                    ccc(ci,di,ri,si) = NaN;
                else
                    temp = corrcoef(betac{ci,di,roi},betac{ci,di,ri});
                    ccc(ci,di,ri,si) = temp(1,2);
                end
                
                if length(betai{ci,di,roi}) <= 10 || length(betai{ci,di,ri}) <= 10
                    cci(ci,di,ri,si) = NaN;
                else
                    temp = corrcoef(betai{ci,di,roi},betai{ci,di,ri});
                    cci(ci,di,ri,si) = temp(1,2);
                end
                if ci == 1
                    if length(cat(1,betas{:,di,roi})) <= 10 || length(cat(1,betas{:,di,ri})) <= 10
                        ccDs(di,ri,si) = NaN;
                    else
                        temp = corrcoef(cat(1,betas{:,di,roi}),cat(1,betas{:,di,ri}));
                        ccDs(di,ri,si) = temp(1,2);
                    end
                    
                    if length(cat(1,betac{:,di,roi})) <= 10 || length(cat(1,betac{:,di,ri})) <= 10
                        ccDc(di,ri,si) = NaN;
                    else
                        temp = corrcoef(cat(1,betac{:,di,roi}),cat(1,betac{:,di,ri}));
                        ccDc(di,ri,si) = temp(1,2);
                    end
                    
                    if length(cat(1,betai{:,di,roi})) <= 10 || length(cat(1,betai{:,di,ri})) <= 10
                        ccDi(di,ri,si) = NaN;
                    else
                        temp = corrcoef(cat(1,betai{:,di,roi}),cat(1,betai{:,di,ri}));
                        ccDi(di,ri,si) = temp(1,2);
                    end
                end
            end
            if length(cat(1,betas{ci,:,roi})) <= 10 || length(cat(1,betas{ci,:,ri})) <= 10
                ccCs(ci,ri,si) = NaN;
            else
                temp = corrcoef(cat(1,betas{ci,:,roi}),cat(1,betas{ci,:,ri}));
                ccCs(ci,ri,si) = temp(1,2);
            end
            
            if length(cat(1,betac{ci,:,roi})) <= 10 || length(cat(1,betac{ci,:,ri})) <= 10
                ccCc(ci,ri,si) = NaN;
            else
                temp = corrcoef(cat(1,betac{ci,:,roi}),cat(1,betac{ci,:,ri}));
                ccCc(ci,ri,si) = temp(1,2);
            end
            
            if length(cat(1,betai{ci,:,roi})) <= 10 || length(cat(1,betai{ci,:,ri})) <= 10
                ccCi(ci,ri,si) = NaN;
            else
                temp = corrcoef(cat(1,betai{ci,:,roi}),cat(1,betai{ci,:,ri}));
                ccCi(ci,ri,si) = temp(1,2);
            end
        end
    end
end

save([main_dir 'All/SingleTrial/' CorrMat_prefix],'ccs','ccc','cci','ccCs','ccCc','ccCi','ccDs','ccDc','ccDi');
