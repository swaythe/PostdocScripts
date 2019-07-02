% multcompare results summary:
% The first two columns of c show the groups that are compared. 
% The fourth column shows the difference between the estimated group means. 
% The third and fifth columns show the lower and upper limits for 95% confidence intervals for the true mean difference. 
% The sixth column contains the p-value for a hypothesis test that the corresponding mean difference is equal to zero. 

% AICs with all data
% AIC interaction: 
AIC_interact = [ 179.46  152.84  144.4   112.    112.58  104.76  112.44  120.    119.46];
% AIC coherence: 
AIC_coh = [ 160.92  118.38  126.42  167.06  204.06  134.38  106.58  107.36  139.7 ];
% AIC distance: 
AIC_dist = [ 101.42   81.4   109.68   94.    100.58  121.2    96.04  111.32  142.9 ];

% Calculate Wilcoxon statistics
p_aic = signrank(AIC_coh, AIC_dist, 'tail', 'right');
p_tt_aic = signrank(AIC_coh, AIC_dist);

% AICs without the D0Call and C0Dall conditions
% AIC interaction: 
AIC_interact_noD0CallandC0Dall = [ 81.42  70.3   53.24  47.8   39.12  50.4   42.54  46.7   54.68];
% AIC coherence: 
AIC_coh_noD0CallandC0Dall = [  72.16   56.6    47.42   92.4   146.72   65.98   35.06   44.12   69.6 ];
% AIC distance: 
AIC_dist_noD0CallandC0Dall = [ 49.36  36.1   38.32  28.78  30.64  47.86  27.48  41.74  77.9 ];

% Calculate Wilcoxon statistics
p_aic_noD0CallandC0Dall = signrank(AIC_coh_noD0CallandC0Dall, AIC_dist_noD0CallandC0Dall, 'tail', 'right');
p_tt_aic_noD0CallandC0Dall = signrank(AIC_coh_noD0CallandC0Dall, AIC_dist_noD0CallandC0Dall);

% AICs without the D90Call and D(90-ID)Call conditions
% AIC interaction: 
AIC_interact_no90andID = [ 116.02  107.16   85.18   85.1    78.08   76.32   63.42   89.34   91.24];
% AIC coherence: 
AIC_coh_no90andID = [ 105.22   86.9    89.68   78.68   70.7    76.18   72.92   83.02   76.86];
% AIC distance: 
AIC_dist_no90andID = [ 87.36  71.72  79.82  74.08  75.9   85.54  76.12  85.6   82.1 ];

% Calculate Wilcoxon statistics
p_aic_no90andID = signrank(AIC_coh_no90andID, AIC_dist_no90andID, 'tail', 'right');
p_tt_aic_no90andID = signrank(AIC_coh_no90andID, AIC_dist_no90andID);

% AICs without the D90Call condition
% AIC interaction: 
AIC_interact_no90 = [ 148.44  126.9   107.46   90.6    85.3    82.6    79.18   97.88   96.12];
% AIC coherence: 
AIC_coh_no90 = [ 142.16  105.6   109.74  102.36   95.56  103.8    88.02  102.68  107.16];
% AIC distance: 
AIC_dist_no90 = [  93.     79.98   98.64   91.18   95.94  115.6    84.6   106.5   129.98];

% Calculate Wilcoxon statistics
p_aic_no90 = signrank(AIC_coh_no90, AIC_dist_no90, 'tail', 'right');
p_tt_aic_no90 = signrank(AIC_coh_no90, AIC_dist_no90);

% AICs without the D(90-ID)Call condition
% AIC interaction: 
AIC_interact_noID = [ 147.42  128.14  105.84   97.3    95.72   91.14   95.68   92.42   94.28];
% AIC coherence: 
AIC_coh_noID = [ 143.98  111.2   113.36  129.18  158.64  106.48   92.82   96.72  140.56];
% AIC distance: 
AIC_dist_noID = [  93.68   86.56  101.2    80.9    86.02  109.3    92.6   101.48  127.82];

% Calculate Wilcoxon statistics
p_aic_noID = signrank(AIC_coh_noID, AIC_dist_noID, 'tail', 'right');
p_tt_aic_noID = signrank(AIC_coh_noID, AIC_dist_noID);
