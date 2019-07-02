% % This script is designed to take resting state data, extract time series
% % from regions of interest, and compute Granger causality.
% 
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
% % subs = {'Sub01'};
% % baseSess = 1;
% nEPI = zeros(1,length(subs));
% 
% format compact;
% TR = 1.8;
% blocklen = 25;
% 
% main_dir = '/home/sshankar/Categorization/Data/Imaging/';
% roi_dir = 'ROI_3x3_005unc';
% roi_common = 'Anova005unc';
% tc_file = [roi_common 'TCGranger_all'];
% 
% % First go through all data & remove low frequency drifts.
% % Define spm_filter filter parameters
% K.RT = TR;
% K.row = (1:300)';
% K.HParam = 128; % cutoff time, in s
% 
% for si = 1:length(subs)
%     sub = subs{si};
%     tc_dir = [main_dir sub '/Session_' int2str(baseSess(si)) '/' roi_dir '/'];
%     cd(tc_dir)
%     load([sub '_' tc_file])
% 
%     nEPI(si) = size(timecourse,2);
%     for ei = nEPI(si):-1:1
%         if sum(timecourse(1,ei,:)) == 0
%             nEPI(si) = nEPI(si) - 1;
%         end
%     end
%     nROI = size(timecourse,3);
% end
% 
% tc_hiF = cell(length(subs),max(nEPI),nROI);
% 
% for si = 1:length(subs)
%     for ei = 1:nEPI(si)
%         for roi = 1:nROI
%             tc_hiF{si,ei,roi} = spm_filter(K, timecourse(:,ei,roi));
%         end
%     end
% end
% 
% % % Now find contiguous blocks of blocklen, accounting for discontinuities in
% % % the keep_frames variable
% % for l1 = 1:length(subj_tc)
% %     for l2 = 1:length(subj_tc(l1).epidir)
% %         var = subj_tc(l1).epidir(l2).keep_frames;
% %         diff_var = find([1 diff(var)] > 1);
% %         idx = [1:blocklen];
% %         keepidx = [];
% %         while max(idx) <= length(var)
% %             if (var(idx(end)) - var(idx(1))) == blocklen-1
% %                 keepidx = [keepidx idx];
% %                 idx = idx + blocklen;
% %             else
% %                 brkpt = find(diff_var < idx(end));
% %                 idx = diff_var(brkpt(end)):diff_var(brkpt(end))+blocklen-1;
% %             end
% %         end
% %         subj_tc(l1).epidir(l2).block_frames = var(keepidx);
% %         clear var diff_var idx keepidx brkpt;
% %     end
% % end
% 
% % Consolidate across epi directories
% cons_tc = cell(length(subs),nROI);
% 
% for si = 1:length(subs)
%     for ei = 1:nEPI(si)
%         for roi = 1:nROI
%             cons_tc{si,roi} = [cons_tc{si,roi}; tc_hiF{si,ei,roi}];
%         end
%     end
% end
% 
% % Now do detrending in block-wise fashion
% gdata = cell(length(subs), nROI);
% mgdata = cell(length(subs), nROI);
% mgnull = cell(length(subs), nROI);
% for si = 1:length(subs)
%     for roi = 1:nROI
%         gdata{si,roi} = fmean_bell(cons_tc{si,roi}, ...
%                 blocklen, 1, 0);        % Leave off interpTR argument here; ?discontinuous data
%         mgdata{si,roi} = mean(gdata{si,roi},2);
%         mgnull{si,roi} = fget_null(mgdata{si,roi}, blocklen);
%     end
% end
% 
% % And compute the Granger Causality metrics between all ROIs
% grg = cell(nROI-1,nROI-1,length(subs));
% grg_null = cell(nROI-1,nROI-1,length(subs));
% 
% tic
% for si = 1:length(subs)
%     for ei1 = 1:nROI-1
%         for ei2 = ei1+1:nROI
%             [grg{ei1,ei2,si} grg_null{ei1,ei2,si}] = ...
%                 fget_granger_blockN_param(mgdata{si,ei1}, mgdata{si,ei2}, mgnull{si,ei1}, [], 4, 0, blocklen);
%         end
%     end
% end
% disp(['  All GC values computed in ', num2str(toc/60), ' minutes.']);
% 
% % % Evaluate Fdiff for connections 1->3 and 2->4 to start
% fdiff_vals = zeros(nROI-1,nROI,1,length(subs));
% 
% for l1 = 1:size(grg,3)                  % Subjects
%     for l2 = 1:size(grg,1)              % First ROI
%         for l3 = l2+1:size(grg,2)       % Second ROI
%             fdiff_vals(l2,l3,l1) = median(grg{l2,l3,l1}(4,:));
%         end
%     end
% end
% % fdiff_13 = reshape(fdiff_vals(1,3,:), numel(fdiff_vals(1,3,:)), 1);
% % fdiff_24 = reshape(fdiff_vals(2,4,:), numel(fdiff_vals(2,4,:)), 1);
% % [p13,h13,stats13] = signrank(fdiff_13);
% % median_fdiff_13 = median(fdiff_13);
% % [p24,h24,stats24] = signrank(fdiff_24);
% % median_fdiff_24 = median(fdiff_24);
% % 
% % disp(['  Influence of ROI#1 on ROI#3: median = ' num2str(median_fdiff_13) ...
% %             ' with p = ' num2str(p13)]);
% % disp(['  Influence of ROI#2 on ROI#4: median = ' num2str(median_fdiff_24) ...
% %             ' with p = ' num2str(p24)]);

% Calculate the Granger-causal relationship between each ROI (ROI1) and all the
% other ROIs
% Positive values of fdiff_roi indicates a causal relationship from ROI1 to
% ROI2, negative indicates the opposite
fdiff_roi = zeros(length(subs),nROI,nROI);
p_roi = zeros(nROI,nROI);
med_fdiff_roi = zeros(nROI,nROI);
for roi1 = 1:nROI
    for roi2 = 1:roi1-1
        fdiff_roi(:,roi2,roi1) = squeeze(fdiff_vals(roi2,roi1,:))*-1;
        if sum(isnan(fdiff_roi(:,roi2,roi1))) ~= length(subs)
            [p_roi(roi2,roi1),h,stats] = signrank(fdiff_roi(:,roi2,roi1));
            med_fdiff_roi(roi2,roi1) = median(fdiff_roi(:,roi2,roi1));
        end
    end

    for roi2 = roi1+1:nROI
        fdiff_roi(:,roi2,roi1) = squeeze(fdiff_vals(roi1,roi2,:));
        if sum(isnan(fdiff_roi(:,roi2,roi1))) ~= length(subs)
            [p_roi(roi2,roi1),h,stats] = signrank(fdiff_roi(:,roi2,roi1));
            med_fdiff_roi(roi2,roi1) = median(fdiff_roi(:,roi2,roi1));
        end
    end
end
% fdiff_13 = reshape(fdiff_vals(1,3,:), numel(fdiff_vals(1,3,:)), 1);
% fdiff_24 = reshape(fdiff_vals(2,4,:), numel(fdiff_vals(2,4,:)), 1);
% [p13,h13,stats13] = signrank(fdiff_13);
% median_fdiff_13 = median(fdiff_13);
% [p24,h24,stats24] = signrank(fdiff_24);
% median_fdiff_24 = median(fdiff_24);
