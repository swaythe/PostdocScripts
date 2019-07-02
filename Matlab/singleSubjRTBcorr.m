main_dir = '/home/sshankar/Categorization/Data/Imaging/';

cd([main_dir 'All/SingleTrial/'])
load('RTBetaParam')

slopesC = zeros(9,38);
intsC = zeros(9,38);
mSlopesC = zeros(1,38);
mIntsC = zeros(1,38);
slopesD = zeros(9,38);
intsD = zeros(9,38);
mSlopesD = zeros(1,38);
mIntsD = zeros(1,38);

for ri = 1:38
    for si = 1:9
        temp = robustfit((1:4)',RTBSlopeC(:,ri,si));
        slopesC(si,ri) = temp(2);
        temp = robustfit((1:4)',RTBIntC(:,ri,si));
        intsC(si,ri) = temp(2);
        
        temp = robustfit((1:5)',RTBSlopeD(1:5,ri,si));
        slopesD(si,ri) = temp(2);
        temp = robustfit((1:5)',RTBIntD(1:5,ri,si));
        intsD(si,ri) = temp(2);
    end
%     temp = robustfit((1:4)',mean(squeeze(RTBSlopeC(:,ri,:)),2));
%     mSlopesC(ri) = temp(2);
%     temp = robustfit((1:4)',mean(squeeze(RTBIntC(:,ri,:)),2));
%     mIntsC(ri) = temp(2);
%     
%     temp = robustfit((1:5)',mean(squeeze(RTBSlopeD(:,ri,:)),2));
%     mSlopesD(ri) = temp(2);
%     temp = robustfit((1:5)',mean(squeeze(RTBIntD(:,ri,:)),2));
%     mIntsD(ri) = temp(2);
end