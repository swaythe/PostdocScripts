% subs = {'Sub11'};
% baseSess = 1;
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
nSub = length(subs);

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
bdir_prefix = 'SingleTrial';
roi_common = '';
beta_prefix = ['betaMat' roi_common];
op_prefix = ['CorrZval' roi_common];
nTP = 201; % # time points in a timecourse

for si = 1:nSub
    sub = subs{si};
    beta_dir = [main_dir  sub '/Session_' int2str(baseSess(si)) '/' bdir_prefix '/'];
    cd(beta_dir)
    load([sub '_' beta_prefix])
    
    if si == 1
        nCoh = size(betas,1);
        nDir = size(betas,2);
        nROI = size(betas,3);
        ccAll = zeros(nROI,nROI,nSub);
        cvAll = zeros(nROI,nROI,nSub);
    end
    
    csCD = zeros(nCoh,nDir,nROI,nROI);
    ccCD = zeros(nCoh,nDir,nROI,nROI);
    ciCD = zeros(nCoh,nDir,nROI,nROI);
    zsCD = zeros(nCoh,nDir,nROI,nROI);
    zcCD = zeros(nCoh,nDir,nROI,nROI);
    ziCD = zeros(nCoh,nDir,nROI,nROI);
    for ci = 1:nCoh
        for di = 1:nDir
            temps = zeros(length(betas{ci,di,1}),nROI);
            tempc = zeros(length(betac{ci,di,1}),nROI);
            tempi = zeros(length(betai{ci,di,1}),nROI);
            for ri = 1:nROI
                temps(:,ri) = betas{ci,di,ri};
                tempc(:,ri) = betac{ci,di,ri};
                tempi(:,ri) = betai{ci,di,ri};
            end
            csCD(ci,di,:,:) = corrcoef(temps);
            ccCD(ci,di,:,:) = corrcoef(tempc);
            ciCD(ci,di,:,:) = corrcoef(tempi);
%             zsCD(ci,di,:,:) = min((0.5*log((1+csCond(ci,di,:,:))./(max(1-csCond(ci,di,:,:),0.00001)))).*sqrt(length(betas{ci,di,1})-3),15);
%             zcCD(ci,di,:,:) = min((0.5*log((1+ccCond(ci,di,:,:))./(max(1-ccCond(ci,di,:,:),0.00001)))).*sqrt(length(betac{ci,di,1})-3),15);
%             ziCD(ci,di,:,:) = min((0.5*log((1+ciCond(ci,di,:,:))./(max(1-ciCond(ci,di,:,:),0.00001)))).*sqrt(length(betai{ci,di,1})-3),15);
            zsCD(ci,di,:,:) = 0.5*log((1+csCD(ci,di,:,:))./(max(1-csCD(ci,di,:,:),0.00001)));
            zcCD(ci,di,:,:) = 0.5*log((1+ccCD(ci,di,:,:))./(max(1-ccCD(ci,di,:,:),0.00001)));
            ziCD(ci,di,:,:) = 0.5*log((1+ciCD(ci,di,:,:))./(max(1-ciCD(ci,di,:,:),0.00001)));
        end
    end
    
    csC = zeros(nCoh,1,nROI,nROI);
    ccC = zeros(nCoh,1,nROI,nROI);
    ciC = zeros(nCoh,1,nROI,nROI);
    zsC = zeros(nCoh,1,nROI,nROI);
    zcC = zeros(nCoh,1,nROI,nROI);
    ziC = zeros(nCoh,1,nROI,nROI);
    for ci = 1:nCoh
        temps = zeros(length(betaCs{ci,1}),nROI);
        tempc = zeros(length(betaCc{ci,1}),nROI);
        tempi = zeros(length(betaCi{ci,1}),nROI);
        for ri = 1:nROI
            temps(:,ri) = betaCs{ci,ri};
            tempc(:,ri) = betaCc{ci,ri};
            tempi(:,ri) = betaCi{ci,ri};
        end
        csC(ci,1,:,:) = corrcoef(temps);
        ccC(ci,1,:,:) = corrcoef(tempc);
        ciC(ci,1,:,:) = corrcoef(tempi);
        zsC(ci,1,:,:) = 0.5*log((1+csC(ci,1,:,:))./(max(1-csC(ci,1,:,:),0.00001)));
        zcC(ci,1,:,:) = 0.5*log((1+ccC(ci,1,:,:))./(max(1-ccC(ci,1,:,:),0.00001)));
        ziC(ci,1,:,:) = 0.5*log((1+ciC(ci,1,:,:))./(max(1-ciC(ci,1,:,:),0.00001)));
    end
    
    csD = zeros(nDir,1,nROI,nROI);
    ccD = zeros(nDir,1,nROI,nROI);
    ciD = zeros(nDir,1,nROI,nROI);
    zsD = zeros(nDir,1,nROI,nROI);
    zcD = zeros(nDir,1,nROI,nROI);
    ziD = zeros(nDir,1,nROI,nROI);
    for di = 1:nDir
        temps = zeros(length(betaDs{di,1}),nROI);
        tempc = zeros(length(betaDc{di,1}),nROI);
        tempi = zeros(length(betaDi{di,1}),nROI);
        for ri = 1:nROI
            temps(:,ri) = betaDs{di,ri};
            tempc(:,ri) = betaDc{di,ri};
            tempi(:,ri) = betaDi{di,ri};
        end
        csD(di,1,:,:) = corrcoef(temps);
        ccD(di,1,:,:) = corrcoef(tempc);
        ciD(di,1,:,:) = corrcoef(tempi);
        zsD(di,1,:,:) = 0.5*log((1+csD(di,1,:,:))./(max(1-csD(di,1,:,:),0.00001)));
        zcD(di,1,:,:) = 0.5*log((1+ccD(di,1,:,:))./(max(1-ccD(di,1,:,:),0.00001)));
        ziD(di,1,:,:) = 0.5*log((1+ciD(di,1,:,:))./(max(1-ciD(di,1,:,:),0.00001)));
    end
    
    save([sub '_' op_prefix], 'csCD', 'ccCD', 'ciCD', 'zsCD', 'zcCD', 'ziCD','csC', 'ccC', 'ciC', 'zsC', 'zcC', 'ziC','csD', 'ccD', 'ciD', 'zsD', 'zcD', 'ziD');
end
