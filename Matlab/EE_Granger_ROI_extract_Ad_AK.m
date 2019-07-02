% This script is designed to take resting state data, extract time series
% from regions of interest, and compute Granger causality.
%
% Likely subject vector: [1:20 22:43 45:57 59:60 62:66]
%
% Remember to use 3dcalc to create an ROI file with all the ROIs of
% interest.  This function should take care of the rest.

format compact;
interpTR = 1.37;
blocklen = 25;
addpath /home/akayser/mfiles;
addpath /home/akayser/mfiles_ace;

sraf = '_Smooth.nii.gz';     % Appropriate suffix for EPI files
maindir = '/home/akayser/Adolescents/';
restdir = [maindir 'RestingState/'];
roidir = [maindir 'ROIs/'];
addpath '/home/Tolcapone/Scripts/';
addpath '/home/Tolcapone/Scripts/Nifti_Functions/';

% Get regions of interest from which to obtain data
disp(' ');
disp('Possible ROIs for data extraction:');
d3 = dir([roidir '*nii*']);
for l1 = 1:length(d3)
    disp(['  ' int2str(l1) ') ' d3(l1).name]);
end
extractROI = -999;
while extractROI < 1 || extractROI > length(d3)
    extractROI = input('Please select ROI file for extraction: ');
end
adot = find(d3(extractROI).name == '.');
selROI = d3(extractROI).name(1:adot-1);
clear adot;

% gzipped = 0;
% if ~isempty(strfind(d3(extractROI).name, '.gz'))
%     gzipped = 1;
%     unix(['gunzip ' roidir d3(extractROI).name]);
%     d3(extractROI).name = d3(extractROI).name(1:end-3);
% end
% vstruct = load_untouch_nii([roidir d3(extractROI).name]);
% if gzipped
%     unix(['gzip ' roidir d3(extractROI).name]);
% end
% numvals = unique(vstruct.img(find(vstruct.img > 0)));
% for l1 = 1:length(numvals)
%     vidx{l1} = find(vstruct.img == numvals(l1));
% end

% d = dir([restdir '*MNI.nii.gz']);
% for l1 = 1:length(d)
%     uscore = find(d(l1).name == '_');
%     adot = find(d(l1).name == '.');
%     roi_name{l1} = d(l1).name(uscore(end)+1:adot(end-1)-1);
% end
% roi_unq = unique(strvcat(roi_name),'rows');
% clear d uscore adot roi_name;
% 
% disp(' ');
% disp('Possible ROI data files:');
% for l1 = 1:size(roi_unq,1)
%     adash = find(roi_unq(l1,:) == '-');
%     filename = [roidir roi_unq(l1,1:adash(1)-1) '_ascii.txt'];
%     filerow = str2num(roi_unq(l1,adash(end-1)+1:adash(end)-1));
%     filedata = load(filename);
%     MNIcoords(l1,:) = filedata(filerow,1:3);
%     disp(['  ' int2str(l1) ') ' roi_unq(l1,1:adash(1)-1) ' with MNI coords: ' ...
%        'x = ' int2str(MNIcoords(l1,1)) ', y = ' int2str(MNIcoords(l1,2)) ...
%        ', z = ' int2str(MNIcoords(l1,3))]);
% end
% thisROI = -999;
% while thisROI < 1 || thisROI > size(roi_unq,1)
%     thisROI = input('Please select ROI: ');
% end
% selROI = roi_unq(thisROI,find(~isspace(roi_unq(thisROI,:))));
% filesuffix = [selROI '.nii.gz'];
% clear adash filename filerow filedata MNIcoords thisROI;
% 
% d2 = dir([restdir '*' filesuffix]);
% for l1 = 1:length(d2)
%     uscore = find(d2(l1).name == '_');
%     subj(l1,:) = d2(l1).name(1:uscore(1)-1);
% end
% subj_name = strvcat(subj(:,1:3));
% [subj_unq, subj_idx(:,1), dummy] = unique(subj_name, 'rows', 'first');
% [subj_unq, subj_idx(:,2), dummy] = unique(subj_name, 'rows', 'last');
% clear filesuffix uscore subj dummy;

