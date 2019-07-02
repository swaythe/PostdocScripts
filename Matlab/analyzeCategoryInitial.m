cd('/home/sshankar/Categorization/Data/Behavior/Training/cohAll')
fig = 1;

% For oblique boundaries
bounds = 45:90:360;
resp1 = [111, 107, 108, 112];
resp2 = [108, 112, 111, 107];

% For horiz and vert boundaries
% bounds = 0:90:270;
% resp1 = [53, 49, 50, 51];
% resp2 = [50, 51, 53, 49]; 

% dirs = [0, 3, 6, 9, 12, 15, 18, 21, 24];
dirs = [0, 10, 45, 80, 90, 100, 135, 170, 180];
% cohs = 100;
cohs = [0, 3.2, 9, 25.6, 100];

d = dir('SS*_cohAll_*.mat');

dir1 = dirs;
dir2 = dirs*-1;
ct1 = zeros(length(cohs),length(dirs));
ct2 = zeros(length(cohs),length(dirs));
it1 = zeros(length(cohs),length(dirs));
it2 = zeros(length(cohs),length(dirs));
rts = cell(length(dirs),1);

for di = 1:length(d)
   load (d(di).name);
%    load('SS24_cohAll_b45_225')
   sessBound = unique(trialTab(:,3));
   idx1s = cell(length(sessBound),1);
   idx2s = cell(length(sessBound),1);
   for bi = 1:length(sessBound)
       % Find out the index of the boundary in bounds to figure out correct
       % response from resp1 & resp2
       bIdx = find(sessBound(bi)==bounds);
       % Find trials with directions in the positive side of boundary
       idx1s{bi} = find(trialTab(:,3)==sessBound(bi) & trialTab(:,5)==1); 
       % Find trials with directions in the negative side of boundary
       idx2s{bi} = find(trialTab(:,3)==sessBound(bi) & trialTab(:,5)==-1);
       for cohi = 1:length(cohs)
           for diri = 1:length(dirs)
               ct1(cohi, diri) = ct1(cohi, diri) + length(find(trialTab(idx1s{bi},7)==cohs(cohi) & trialTab(idx1s{bi},4)==dirs(diri) & trialTab(idx1s{bi},10)==resp1(bIdx)));
               ct2(cohi, diri) = ct2(cohi, diri) + length(find(trialTab(idx2s{bi},7)==cohs(cohi) & trialTab(idx2s{bi},4)==dirs(diri) & trialTab(idx2s{bi},10)==resp2(bIdx)));
               it1(cohi, diri) = it1(cohi, diri) + length(find(trialTab(idx1s{bi},7)==cohs(cohi) & trialTab(idx1s{bi},4)==dirs(diri) & trialTab(idx1s{bi},10)==resp2(bIdx)));
               it2(cohi, diri) = it2(cohi, diri) + length(find(trialTab(idx2s{bi},7)==cohs(cohi) & trialTab(idx2s{bi},4)==dirs(diri) & trialTab(idx2s{bi},10)==resp1(bIdx)));
    %            rts{diri} = [rts{diri}; trialTab(idx1s{bi},11); trialTab(idx2s{bi},11)];
           end
       end
   end
end
% 
% ct = ct1+ct2;
% it = it1+it2;
% pc = ct./(ct+it);
% ct_cond = zeros(5,5);
% ct_cond(:,1) = ct(:,1)+ct(:,9);
% ct_cond(:,2) = ct(:,2)+ct(:,8);
% ct_cond(:,3) = ct(:,3)+ct(:,7);
% ct_cond(:,4) = ct(:,4)+ct(:,6);
% ct_cond(:,5) = ct(:,5);
% it_cond = zeros(5,5);
% it_cond(:,1) = it(:,1)+it(:,9);
% it_cond(:,2) = it(:,2)+it(:,8);
% it_cond(:,3) = it(:,3)+it(:,7);
% it_cond(:,4) = it(:,4)+it(:,6);
% it_cond(:,5) = it(:,5);
% pc_cond_dir = ct_cond./(ct_cond+it_cond);
% pc_cond_coh = ct_cond'./(ct_cond'+it_cond');
% 
% % Figure
% if fig == 1
%     % Plot accuracy for each coherence as a function of distance from
%     % boundary
%     figure 
%     hold on
%     plot(pc_cond_dir(1,:), 'ro-')
%     plot(pc_cond_dir(2,:), 'go-')
%     plot(pc_cond_dir(3,:), 'bo-')
%     plot(pc_cond_dir(4,:), 'co-')
%     plot(pc_cond_dir(5,:), 'mo-')
%     
%     % Plot accuracy for each distance from boundary as a function of
%     % coherence
%     figure 
%     hold on
%     plot(pc_cond_coh(1,:), 'ro-')
%     plot(pc_cond_coh(2,:), 'go-')
%     plot(pc_cond_coh(3,:), 'bo-')
%     plot(pc_cond_coh(4,:), 'co-')
%     plot(pc_cond_coh(5,:), 'mo-')
% end

%% Accuracy stuff
ct = ct1+ct2;
it = it1+it2;
pc = ct./(ct+it);
ct_cond = zeros(5,5);
ct_cond(:,1) = ct(:,1)+ct(:,9);
ct_cond(:,2) = ct(:,2)+ct(:,8);
ct_cond(:,3) = ct(:,3)+ct(:,7);
ct_cond(:,4) = ct(:,4)+ct(:,6);
ct_cond(:,5) = ct(:,5);
it_cond = zeros(5,5);
it_cond(:,1) = it(:,1)+it(:,9);
it_cond(:,2) = it(:,2)+it(:,8);
it_cond(:,3) = it(:,3)+it(:,7);
it_cond(:,4) = it(:,4)+it(:,6);
it_cond(:,5) = it(:,5);
pc_cond = ct_cond./(ct_cond+it_cond);

%% Figure stuff

if fig == 1
    % Plot accuracy for each coherence as a function of distance from
    % boundary
    a = figure;
    hold on
    plot(pc_cond(1,:), 'ro-')
    plot(pc_cond(2,:), 'go-')
    plot(pc_cond(3,:), 'bo-')
    plot(pc_cond(4,:), 'co-')
    plot(pc_cond(5,:), 'mo-')
    xlabel('Distance from boundary (deg)')
    ylabel('Fraction correct')
%     set(a, 'XtickLabel', xdTickLab) %'Xtick', xdTick, 
    
    % Plot accuracy for each distance from boundary as a function of
    % coherence
    figure 
    hold on
    plot(pc_cond(:,1), 'ro-')
    plot(pc_cond(:,2), 'go-')
    plot(pc_cond(:,3), 'bo-')
    plot(pc_cond(:,4), 'co-')
    plot(pc_cond(:,5), 'mo-')
    xlabel('Coherence (%)')
    ylabel('Fraction correct')
end
