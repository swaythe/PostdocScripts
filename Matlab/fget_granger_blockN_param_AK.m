function [fvec, fnullmat_m] = fget_granger_blockN_param(varargin)

% fget_granger_block:  determine Granger causality for two timeseries,
%       possibly conditional on other so-called confounder-timeseries
%
% [fvec,fnullmat] = get_granger_block (timeseries1, timeseries2, 
%                                nullseries, optional confounder timeseries, 
%                                maxorder, recons, blocklen);
%
% Inputs:   timeseries1 & timeseries2 are each column vectors containing 
%             the timeseries to be analyzed
%           nullseries is a user-defined null (bootstrapped?) timeseries
%             that should be derived from timeseries1.
%           confounder-timeseries is a (null?) matrix of column vectors, each 
%             containing a confounder timeseries to account for
%           maxorder is the maximum order of the multivariate
%             autoregressive model to be tested
%           recons, if set to 1, will attempt to reconstruct the data based
%             on the autoregressive matrics formulated by the routine.
%             This flag will typically be set to zero.
%           blocklen, if present, will lead the function to process each
%             block of length "blocklen" within the timeseries separately.
%
% Outputs:  fvec contains 9 quantities in the following order:
%             1) f12: the simultaneous influence of timeseries 1 & 2 on
%                   each other
%             2) f1on2: the influence of timeseries 1 on timeseries 2
%             3) f2on1: the influence of timeseries 2 on timeseries 1
%             4) f_diff: the difference f1on2 - f2on1
%             5) F1on2: the parametric F-value for f1on2
%             6) p_F1on2: the associated p-value for the parametric F
%             7) F2on1: the parametric F-value for f2on1
%             8) p_F2on1: the associated p-value for the parametric F
%             9) lag: the lag at which Granger values are calculated
%           fnullmat_m contains the same values as fvec, but for the entire
%             bootstrapped null distribution.
%
% Assumptions:  (1) The number of timepoints is equal in each timeseries
%
% Caveats:      (1) THE MEAN OF EACH TIMESERIES IS SUBTRACTED WITHIN THIS
%                     FUNCTION BEFORE CALCULATIONS ARE PERFORMED

format compact;
if nargin <3 || nargin >7
    disp('Incorrect number of input arguments to get_granger.');
    return;
else
    % Set null values
    cs = [];
    alonemax = 1;
    maxorder = 3;
    recons = 0;
    for loop = 1:nargin
        if ~isnumeric(varargin{loop})
            disp(['Improper formatting for input variable #', num2str(loop), '.'])
            return;
        else switch loop
                case 1, hold_ts(:,1) = varargin{1}; blocklen = length(hold_ts);
                case 2, hold_ts(:,2) = varargin{2};
                case 3, ns = varargin{3}; [dur_ns, dim_ns] = size(ns);
                case 4, cs = varargin{4}; if ~isempty(cs), alonemax = 2; end
                case 5, maxorder = varargin{5};
                case 6, recons = varargin{6};
                case 7, blocklen = varargin{7};
            end
        end
    end
    hold_ts = [hold_ts cs];
end

nblock = length(hold_ts(:,1))/blocklen;
if nblock ~= floor(nblock)
    nblock = 1;
end
blen = nblock;                      % bootlength is now nblock, by def'n
[dur, dim] = size(hold_ts);         % dur = total # timepoints; dim = # timeseries,
for l = 1:nblock                    % Subtract block means
    idx = [blocklen*(l-1)+1:blocklen*l]';
    hold_ts(idx,:) = hold_ts(idx,:) - ones(blocklen,1)*mean(hold_ts(idx,:));
    ns(idx,:) = ns(idx,:) - ones(blocklen,1)*mean(ns(idx,:));
