main_dir = '/home/sshankar/Categorization/Data/Behavior/Scanner/'; 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};

cohmax = 4;
dirmax = 5;
subnos = 1:8;
ctr = 1;

hs = zeros(cohmax,dirmax,length(subnos));
ks = zeros(cohmax,dirmax,length(subnos));
xmin = 999;
xmax = 0;

for si = 1:length(subnos)
    load([main_dir subs{si} '/' subs{si} '_behavData'])
    for ci = 1:cohmax
        for di = 1:dirmax
            % This part catculates the number of bins to use in the
            % histogram. Using the Freedman-Diaconis rule which says:
            % h = 2*IQR(x)/(n^(1/3)), where
            % IQR = inter-quartile range
            % x = RT values
            % n = number of observations
            % h = bin size
            % # bins = k = ceil((max(x) - min(x)) / h)
            rts = rts_cond{ci,di};
%             rts = rts-mean(rts);
            hs(ci,di,si) = 2*iqr(rts)/(length(rts)^(1/3));
            ks(ci,di,si) = ceil((max(rts)-min(rts))/hs(ci,di,si));
            if min(rts)<xmin; xmin = min(rts); end
            if max(rts)>xmax; xmax = max(rts); end
        end
    end
end

figure
hold on
cs = 'rgbk';
for si = 1:length(subnos)
    load([main_dir subs{si} '/' subs{si} '_behavData'])
    ctr = 1;
    for ci = 1:cohmax
        for di = 1:dirmax
            sp = subplot(4,5,ctr);
%             figure(ctr)
            hold on
            rts = rts_cond{ci,di};
%             rts = rts-mean(rts);
            [n bin] = hist(rts, ks(ci,di,si));
            plot(bin, n./max(n), cs(mod(si,4)+1))
            axis([xmin xmax 0 1]);
            ctr = ctr + 1;
            if ci==1 && di==3
%                 title(subs{si});
            elseif ci==4 && di==3
                xlabel('RT (s)');
            end
        end
    end
end
