function [outlier_idx] = rosner(input_vec, num_outliers);

% This function takes a vector of input values and determines whether
% significant outliers exist.  If each R_i is less than the corresponding
% lambda_i, then no outliers are present.  The procedure is detailed in
% Rosner, Technometrics, 1983.
%
% Inputs: 1) input_vec: a column vector of inputs
%         2) num_outliers: an upper bound on the number of possible
%                          outliers assessed
%
% Outputs: 1) outlier_idx: the indices of any outlier values
%
% Dependencies: None

alpha = 0.05;
xxx = input_vec;
n = length(xxx);
for l1 = 1:num_outliers
    m = mean(xxx);
    s = std(xxx);
    yyy = xxx - m;
    [dummy, big_idx(l1)] = max(abs(yyy));
    R(l1) = abs(xxx(big_idx(l1)) - m) ./ s;
    
    pcrit = 1 - (alpha/(2*(n-l1-1)));
    tval = tinv(pcrit,n-l1-1);
    lambda(l1) = ((n-l1) * tval) ./ sqrt(((n-l1-1) + (tval^2)) * (n-l1+1));
    xxx = xxx([1:big_idx(l1)-1, big_idx(l1)+1:end]);
end
compareRL = find(R > lambda);
outlier_idx = big_idx(compareRL);

% Previous data:
% icrdiff_s = [
%    -0.0882
%     0.0882
%     0.0616
%          0
%    -0.0882
%    -0.0393
%    -0.2210
%    -0.0362
%     0.0011
%    -0.5922
%     0.1253
%    -0.2244
%    -0.2104
%     0.0524
%     0.9228
%    -0.1533
%    -0.1717
%    -0.1253
%     0.0235
%     0.1001
%    -0.1444
%    -0.0780
%     0.4473
%    -0.0351
%    -0.0733
%     0.1097];