d = dir(maindir);
dsubj = [];
for l1 = 1:length(d)
    if length(d(l1).name) == 3 && ~isempty(str2num(d(l1).name))
        dsubj = [dsubj d(l1)];
    end
end
subj_unq = strvcat(dsubj.name);
clear d;

disp(' ');
disp(['Subjects for ROI file ' selROI ':']);
for l1 = 1:size(subj_unq,1)
    % if subj_idx(l1,1) ~= subj_idx(l1,2)
    %     str = '2 sessions';
    % else
    %     str = '1 session';
    % end
    disp(['  ' int2str(l1) ') ' subj_unq(l1,:)]);   % ' with ' str]);
end
sval = -999;
sidx = [];
count = 0;
disp('Subjects to analyze (0 to quit, -1 for all, -2 for a vector):');
while sval ~= 0 && count < size(subj_unq,1)
    sval = input(['  Number of subject #', int2str(count+1), ': ']);
    if sval == 0
        if count == 0
            disp('    --> Please enter at least one subject.');
            sval = -999;
        end
    elseif sval == -1
        sidx = [1:size(subj_unq,1)];
        sval = 0;
    elseif sval == -2
        tmpvec = -999;
        while length(tmpvec) <= 1
            tmpvec = input('    Please enter a unique vector: ');
            if ~isempty(intersect(sidx,tmpvec))
                disp('      Overlaps with previous entries.  Please try again.');
                tmpvec = -999;
            elseif max(tmpvec) > size(subj_unq,1) || min(tmpvec) < 1
                disp('      Some entries out of bounds.  Please try again.');
                tmpvec = -999;
            end
        end
        disp('      Removing duplicates & ordering lowest -> highest...');
        tmpvec = unique(tmpvec);
        sidx(count+1:count+length(tmpvec)) = tmpvec;
        count = count+length(tmpvec);
        sval = 1;   % This value allows the loop to continue
        clear tmpvec;
    elseif sval < 1 || sval > size(subj_unq,1)
        disp('    --> Please enter a valid number');
    elseif ~isempty(find(sidx == sval))
        disp('    --> Subject already entered.');
    else
        count = count + 1;
        sidx(count) = sval;
    end 
end
clear str count sval;

% Send subject data with A/B added, as these aren't included in subj_unq.
actual_subj = subj_unq(sidx,:);
edata = resting_state_getEE_var_Ad(actual_subj);

% Now go through each subject directory & obtain time series data
disp(' ');
all_subj_tc_file = [roidir 'subj_tc_' selROI '.mat'];
if exist(all_subj_tc_file, 'file')
    disp('  Loading pre-existing timecourse data for this ROI.');
    load(all_subj_tc_file);
