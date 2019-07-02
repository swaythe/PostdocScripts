% This script is useful primarily for loading the values that comprise a
% correlation defined by 3dRegAna.  Given an ROI (or ROIs) mask and a list
% of subjects, it loads the individual images that go into the correlation
% and extracts the value for each subject.

format compact;
maindir = '/home/Tolcapone/';
groupdir = [maindir 'Group_GLM/'];
templatedir = [maindir 'Templates/'];
scriptdir = [maindir 'Scripts/'];
datadir = ['/GLM_ASK/'];
choicedir = [datadir 'choice_reg/'];
addpath([scriptdir 'Nifti_Functions/']);

% Search only Group_GLM directory for clusters
disp(' ');
d = dir([groupdir 'Clust*nii.gz']);
if isempty(d)
    disp('No clusters available.  Exiting-');
    disp(' ');
    return
else
    disp('Available clusters:');
    for l1 = 1:length(d)
        disp(['  ' int2str(l1) ') ' d(l1).name]);
    end
    cidx = -999;
    while cidx < 1 || cidx > length(d)
        cidx = input('Selection:  ');
    end
    unix(['gunzip ' groupdir d(cidx).name]);
    mask = load_untouch_nii([groupdir d(cidx).name(1:end-3)]);
    unix(['gzip ' groupdir d(cidx).name(1:end-3)]);
    
    tmp_ROIs = unique(mask.img);
    for l1 = 2:length(tmp_ROIs)     % Skip 0 value
        maskidx{l1-1} = find(mask.img == tmp_ROIs(l1));
    end
end
clear tmp_ROIs;

disp(' ');
morc = 'x';
while morc ~= 'm' && morc ~= 'c'
    morc = input('Evaluate main GLM or choice-based GLM (m/c) ?  ','s');
end
switch morc
    case 'm', glmdir = datadir; con_bound = 132; astr = 'main';
    case 'c', glmdir = choicedir; con_bound = 96; astr = 'choice';
end

count = 0;
dsubj = dir([maindir '5*A']);
for l1 = 1:length(dsubj)
    currdir = [maindir dsubj(l1).name glmdir];
    dtemp = dir([currdir '*GLM.nii.gz']);
    if ~isempty(dtemp)
        temp_idx = strfind(dtemp(1).name, '.nii.gz');
        dtemp2 = dir([currdir '*GLM+tlrc.BRIK']);
        if isempty(dtemp2)
            command = ['3dcopy ' currdir dtemp(1).name ' ' currdir dtemp(1).name(1:temp_idx-1)];
            unix(command);
            clear command;
        end
        count = count+1;
        subj(count).name = dsubj(l1).name(1:3);
        subj(count).glm_name = [dtemp(1).name(1:temp_idx-1) '+tlrc'];
        subj(count).glm_dir = [maindir dsubj(l1).name glmdir];
    else
        
    end
end

disp(' ');
disp(['Subjects with data available:']);
for l1 = 1:length(subj)
    disp(['  ' int2str(l1) ') ' subj(l1).name]);
end
sval = -999;
sidx = [];
count = 0;
disp('Subjects to analyze (0 to quit, -1 for all, -2 for a vector):');
while sval ~= 0 && count < length(subj)
    sval = input(['  Number of subject #', int2str(count+1), ': ']);
    if sval == 0
        if count == 0
            disp('    --> Please enter at least one subject.');
            sval = -999;
        end
    elseif sval == -1
        sidx = [1:length(subj)];
        sval = 0;
    elseif sval == -2
        tmpvec = -999;
        while length(tmpvec) <= 1
            tmpvec = input('    Please enter a unique vector: ');
            if ~isempty(intersect(sidx,tmpvec))
                disp('      Overlaps with previous entries.  Please try again.');
                tmpvec = -999;
            elseif max(tmpvec) > length(subj) || min(tmpvec) < 1
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
    elseif sval < 1 || sval > length(subj)
        disp('    --> Please enter a valid number');
    elseif ~isempty(find(sidx == sval))
        disp('    --> Subject already entered.');
    else
        count = count + 1;
        sidx(count) = sval;
    end 
end
clear str count sval;

