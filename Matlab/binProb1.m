function [px] = binProb1(n, x, p)

%BINPROB1 Binomial probability test
%
% [px] = binprob1(n, x, p)
%
% px is the probability of observing at least x outcomes with probability p out
% of n trials. If these are coin tosses,
%
% binprob(5, 10, 0.5) 
%
% returns the probability of observing *at least* 5 heads out of 10
% tosses, which is 0.623. 
%
% For n <= 100 the exact probability from the cumulative binomial
% distribution is returned. Otherwise, a Gaussian approximation is
% used in which mean = n*p, var = n*p*(1-p), and 
%
% P(x0 >= x) = 0.5*erfc( (x - mean)/(sqrt(2)*sd) )
%
% See also: BINPROB.

% Emilio Salinas, February 2009

    
 % binomial calculation
 
 if n <= 100
     f1 = n:-1:n-x+1;
     f2 = 1:x;
     combinations = prod(f1)/prod(f2);
     if isinf(combinations)
         combinations = exp( sum(log(f1) - log(f2)) );
      end
     px1 = (p^x)*((1-p)^(n-x));
     if px1 == 0
         px = 0;
     else
         px = combinations*(p^x)*((1-p)^(n-x));
     end
 
     for x1=x+1:n
         combinations = combinations*(n-x1+1)/x1;
         px1 = combinations*(p^x1)*((1-p)^(n-x1));
         if isnan(px1) == 0
             px = px + px1;
         end
     end
 % Gaussian approximation
 else
     m = n*p;
     sd = sqrt(2)*sqrt(n*p*(1-p));
%      if x > m
         px = 0.5*erfc((x - 0.5 - m)/sd);
%      else
%          px = 0.5*erfc((x + 0.5 - m)/sd);
%      end
 end


