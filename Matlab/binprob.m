% This function calculates the probability of getting at least k out of n
% trials correct, when the prior probability is p

% n = # trials
% k = # successes
% p = prior probability of success per trial
% P(X>=k) = sum from k to n(P(X=k)). This probability can be computed from the cdf of a
% binomial distribution if np<10. 
% If np>=10, use the normal approximation to arrive at the probability.
% The formula for the normal approximation is:
% 1-1/2(1+erf((x-np)/sqrt(2*npq))) = 1/2*erfc((x-np)/(sqrt(2*npq))),
% where
% np = expected value of the random variable
% npq = variance of random variable
% erf is the error function, and 
% erfc is the complementary error function = 1-erf

% function bp = binprob(n, k, p)
% bp = 0;
% if n==0
%     bp = 0.5;
% elseif n*p<10
%     for pCt=k:n
%         bp = bp + factorial(n)/(factorial(pCt)*factorial(n-pCt))*p^pCt*(1-p)^(n-pCt);
%     end
% else
%     m = n*p;
%     sd = n*p*(1-p);
%     bp = 0.5*erfc((k+0.5-m)/sqrt(2*sd));
% end
% return 

% To get exact probabilities, use the following
% Inputs are the same as above

function bp = binprob(n, k, p)
% sprintf('%.2f, %.2f', n*p ,n*(1-p))
if n==0
    bp = 0.5;
elseif n*p<=5 && n*(1-p)<=5
    bp = factorial(n)/(factorial(k)*factorial(n-k))*p^k*(1-p)^(n-k);
else
    m = n*p;
    vrnc = n*p*(1-p);
%     bp = (k-0.5-m)/sqrt(2*vrnc);
    zlo = (k-0.5-m)/sqrt(vrnc);
    zhi = (k+0.5-m)/sqrt(vrnc);
    bp = normcdf(zhi,0,1)-normcdf(zlo,0,1);
%     if bp > 1 || bp < 0
%         bp = (k-0.5-m)/sqrt(2*vrnc);
%     end
end
return 