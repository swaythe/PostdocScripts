function [NewData] = fmean_bell_HL (Data, blocklen, dodetrend, dowindow, varargin);

% Mean-center/detrend and use 4-point split-cosine bell to smooth discontinuities
% in data set (possibly only appropriate for coherency analysis)
%
% Inputs:   1) Data holds the time series for each voxel in column
%               vector format.
%           2) blocklen is the length of each data block.  
%           3) dodetrend = 1 for detrending, 2 for detrending plus
%               normalization to unit variance, 0 to skip.  Usually, this
%               parameter should be set to 1.
%           4) dowindow = 1 for cosine windowing, 0 to skip.
%           5) varargin: if this number exists, it represents the
%               interpolated TR, and indicates that high-pass filtering
%               should be performed to remove low-frequency noise.
%
% Output:   1) NewData holds the detrended, split-cosine-windowed time
%               series for each voxel in the data set
%
% Caveats:  1) Data are detrended, rather than mean-centered, prior to
%               windowing.
%           2) Default is to window ~10% of data points.
%           3) If normalizing to unit variance, final variances will be
%               slightly less than one if cosine windowing is performed,
%               since windowing occurs after normalization.

addpath /usr/local/apps/matlab/toolbox/spm2;
[timelength, dummy] = size(Data);
blockend = [1:blocklen:timelength];
lblockend = length(blockend);

% Remove low frequencies from the data.  This step should be done before
% dividing data into blocks, as the low frequency effects are specific to
% the whole data run, regardless of block length.
if ~isempty(varargin)
    K.RT = varargin{1};
    K.row = [1:timelength]';
    K.HParam = 128;     % Cutoff in seconds
    if exist('NewData') == 0
        NewData = Data;
    end
    NewData = spm_filter(K, NewData);
else
    if exist('NewData') == 0
        NewData = Data;
    end
end

% Remove linear trends from the data
if dodetrend == 1 || dodetrend == 2
    for loop = 1:lblockend
        tmpindex = [blocklen*(loop-1)+1:blocklen*loop];
        NewData(tmpindex,:) = detrend(NewData(tmpindex,:));
        if dodetrend == 2
            NewData(tmpindex,:) = NewData(tmpindex,:) ./ ...
                (ones(length(tmpindex),1) * std(NewData(tmpindex,:)));
        end
    end
end

% Create & apply 4-point split-cosine bell window
if dowindow == 1
    if exist('NewData') == 0
        NewData = Data;
    end
    p = 0.10;
    windex = round(0.5* p * blocklen);
    coswindow = ones(blocklen,1);
    coswindow(1:windex) = 0.5 * (1 - cos(2*pi*([0:windex-1]./blocklen)./p));
    coswindow(blocklen-windex+1:blocklen) = 0.5 * (1 - cos(2*pi*(1 - ([windex-1:-1:0]./blocklen)./p)));

    tmpcoswindow = [];
    for loop = 1:lblockend
        tmpcoswindow = [tmpcoswindow coswindow'];
    end

    % Window the data with a cosine window
    [dummy, masknumvoxels] = size(NewData);
    newcoswindow = tmpcoswindow' * ones(1,masknumvoxels);
    NewData = newcoswindow .* NewData;
    clear newcoswindow;
end

if exist('NewData') == 0
    NewData = Data;
end
rmpath /usr/local/apps/matlab/toolbox/spm2;

return