end
W = zeros(dim*maxorder, dim, maxorder, nblock*2);
newW = zeros(dim*dim*maxorder, maxorder, nblock*2);
sse = zeros(maxorder, dim-1, 2);
for bstrap = 1:nblock*(dim_ns+1)    % First iterations eval original timeseries
    if bstrap > nblock*dim_ns
        idx = [blocklen*(bstrap-dim_ns*nblock-1)+1:blocklen*(bstrap-dim_ns*nblock)]';
        ts = hold_ts(idx,:);
    else
        ns_idx = ceil(bstrap/nblock);
        idx = [blocklen*(bstrap-nblock*(ns_idx-1)-1)+1:blocklen*(bstrap-nblock*(ns_idx-1))]';
        ts = [ns(idx,ns_idx) hold_ts(idx,2:end)];
    end
    for alone = 1:alonemax              % Get residuals +/- confounding timeseries
        switch alone
            case 1, sdim = 2; ...      % Only evaluate the first 2 timeseries (sdim=2)
                    clear s_ml s_ml2 sc;
            case 2, sdim = dim; ...    % Now evaluate confounders as well (sdim=dim)
                    clear s_ml s_ml2 sc;
        end
        w = zeros((sdim-1)*maxorder, sdim-1, maxorder, 2);  % Initialize wt matrix
        for l0 = 1:2
            switch l0                   % Remove the other timeseries of interest
                case 1, sts = [ts(:,1) ts(:,3:sdim)];       % tseries(:,3:2)=[]
                case 2, sts = ts(:,2:sdim);               %   if sdim = 2.
            end
            for l1 = 1:maxorder
                clear y;
                y = sts((1+l1):blocklen,:);  % The first 'order' timepoints are excluded
                clear x;                     %   because preceding timepoints don't exist
                x = [];
                for l2 = 1:l1                % Populate a matrix of past timepoints
                    x = [x sts((l1-l2+1):(blocklen-l2),:)];
                end
                w(1:((sdim-1)*l1),:,l1,l0) = pinv(x) * y;   % MLE
                clear rsd;              % The residual
                rsd = y - x * squeeze(w(1:((sdim-1)*l1),:,l1,l0));
                s_ml (:,:,l1,l0) = cov(rsd);
                sse (l1,1:sdim-1,l0) = sum(rsd.^2);
                sc (l1,l0) = log(sum(sse(l1,:,l0))) + ...
                    (log((sdim-1)*(blocklen-l1))/((sdim-1)*(blocklen-l1))) * ...
                    l1 * (sdim-1).^2;
            end
        end
        if alone == 1
            s_ml_only = squeeze(s_ml);
            if maxorder == 1            % Squeeze operation will remove a desired dimension
                s_ml_only = s_ml_only';
            end
            sc_only = sc;
            sse_only = sse;
        end
    end
    
    S_ml = zeros(dim, dim, maxorder);
    for l1 = 1:maxorder
        clear Y;
        Y = ts((1+l1):blocklen,:);      % Exclude datapoints < order
        clear X;
        X = [];
        for l2 = 1:l1                   % Populate a matrix of past timepoints
            X = [X ts((l1-l2+1):(blocklen-l2),:)];
        end
        W(1:dim*l1,:,l1,bstrap) = pinv(X) * Y; % MLE
        
        clear Rsd;
        Rsd = Y - X * squeeze(W(1:dim*l1,:,l1,bstrap));
        S_ml (:,:,l1) = cov(Rsd);
        SSE (l1,:) = sum(Rsd.^2);
        SC (l1) = log(sum(SSE(l1,:))) + ...
            (log(dim*(blocklen-l1))/(dim*(blocklen-l1))) * l1 * dim.^2;
    end
    
    % For the optimal order, calculate the Granger indices.  If
    % conditional/confounder times are present, the Granger indices
    % are calculated as follows:
    %   F_12 | 3 = F_123 - F_3*12
    %   F_1on2 | 3 = F_13on2 - F_3on2
    %   F_2on1 | 3 = F_23on1 - F_3on1
    
    optm (bstrap) = find (SC == min(SC));
    if dim == 2
        F_12(bstrap) = log(det(S_ml(1,1,optm (bstrap))) * ...
            det(S_ml(2,2,optm(bstrap))) / det(S_ml(:,:,optm(bstrap))));
        F_1on2(bstrap) = log(det(s_ml_only(optm (bstrap),2)) / ...
            det(S_ml(2,2,optm(bstrap))));
        F_2on1(bstrap) = log(det(s_ml_only(optm (bstrap),1)) / ...
            det(S_ml(1,1,optm(bstrap))));
    else
        f_3on1 = log(det(s_ml_only(optm(bstrap),1)) / ...
            det(s_ml(1,1,optm(bstrap),1)));
        f_3on2 = log(det(s_ml_only(optm(bstrap),2)) / ...
            det(s_ml(1,1,optm(bstrap),2)));
        f_32on1 = log(det(s_ml_only(optm(bstrap),1)) / ...
            det(S_ml(1,1,optm(bstrap))));
        f_31on2 = log(det(s_ml_only(optm(bstrap),2)) / ...
            det(S_ml(2,2,optm(bstrap))));
        F_2on1(bstrap) = f_32on1 - f_3on1;
        F_1on2(bstrap) = f_31on2 - f_3on2;
        f_123 = log(det(S_ml(1,1,optm (bstrap))) * ...
            det(S_ml(2,2,optm(bstrap))) * ...
            det(S_ml(3:dim,3:dim,optm(bstrap))) / det(S_ml(:,:,optm(bstrap))));
        f_3_12 = log(det(S_ml(1:2,1:2,optm (bstrap))) * ...
            det(S_ml(3:dim,3:dim,optm(bstrap))) / det(S_ml(:,:,optm(bstrap))));
        F_12(bstrap) = f_123 - f_3_12;
    end
    for l = 1:2
        S(bstrap,l) = ((sse(optm(bstrap),1,l) - SSE(optm(bstrap),l)) ./ optm(bstrap)) ...
                        ./ (SSE(optm(bstrap),l) ./ (blocklen-2*optm(bstrap)-1));
        p(bstrap,l) = 1 - fcdf(S(bstrap,l), optm(bstrap), blocklen-2*optm(bstrap)-1);
    end
    S(bstrap,:) = [S(bstrap,2) S(bstrap,1)];    % produces [1_on_2, 2_on_1] for F(m,T-2m-1)
    p(bstrap,:) = [p(bstrap,2) p(bstrap,1)];
    
