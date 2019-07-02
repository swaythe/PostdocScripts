ci = 12;

if ci > 1
    subplot(1,2,1); hold on
    plot(ntcAvg(ci-1,1:163,9),'k')
    subplot(1,2,2); hold on
    plot(d,'k')
end

subplot(1,2,1); hold on
plot(ntcAvg(ci,1:163,9),'r')

a = squeeze(tc9_2(ci,:,:));
b = squeeze(max(tc9_2(ci,:,:)));
c = zeros(size(a));
for i=1:16
    c(:,i) = a(:,i)/b(i);
end
d = nanmean(c,2);

subplot(1,2,2); hold on
plot(d,'r')