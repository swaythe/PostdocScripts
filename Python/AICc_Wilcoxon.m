% AICcs with all data
% AICc interaction: 
AICc_interact = [ 259.46  232.84  224.4   192.    192.58  184.76  192.44  200.    199.46];
% AICc coherence: 
AICc_coh = [ 205.131  162.591  170.631  211.271  248.271  178.591  150.791  151.571 183.911];
% AICc distance: 
AICc_dist = [ 133.991  113.971  142.251  126.571  133.151  153.771  128.611  143.891 175.471];

% Calculate Wilcoxon statistics
p_aicc = signrank(AICc_interact, AICc_coh, 'tail', 'right');
p_tt_aicc = signrank(AICc_interact, AICc_coh);


% AICcs without the D0Call and C0Dall conditions
% AICc interaction: 
AICc_interact_noD0CallandC0Dall = [ 159.134  148.014  130.954  125.514  116.834  128.114  120.254  124.414 132.394];
% AICc coherence: 
AICc_coh_noD0CallandC0Dall = [ 149.874  134.314  125.134  170.114  224.434  143.694  112.774  121.834 147.314];
% AICc distance: 
AICc_dist_noD0CallandC0Dall = [  96.027   82.767   84.987   75.447   77.307   94.527   74.147   88.407 124.567];

% Calculate Wilcoxon statistics
p_aicc_noD0CallandC0Dall = signrank(AICc_interact_noD0CallandC0Dall, AICc_coh_noD0CallandC0Dall, 'tail', 'right');
p_tt_aicc_noD0CallandC0Dall = signrank(AICc_interact_noD0CallandC0Dall, AICc_coh_noD0CallandC0Dall);

% AICcs without the D90Call and D(90-ID)Call conditions
% AICc interaction: 
AICc_interact_no90andID = [ 193.734  184.874  162.894  162.814  155.794  154.034  141.134  167.054 168.954];
% AICc coherence: 
AICc_coh_no90andID = [ 151.887  133.567  136.347  125.347  117.367  122.847  119.587  129.687 123.527];
% AICc distance: 
AICc_dist_no90andID = [ 165.074  149.434  157.534  151.794  153.614  163.254  153.834  163.314 159.814];

% Calculate Wilcoxon statistics
p_aicc_no90andID = signrank(AICc_interact_no90andID, AICc_coh_no90andID, 'tail', 'right');
p_tt_aicc_no90andID = signrank(AICc_interact_no90andID, AICc_coh_no90andID);

% AICcs without the D90Call condition
% AICc interaction: 
AICc_interact_no90 = [ 224.804  203.264  183.824  166.964  161.664  158.964  155.544  174.244 172.484];
% AICc coherence: 
AICc_coh_no90 = [ 185.874  149.314  153.454  146.074  139.274  147.514  131.734  146.394 150.874];
% AICc distance: 
AICc_dist_no90 = [ 136.714  123.694  142.354  134.894  139.654  159.314  128.314  150.214 173.694];

% Calculate Wilcoxon statistics
p_aicc_no90 = signrank(AICc_interact_no90, AICc_coh_no90, 'tail', 'right');
p_tt_aicc_no90 = signrank(AICc_interact_no90, AICc_coh_no90);

% AICcs without the D(90-ID)Call condition
% AICc interaction: 
AICc_interact_noID = [ 223.784  204.504  182.204  173.664  172.084  167.504  172.044  168.784 170.644];
% AICc coherence: 
AICc_coh_noID = [ 187.694  154.914  157.074  172.894  202.354  150.194  136.534  140.434 184.274];
% AICc distance: 
AICc_dist_noID = [ 137.394  130.274  144.914  124.614  129.734  153.014  136.314  145.194 171.534];

% Calculate Wilcoxon statistics
p_aicc_noID = signrank(AICc_interact_noID, AICc_coh_noID, 'tail', 'right');
p_tt_aicc_noID = signrank(AICc_interact_noID, AICc_coh_noID);