%     if recons == 1 && bstrap > nblock    % > nblock, ass null reconstructions aren't needed
%         needr = 0;                      % Toggles display -> zero = off
%         m_ind = optm(bstrap);
%         w_ind = m_ind * (dim-1);
%         newy = zeros(blocklen-maxorder, dim, 4);              % Because X is of maxorder
%         inds_1 = setdiff([1:m_ind*dim], [2:dim:m_ind*dim]);   % To remove other ts of interest
%         inds_2 = setdiff([1:m_ind*dim], [1:dim:m_ind*dim]);   % To remove other ts of interest
%         newy(:,1:(dim-1),1) = X(:,inds_1) * w(1:w_ind,:,m_ind,1);
%         newy(:,2:dim,2) = X(:,inds_2) * w(1:w_ind,:,m_ind,2);
%         newy(:,:,3) = X(:,1:(m_ind*dim)) * W(1:(m_ind*dim),:,m_ind,bstrap);
%         newy(:,:,4) = newy(:,:,3);
%         if needr == 1
%             if nblock < 4
%                 spa = nblock;
%                 spb = 4;
%             else
%                 spa = 4;
%                 spb = nblock;
%             end
%             for loop = 1:4
%                 t_ind = 2 - rem(loop,2);
%                 if loop <= 2
%                     addstr = [];
%                 else
%                     addstr = ', inclusive';
%                 end
%                 figure(loop);
%                 subplot(spa,spb,bstrap-nblock), plot(ts(maxorder+1:end, t_ind));
%                 title(['Data s ', int2str(t_ind), addstr]);
%                 subplot(spa,spb,bstrap), plot(newy(:,t_ind,loop), 'r');
%                 title(['Computed s ', int2str(t_ind), addstr]);
%                 subplot(spa,spb,bstrap+nblock), plot(ts(maxorder+1:end, t_ind));
%                 hold on;
%                 plot(newy(:,t_ind,loop), 'r');
%                 title(['Both s', addstr]);
%                 subplot(spa,spb,bstrap+2*nblock), plot(ts(maxorder+1:end, t_ind) - newy(:,t_ind,loop));
%                 title(['Difference', addstr]);
%             end
%         end
%     end
end

fvec(1,:) = F_12(nblock*dim_ns+1:nblock*(dim_ns+1));    % f12 for the 2 timeseries of interest
fvec(2,:) = F_1on2(nblock*dim_ns+1:nblock*(dim_ns+1));  % f1on2 for the timeseries of interest
fvec(3,:) = F_2on1(nblock*dim_ns+1:nblock*(dim_ns+1));  % f2on1 for the timeseries of interest
fvec(4,:) = fvec(2,:) - fvec(3,:);                      % fdiff for the timeseries of interest
fvec(5,:) = S(nblock*dim_ns+1:nblock*(dim_ns+1),1)';    % parametric F-value for 1on2
fvec(6,:) = p(nblock*dim_ns+1:nblock*(dim_ns+1),1)';    % corresponding parametric p value for 1on2
fvec(7,:) = S(nblock*dim_ns+1:nblock*(dim_ns+1),2)';    % parametric F-value for 2on1
fvec(8,:) = p(nblock*dim_ns+1:nblock*(dim_ns+1),2)';    % corresponding parametric p value for 2on1
fvec(9,:) = optm(nblock*dim_ns+1:nblock*(dim_ns+1));    % corresponding lag value

fnullmat(1,:) = F_12(1:nblock*dim_ns);                  % Variables to hold null distributions
fnullmat(2,:) = F_1on2(1:nblock*dim_ns);
fnullmat(3,:) = F_2on1(1:nblock*dim_ns);
fnullmat(4,:) = fnullmat(2,:) - fnullmat(3,:);
fnullmat(5,:) = S(1:nblock*dim_ns,1)';    % parametric F-value for 1on2
fnullmat(6,:) = p(1:nblock*dim_ns,1)';    % corresponding parametric p value for 1on2
fnullmat(7,:) = S(1:nblock*dim_ns,2)';    % parametric F-value for 2on1
fnullmat(8,:) = p(1:nblock*dim_ns,2)';    % corresponding parametric p value for 2on1
fnullmat(9,:) = optm(1,nblock*dim_ns);    % corresponding lag value
for l1 = 1:9
    for l2 = 1:dim_ns
        n_idx = [nblock*(l2-1)+1:nblock*l2];
        fnullmat_m(l1,:,l2) = fnullmat(l1,n_idx);
    end
end