else
    for l1 = 1:size(actual_subj,1)
        disp(['  Loading epi files of type *', sraf, ' for subject ' actual_subj(l1,:) '.']);    
        
        % First load the ROI file
        subj_roi_file = [maindir actual_subj(l1,:) '/ROIs/' actual_subj(l1,:) '_' ...
                            selROI '-Mask.nii'];
        gzipped = 0;
        if exist([subj_roi_file '.gz'], 'file')
            gzipped = 1;
            unix(['gunzip ' subj_roi_file '.gz']);
        end
        roistruct = load_untouch_nii(subj_roi_file);
        if gzipped
            unix(['gzip ' subj_roi_file]);
        end
        numvals = unique(roistruct.img(find(roistruct.img > 0)));
        for l2 = 1:length(numvals)
            roiidx{l2} = find(roistruct.img == numvals(l2));
        end
        clear gzipped subj_roi_file numvals;

        % Now define the EPI directories
        funcdir = [maindir actual_subj(l1,:) '/Functional/'];
        epidir = dir([funcdir 'Rest*']);

        % Now load smoothed data 
        for l2 = 1:length(epidir)
            sraf_file = [funcdir epidir(l2).name '/' actual_subj(l1,:) '_' epidir(l2).name sraf];
            unix(['gunzip ' sraf_file]);
            vstruct = load_untouch_nii(sraf_file(1:end-3));
            for l3 = 1:size(vstruct.img,4)
                tmp = vstruct.img(:,:,:,l3);
                for l4 = 1:length(roiidx)
                    subj_tc(l1).epidir(l2).roi(l4).data(l3,:) = tmp(roiidx{l4});
                end
            end
            unix(['gzip ' sraf_file(1:end-3)]);
            if l2 == 1      % Save the header for later
                subj_tc(l1).vstruct = vstruct;
                subj_tc(l1).roistruct = roistruct;
                subj_tc(l1).roiidx = roiidx;
                subj_tc(l1).datasize = size(vstruct.img);
                subj_tc(l1).roisize = size(roistruct.img);
                subj_tc(l1).vstruct = rmfield(subj_tc(l1).vstruct, 'img');
                subj_tc(l1).roistruct = rmfield(subj_tc(l1).roistruct, 'img');
            end
            clear vstruct;
        end
        clear sraf_file tmp roiidx;

        % Check for the scrub matrix to define appropriate time points
        for l2 = 1:length(epidir)
            scrub_file = [funcdir epidir(l2).name '/' actual_subj(l1,:) '_' ...
                            epidir(l2).name '_Scrub.mat'];
            if exist(scrub_file, 'file')
                tmp = load(scrub_file);
                subj_tc(l1).epidir(l2).keep_frames = tmp.keep_frames;
                clear tmp;
            else
                subj_tc(l1).epidir(l2).keep_frames = [1:subj_tc(l1).datasize(4)];
            end
        end
        clear scrub_file funcdir epidir;
    end
    save(all_subj_tc_file, 'subj_tc', 'actual_subj', 'selROI');
end

% First go through all data & remove low frequency drifts. Ordinarily this
% step would be done together with detrending, but because individual data
% points may be excluded 2* motion, it must be performed first. 
for l1 = 1:length(subj_tc)
    for l2 = 1:length(subj_tc(l1).epidir)
        for l3 = 1:length(subj_tc(l1).epidir(l2).roi)
            subj_tc(l1).epidir(l2).roi(l3).fdata = fmean_bell_HL(subj_tc(l1).epidir(l2).roi(l3).data, ...
                    blocklen, 0, 0, interpTR);
        end
    end
end

% Now find contiguous blocks of blocklen, accounting for discontinuities in
% the keep_frames variable
for l1 = 1:length(subj_tc)
    for l2 = 1:length(subj_tc(l1).epidir)
        var = subj_tc(l1).epidir(l2).keep_frames;
        diff_var = find([1 diff(var)] > 1);
        idx = [1:blocklen];
        keepidx = [];
        while max(idx) <= length(var)
            if (var(idx(end)) - var(idx(1))) == blocklen-1
                keepidx = [keepidx idx];
                idx = idx + blocklen;
            else
                brkpt = find(diff_var < idx(end));
                idx = diff_var(brkpt(end)):diff_var(brkpt(end))+blocklen-1;
            end
        end
        subj_tc(l1).epidir(l2).block_frames = var(keepidx);
        clear var diff_var idx keepidx brkpt;
    end
end

% Consolidate across epi directories
for l1 = 1:length(subj_tc)
    for l3 = 1:length(subj_tc(l1).epidir(1).roi)
        subj_tc(l1).consolidate(l3).fdata = [];
    end
end
for l1 = 1:length(subj_tc)
    for l2 = 1:length(subj_tc(l1).epidir)
        for l3 = 1:length(subj_tc(l1).epidir(l2).roi)
            tmpvar = subj_tc(l1).epidir(l2).roi(l3).fdata(subj_tc(l1).epidir(l2).block_frames,:);
            subj_tc(l1).consolidate(l3).fdata = [subj_tc(l1).consolidate(l3).fdata; tmpvar];
        end
    end
