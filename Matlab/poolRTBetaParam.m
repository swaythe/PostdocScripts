subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];

main_dir = '/home/sshankar/Categorization/Data/Imaging/';
op_dir = [main_dir 'All/SingleTrial/'];
op_prefix = 'RTBetaParam';
beta_prefix = 'SingleTrial/';

for si = 1:length(subs)
    sub = subs{si};
    beta_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' beta_prefix];
    
    % Load the beta and RT matrices
    cd(beta_dir)
    load([sub '_RTBetaReg'])
    
    if si == 1
        RTBSlopeCD = zeros([size(RTBetaSlopeCD),length(subs)]);
        RTBIntCD = zeros([size(RTBetaSlopeCD),length(subs)]);
        RTBSlopeC = zeros([size(RTBetaSlopeC),length(subs)]);
        RTBIntC = zeros([size(RTBetaSlopeC),length(subs)]);
        RTBSlopeD = zeros([size(RTBetaSlopeD),length(subs)]);
        RTBIntD = zeros([size(RTBetaSlopeD),length(subs)]);
        RTcBSlopeCD = zeros([size(RTBetaSlopeCD),length(subs)]);
        RTcBIntCD = zeros([size(RTBetaSlopeCD),length(subs)]);
        RTcBSlopeC = zeros([size(RTBetaSlopeC),length(subs)]);
        RTcBIntC = zeros([size(RTBetaSlopeC),length(subs)]);
        RTcBSlopeD = zeros([size(RTBetaSlopeD),length(subs)]);
        RTcBIntD = zeros([size(RTBetaSlopeD),length(subs)]);
        RTiBSlopeCD = zeros([size(RTBetaSlopeCD),length(subs)]);
        RTiBIntCD = zeros([size(RTBetaSlopeCD),length(subs)]);
        RTiBSlopeC = zeros([size(RTBetaSlopeC),length(subs)]);
        RTiBIntC = zeros([size(RTBetaSlopeC),length(subs)]);
        RTiBSlopeD = zeros([size(RTBetaSlopeD),length(subs)]);
        RTiBIntD = zeros([size(RTBetaSlopeD),length(subs)]);        
    end
    RTBSlopeCD(:,:,:,si) = RTBetaSlopeCD;
    RTBIntCD(:,:,:,si) = RTBetaIntCD;
    RTBSlopeC(:,:,si) = RTBetaSlopeC;
    RTBIntC(:,:,si) = RTBetaIntC;
    RTBSlopeD(:,:,si) = RTBetaSlopeD;
    RTBIntD(:,:,si) = RTBetaIntD;
    RTcBSlopeCD(:,:,:,si) = RTcBetaSlopeCD;
    RTcBIntCD(:,:,:,si) = RTcBetaIntCD;
    RTcBSlopeC(:,:,si) = RTcBetaSlopeC;
    RTcBIntC(:,:,si) = RTcBetaIntC;
    RTcBSlopeD(:,:,si) = RTcBetaSlopeD;
    RTcBIntD(:,:,si) = RTcBetaIntD;
    RTiBSlopeCD(:,:,:,si) = RTiBetaSlopeCD;
    RTiBIntCD(:,:,:,si) = RTiBetaIntCD;
    RTiBSlopeC(:,:,si) = RTiBetaSlopeC;
    RTiBIntC(:,:,si) = RTiBetaIntC;
    RTiBSlopeD(:,:,si) = RTiBetaSlopeD;
    RTiBIntD(:,:,si) = RTiBetaIntD;
end

save([op_dir op_prefix], 'RTBSlopeCD','RTBIntCD','RTBSlopeC','RTBIntC','RTBSlopeD','RTBIntD','RTcBSlopeCD','RTcBIntCD','RTcBSlopeC','RTcBIntC','RTcBSlopeD','RTcBIntD','RTiBSlopeCD','RTiBIntCD','RTiBSlopeC','RTiBIntC','RTiBSlopeD','RTiBIntD')