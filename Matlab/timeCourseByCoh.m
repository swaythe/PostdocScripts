sub = 'Sub01';
cd(['/home/sshankar/Categorization/Data/Imaging/' sub])

load([sub '_timecourse_raw.mat'])

% % Calculate per coherence
% cohRows = [9 13 17 41 45 49;10 14 18 42 46 50;11 15 19 43 47 51;12 16 20 44 48 52];
% nRun = 24;
% ntc = zeros(nRun*6,10,4,size(coords,1));
% 
% for ci=1:4 % Coherence
%     nCtr = 1;
%     for ri=1:nRun 
%         for di = 1:6 % Directions per coherence
%             for cdi = 1:size(coords,1) % Coordinates
%                 ntc(nCtr,:,ci,cdi) = timecourse(cohRows(ci,di),:,ri,cdi)/max(timecourse(cohRows(ci,di),:,ri,cdi));
%             end
%             nCtr = nCtr + 1;
%         end
%     end
% end
% 
% nm1 = mean(ntc,4);
% nm2 = mean(nm1);
% nm2 = squeeze(nm2);
% 
% figure
% hold on
% 
% plot(nm2(:,1), 'r')
% plot(nm2(:,2), 'g')
% plot(nm2(:,3), 'b')
% plot(nm2(:,4), 'k')

% Calculate per distance from boundary
dirRows = {{32 64} {4 28 36 60} {8 24 40 56} {12 20 44 52} {16 48}}; 
nRun = 24;
ntc = zeros(nRun*6,10,5,size(coords,1));
ntc(:,:,:,:) = NaN;

for di=1:5 % Distance from boundary
    nCtr = 1;
    for ri=1:nRun 
        for ci = 1:length(dirRows{di}) % High coherence only
            for cdi = 1:size(coords,1) % Coordinates
                ntc(nCtr,:,di,cdi) = timecourse(dirRows{di}{ci},:,ri,cdi)/max(timecourse(dirRows{di}{ci},:,ri,cdi));
            end
            nCtr = nCtr + 1;
        end
    end
end

nm1 = nanmean(ntc,4);
nm2 = nanmean(nm1);
nm2 = squeeze(nm2);

figure
hold on

plot(nm2(:,1), 'r')
plot(nm2(:,2), 'g')
plot(nm2(:,3), 'b')
plot(nm2(:,4), 'm')
plot(nm2(:,5), 'k')
