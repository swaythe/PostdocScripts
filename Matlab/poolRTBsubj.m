main_dir = '/home/sshankar/Categorization/Data/Imaging/All/SingleTrial/';
beta_prefix = 'RTBetaParam';
cd(main_dir)
load(beta_prefix)

% Variables of interest:
% RTBSlopeC, RTBSlopeD, RTBIntC, RTBIntD
% RTcBSlopeC, RTcBSlopeD, RTcBIntC, RTcBIntD
% RTiBSlopeC, RTiBSlopeD, RTiBIntC, RTiBIntD

nCoh = size(RTBSlopeC,1);
nDist = size(RTBSlopeD,1);
nROI = size(RTBSlopeC,2);

SlopeCsl = zeros(1,nROI);
SlopeDsl = zeros(1,nROI);
IntCsl = zeros(1,nROI);
IntDsl = zeros(1,nROI);
mSlopeC = zeros(nCoh,nROI);
mSlopeD = zeros(nDist,nROI);
mIntC = zeros(nCoh,nROI);
mIntD = zeros(nDist,nROI);

cSlopeCsl = zeros(1,nROI);
cSlopeDsl = zeros(1,nROI);
cIntCsl = zeros(1,nROI);
cIntDsl = zeros(1,nROI);
cmSlopeC = zeros(nCoh,nROI);
cmSlopeD = zeros(nDist,nROI);
cmIntC = zeros(nCoh,nROI);
cmIntD = zeros(nDist,nROI);

iSlopeCsl = zeros(1,nROI);
iSlopeDsl = zeros(1,nROI);
iIntCsl = zeros(1,nROI);
iIntDsl = zeros(1,nROI);
imSlopeC = zeros(nCoh,nROI);
imSlopeD = zeros(nDist,nROI);
imIntC = zeros(nCoh,nROI);
imIntD = zeros(nDist,nROI);

for ri = 1:nROI
    tmp = squeeze(RTBSlopeC(:,ri,:));
    rf = robustfit((1:nCoh)',mean(tmp,2));
    SlopeCsl(ri) = rf(2);
    mSlopeC(:,ri) = mean(tmp,2);
    tmp = squeeze(RTBSlopeD(:,ri,:));
    rf = robustfit((1:nDist)',mean(tmp,2));
    SlopeDsl(ri) = rf(2);
    mSlopeD(:,ri) = mean(tmp,2);
    tmp = squeeze(RTBIntC(:,ri,:));
    rf = robustfit((1:nCoh)',mean(tmp,2));
    IntCsl(ri) = rf(2);
    mIntC(:,ri) = mean(tmp,2);
    tmp = squeeze(RTBIntD(:,ri,:));
    rf = robustfit((1:nDist)',mean(tmp,2));
    IntDsl(ri) = rf(2);
    mIntD(:,ri) = mean(tmp,2);
    
    tmp = squeeze(RTcBSlopeC(:,ri,:));
    rf = robustfit((1:nCoh)',mean(tmp,2));
    cSlopeCsl(ri) = rf(2);
    cmSlopeC(:,ri) = mean(tmp,2);
    tmp = squeeze(RTcBSlopeD(:,ri,:));
    rf = robustfit((1:nDist)',mean(tmp,2));
    cSlopeDsl(ri) = rf(2);
    cmSlopeD(:,ri) = mean(tmp,2);
    tmp = squeeze(RTcBIntC(:,ri,:));
    rf = robustfit((1:nCoh)',mean(tmp,2));
    cIntCsl(ri) = rf(2);
    cmIntC(:,ri) = mean(tmp,2);
    tmp = squeeze(RTcBIntD(:,ri,:));
    rf = robustfit((1:nDist)',mean(tmp,2));
    cIntDsl(ri) = rf(2);
    cmIntD(:,ri) = mean(tmp,2);
    
    tmp = squeeze(RTiBSlopeC(:,ri,:));
    rf = robustfit((1:nCoh)',mean(tmp,2));
    iSlopeCsl(ri) = rf(2);
    imSlopeC(:,ri) = mean(tmp,2);
    tmp = squeeze(RTiBSlopeD(:,ri,:));
    rf = robustfit((1:nDist)',mean(tmp,2));
    iSlopeDsl(ri) = rf(2);
    imSlopeD(:,ri) = mean(tmp,2);
    tmp = squeeze(RTiBIntC(:,ri,:));
    rf = robustfit((1:nCoh)',mean(tmp,2));
    iIntCsl(ri) = rf(2);
    imIntC(:,ri) = mean(tmp,2);
    tmp = squeeze(RTiBIntD(:,ri,:));
    rf = robustfit((1:nDist)',mean(tmp,2));
    iIntDsl(ri) = rf(2);
    imIntD(:,ri) = mean(tmp,2);
end

save([main_dir 'RTBmetaParam'],'SlopeCsl','SlopeDsl','IntCsl','IntDsl','mSlopeC','mSlopeD','mIntC','mIntD');
save([main_dir 'RTcBmetaParam'],'cSlopeCsl','cSlopeDsl','cIntCsl','cIntDsl','cmSlopeC','cmSlopeD','cmIntC','cmIntD');
save([main_dir 'RTiBmetaParam'],'iSlopeCsl','iSlopeDsl','iIntCsl','iIntDsl','imSlopeC','imSlopeD','imIntC','imIntD');