end

% Now do detrending in block-wise fashion
for l1 = 1:length(subj_tc)
    for l2 = 1:length(subj_tc(l1).consolidate)
        subj_tc(l1).consolidate(l2).gdata = fmean_bell_HL(subj_tc(l1).consolidate(l2).fdata, ...
                blocklen, 1, 0);        % Leave off interpTR argument here; ?discontinuous data
        subj_tc(l1).consolidate(l2).mgdata = mean(subj_tc(l1).consolidate(l2).gdata,2);
        subj_tc(l1).consolidate(l2).mgnull = fget_null(subj_tc(l1).consolidate(l2).mgdata, blocklen);
    end
end

% And compute the Granger Causality metrics between all ROIs
tic
for l1 = 1:length(subj_tc)
    for l2 = 1:length(subj_tc(l1).consolidate)-1
        for l3 = l2+1:length(subj_tc(l1).consolidate)
            [grg{l2,l3,l1} grg_null{l2,l3,l1}] = ...
                fget_granger_blockN_param(subj_tc(l1).consolidate(l2).mgdata, ...
                    subj_tc(l1).consolidate(l3).mgdata, subj_tc(l1).consolidate(l2).mgnull, ...
                    [], 4, 0, blocklen);
        end
    end
end
disp(['  All GC values computed in ', num2str(toc/60), ' minutes.']);

% Evaluate Fdiff for connections 1->3 and 2->4 to start
for l1 = 1:size(grg,3)                  % Subjects
    for l2 = 1:size(grg,1)              % First ROI
        for l3 = l2+1:size(grg,2)       % Second ROI
            fdiff_vals(l2,l3,l1) = median(grg{l2,l3,l1}(4,:));
        end
    end
end
fdiff_13 = reshape(fdiff_vals(1,3,:), numel(fdiff_vals(1,3,:)), 1);
fdiff_24 = reshape(fdiff_vals(2,4,:), numel(fdiff_vals(2,4,:)), 1);
[p13,h13,stats13] = signrank(fdiff_13);
median_fdiff_13 = median(fdiff_13);
[p24,h24,stats24] = signrank(fdiff_24);
median_fdiff_24 = median(fdiff_24);

disp(['  Influence of ROI#1 on ROI#3: median = ' num2str(median_fdiff_13) ...
            ' with p = ' num2str(p13)]);
disp(['  Influence of ROI#2 on ROI#4: median = ' num2str(median_fdiff_24) ...
            ' with p = ' num2str(p24)]);
        
% Now compute correlations
% for l1 = 1:length(datavidx)
%     figure(l1);
%     s = plot_correlation(edata{1}.explore, mean(datavidx{l1},2), [0 0 0], ...
%                          [1 1 1], 'Behavior', 'BOLD');
%     [r,p] = corrcoef(mean(datavidx{l1},2), edata{1}.explore);
%     title(['Region #' int2str(l1) '; corr = ' num2str(r(1,2)) ' with p = ' num2str(p(1,2))]);
% end

% And compare explorers to non-explorers
disp(' ');
disp('Non-explorer versus explorer data:');
zeroidx = find(edata{1}.explore == 0);
nonidx = find(edata{1}.explore ~= 0);

[p13b,h13b,stats13b] = ranksum(fdiff_13(zeroidx),fdiff_13(nonidx));
[p24b,h24b,stats24b] = ranksum(fdiff_24(zeroidx),fdiff_24(nonidx));

disp(['  Difference in #1->#3 influence: p = ' num2str(p13b)]);
disp(['  Difference in #2->#4 influence: p = ' num2str(p24b)]);

[tau_13, z_13, pk_13] = kendall(edata{1}.explore, fdiff_13);
[tau_24, z_24, pk_24] = kendall(edata{1}.explore, fdiff_24);

disp(['  Kendall correlation between explore & #1->#3:  p = ' num2str(pk_13)]);
disp(['  Kendall correlation between explore & #2->#4:  p = ' num2str(pk_24)]);
disp(' ');
