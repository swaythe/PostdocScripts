cd('/Users/kayserlab/Documents/DotsSS/Scripts/Categorization/Data/cohAll')
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
dirFull = [0, 35, 45, 55, 90, 125, 135, 145, 180, 215, 225, 235, 270, 305, 315, 325, 360];
% For 45/225 boundary
respFull = [108, 108, 108, 111, 111, 111, 111, 111, 111, 111, 111, 108, 108, 108, 108, 108, 180];
% For 135/315 boundary
% respFull = [112, 112, 112, 112, 112, 112, 112, 107, 107, 107, 107, 107, 107, 107, 107, 112, 112];

d = dir('SS*_cohAll_b45*.mat');

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

% % Alternate analysis method
% corr = zeros(length(di),length(trialTab));
% 
% for di = 1:length(d)
%     load(d(di).name);
%     for diri = 1:length(dirFull)
%         idx = find(trialTab(:,6) == dirFull(diri));
%         corr(di,idx) = trialTab(idx,10) == respFull(diri);
%     end
% end


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
pc_cond_dir = ct_cond./(ct_cond+it_cond);
pc_cond_coh = ct_cond'./(ct_cond'+it_cond');

% Figure
if fig == 1
    % Plot accuracy for each coherence as a function of distance from
    % boundary
    figure 
    hold on
    plot(pc_cond_dir(1,:), 'ro-')
    plot(pc_cond_dir(2,:), 'go-')
    plot(pc_cond_dir(3,:), 'bo-')
    plot(pc_cond_dir(4,:), 'co-')
    plot(pc_cond_dir(5,:), 'mo-')
    
    % Plot accuracy for each distance from boundary as a function of
    % coherence
    figure 
    hold on
    plot(pc_cond_coh(1,:), 'ro-')
    plot(pc_cond_coh(2,:), 'go-')
    plot(pc_cond_coh(3,:), 'bo-')
    plot(pc_cond_coh(4,:), 'co-')
    plot(pc_cond_coh(5,:), 'mo-')
end
