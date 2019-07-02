% Log likelihoods with all data
ll_interact = [-66.73, -53.42, -49.2, -33., -33.29, -29.38, -33.22, -37., -36.73];
ll_coh = [-61.46, -40.19, -44.21, -64.53, -83.03, -48.19, -34.29, -34.68, -50.85];
ll_dist = [-33.71, -23.7, -37.84, -30., -33.29, -43.6, -31.02, -38.66, -54.45];

% Calculate Wilcoxon statistics
p_ll = signrank(ll_coh, ll_dist, 'tail', 'left');
p_tt_ll = signrank(ll_coh, ll_dist);

% Log likelihoods without the D0Call and C0Dall conditions
ll_interact_noD0CallandC0Dall = [-25.71, -20.15, -11.62, -8.9, -4.56, -10.2, -6.27, -8.35, -12.34];
ll_coh_noD0CallandC0Dall = [-21.08, -13.3,   -8.71, -31.2,  -58.36, -17.99,  -2.53,  -7.06, -19.8 ];
ll_dist_noD0CallandC0Dall = [-11.68,  -5.05,  -6.16,  -1.39,  -2.32, -10.93,  -0.74,  -7.87, -25.95];

% Calculate Wilcoxon statistics
p_ll_noD0CallandC0Dall = signrank(ll_coh_noD0CallandC0Dall, ll_dist_noD0CallandC0Dall, 'tail', 'left');
p_tt_ll_noD0CallandC0Dall = signrank(ll_coh_noD0CallandC0Dall, ll_dist_noD0CallandC0Dall);

% Log likelihoods without the D90Call and D(90-ID)Call conditions
ll_interact_no90andID = [-43.01, -38.58, -27.59, -27.55, -24.04, -23.16, -16.71, -29.67, -30.62];
ll_coh_no90andID = [-39.61, -30.45, -31.84, -26.34, -22.35, -25.09, -23.46, -28.51, -25.43];
ll_dist_no90andID = [-28.68, -20.86, -24.91, -22.04, -22.95, -27.77, -23.06, -27.8,  -26.05];

% Calculate Wilcoxon statistics
p_ll_no90andID = signrank(ll_coh_no90andID, ll_dist_no90andID, 'tail', 'left');
p_tt_ll_no90andID = signrank(ll_coh_no90andID, ll_dist_no90andID);

% Log likelihoods without the D90Call conditions
ll_interact_no90 = [-55.22, -44.45, -34.73, -26.3 , -23.65, -22.3 , -20.59, -29.94, -29.06];
ll_coh_no90 = [-55.08, -36.8,  -38.87, -35.18, -31.78, -35.9,  -28.01, -35.34, -37.58];
ll_dist_no90 = [-30.5,  -23.99, -33.32, -29.59, -31.97, -41.8,  -26.3,  -37.25, -48.99];

% Calculate Wilcoxon statistics
p_ll_no90 = signrank(ll_coh_no90, ll_dist_no90, 'tail', 'left');
p_tt_ll_no90 = signrank(ll_coh_no90, ll_dist_no90);

% Log likelihoods without the D(90-ID)Call conditions
ll_interact_noID = [-54.71, -45.07, -33.92, -29.65, -28.86, -26.57, -28.84, -27.21, -28.14];
ll_coh_noID = [-55.99, -39.6,  -40.68, -48.59, -63.32, -37.24, -30.41, -32.36, -54.28];
ll_dist_noID = [-30.84, -27.28, -34.6,  -24.45, -27.01, -38.65, -30.3,  -34.74, -47.91];

% Calculate Wilcoxon statistics
p_ll_noID = signrank(ll_coh_noID, ll_dist_noID, 'tail', 'left');
p_tt_ll_noID = signrank(ll_coh_noID, ll_dist_noID);