disp(' ');
brikidx = -999;
while brikidx < 1
    brikidx = input('Please select the .brik index for evaluation: ');
end

% Now begin to construct 3dMEMA/3dttest++/3dRegANA commands.  Start by
% loading any variables for correlation/regression
allcovariates = load([scriptdir 'summary_ICR_data.mat']);
currsubj = str2num(strvcat(subj.name));
allcovarsubj = cat(1,allcovariates.data(:,1));
[intersubj,dummy,tmpcidx] = intersect(currsubj,allcovarsubj);
cmat = allcovariates.data(tmpcidx,:);
clear allcovarsubj intersubj dummy tmpcidx;

disp(' ');
disp('Possible covariates to evaluate:');
for l1 = 1:length(allcovariates.columns)
    disp(['  ' int2str(l1) ') ' allcovariates.columns{l1}]);
end
vidx = -999;
while vidx < 1 || vidx > length(allcovariates.columns)
    vidx = input('Selection:  ');
end
cov_col = cmat(:,vidx);
clear vidx;

% Now go through & load all of the appropriate primary data
for l1 = 1:length(sidx)
    disp(['  Loading subject ' subj(l1).name]);
    filename = subj(l1).glm_name;
    pidx = strfind(filename, '+tlrc');
    if ~isempty(pidx)     % Need .nii, not .brik
        filename = filename(1:pidx-1);
    end
    filename = [subj(l1).glm_dir filename];
    unix(['gunzip ' filename '.nii.gz']);
    nii = load_untouch_nii([filename '.nii'], 1, brikidx+1);     % REMEMBER that AFNI starts at zero, MATLAB at one!!
    unix(['gzip ' filename '.nii']);
    
    for l2 = 1:length(maskidx)
        volvals{l1,l2} = nii.img(maskidx{l2});
    end
end

% Get SNPs, then sort them by genotype for display of icr differences.
% Note that SNP indices are evaluated only for those subjects explicitly
% included via the variable "goodidx", above.
tmp_subj = strvcat(subj.name);
tmp_subj = [tmp_subj char(ones(size(tmp_subj,1),1)*'A')];
snps = resting_state_get_genetics(tmp_subj);
for l1 = 1:size(snps.key,1)
    snpidx{l1} = find(snps.snps == l1);
end
if ~isempty(find(isnan(snps.snps)))
    snpidx{l1+1} = find(isnan(snps.snps));
end

% Finally, look at correlations
graystep = 0.0;     % graystep = 0.333;
for l1 = 1:length(maskidx)
    % Average across all voxels within the mask, for now at least
    allvals = cat(2,volvals{:,l1});
    for l2 = 1:size(allvals,1)
        tmp_corr = corrcoef(allvals(l2,:), cov_col);
        allr{l1}(l2) = tmp_corr(1,2);
    end
    meanvals{l1} = mean(allvals);

    figure(l1);
    s = subplot(1,1,1);
    for l2 = 1:length(snpidx)
        ptcolor = l2 * ones(1,3) * graystep;
        p = plot(meanvals{l1}(snpidx{l2})', cov_col(snpidx{l2}), 'ko');
        set(p, 'MarkerSize', 9); 
        if l2 ~= length(snpidx)
            set(p, 'Color', ptcolor, 'MarkerFaceColor', ptcolor);
        else
            set(p,'MarkerFaceColor', ptcolor);
        end
        hold on;
    end
    param1 = polyfit(meanvals{l1}', cov_col, 1);
    xvec1 = [min(meanvals{l1}):0.01:max(meanvals{l1})];
    yvec1 = xvec1.*param1(1) + param1(2);
    p1b = plot(xvec1, yvec1, '--');
    set(p1b, 'LineWidth', 2, 'LineStyle', '-', 'Color', 'k');
    hold off;
    set(s, 'XLim', [floor(1.1*xvec1(1)) ceil(1.1*xvec1(end))], 'Box', 'off', ...
            'LineWidth', 2, 'YLim', [-0.3 0.2]);

    tmp_corr = corrcoef(meanvals{l1}, cov_col);
    big_corr(l1) = tmp_corr(1,2);
end