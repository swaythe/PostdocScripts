% This function is designed to generate regions of interest for individual
% tolcapone study subjects based on MNI coordinates provided by the user.
%
% NB: See /home/dots/MNI/sample warping commands.txt for additional
% information.

format compact;
main_dir = '/home/Tolcapone/';
script_dir = [main_dir, 'Scripts/'];
template_dir = [main_dir, 'Templates/'];
roi_dir = [main_dir, 'ROIs/'];
if exist(roi_dir) ~= 7
    unix(['mkdir ' roi_dir]);
end

d = dir([main_dir, '5*']);
dlist = strvcat(d.name);
[dummy,didx] = unique(dlist(:,1:3), 'rows', 'first');
d = d(didx);

disp(' ');
disp('Possible Subjects:');
for l1 = 1:length(d)
    disp(['  ', int2str(l1), ') ', d(l1).name]);
end
sval = -999;
sidx = [];
count = 0;
disp('Subjects to analyze (0 to quit, -1 for all):');
while sval ~= 0 && count < length(d)
    sval = input(['  Number of subject #', int2str(count+1), ': ']);
    if sval == 0
        if count == 0
            disp('    --> Please enter at least one subject.');
            sval = -999;
        end
    elseif sval == -1
        sidx = [1:length(d)];
        sval = 0;
    elseif sval < 1 || sval > length(d)
        disp('    --> Please enter a valid number');
    elseif ~isempty(find(sidx == sval))
        disp('    --> Subject already entered.');
    else
        count = count + 1;
        sidx(count) = sval;
    end 
end

disp(' ');
disp('Please enter the name of the output ROI file:');
correct = 'n';
while correct ~= 'y'
    roi_fileshort = input('  Name (without .nii suffix): ','s');
    correct = input('    Is this name correct (y/n) ?  ','s');
end
roi_filename = [roi_dir roi_fileshort];

disp(' ');
todo = 'x';
while todo ~= 'g' && todo ~= 'a' && todo ~= 'b'
    todo = input('Would you like to (g)enerate ROIs, (a)pply ROIs, or (b)oth? ','s');
end

if todo == 'g' || todo == 'b'
    disp(' ');
    disp('  Enter MNI coordinates -- [x y z] in mm -- for each ROI (0 to finish):');
    disp('    NB: Talairach coordinates can be entered.  Include a 4th value');
    disp('        equal to -999, and the 3 values will be converted to MNI.');
    count = 0;
    MNI_coord = [];
    coord_input = -999;
    while coord_input ~= 0
        count = count+1;
        coord_input = input(['    MNI coordinates for ROI #' int2str(count) ': ']);
        if length(coord_input) == 4 && coord_input(4) == -999
            coord_input = round(tal2mni(coord_input(1:3)'))';
        end
        if length(coord_input) == 3
            if size(unique([MNI_coord; coord_input],'rows'),1) ~= size([MNI_coord; coord_input],1)
                disp('      Please enter a unique set of coordinates.');
                count = count-1;
            else
                MNI_coord(count,:) = coord_input;
            end
            coord_input = -999;
        elseif coord_input(1) == 0
            if count == 1
                disp('      Please enter at least one set of coordinates.');
                count = count-1;
                coord_input = -999;
            else
                disp('      Last ROI coordinates entered.');
            end
        else
            disp('      Invalid coordinates.');
            count = count-1;
            coord_input = -999;
        end
    end
    disp(' ');
    disp('NB: Our current template MNI-small.nii is in RPI orientation. When');
    disp('    MNI coordinates are taken from reported manuscripts, they appear');
    disp('    to be in LPI orientation.  The Afni GUI/viewer appears to display');
    disp('    images in radiological convention, using the orientation information');
    disp('    from both underlay & overlay and converting to radiological format.');
    disp('    Thus, I assume here that MNI coordinates are entered in LPI');
    disp('    orientation, and that to match them to our RPI template, THE');
    disp('    X-COORDINATES MUST BE MULTIPLIED BY -1 (DOING SO NOW).  The Afni');
    disp('    GUI will do the right thing regardless, but as a result its display');
    disp('    cannot be used to determine whether image headers are in matching');
    disp('    orientations.');
    MNI_coord(:,1) = -1 * MNI_coord(:,1);

    % Now assemble commands for the creation of the ROIs in MNI space
    disp(' ');
    srad = -999;
    while srad == -999
        srad = input('  What radius, in mm, would you like around these points? ','s');
        correct = input('    Is this value correct (y/n) ?  ','s');
        if correct ~= 'y'
            srad = -999;
        end
    end

    disp(' ');
    disp('Creating ROI file in MNI space');
    disp('******************************');
    roi_ascii_file = [roi_filename '_ascii.txt'];
    fid = fopen(roi_ascii_file, 'w+');
    for l1 = 1:size(MNI_coord,1)
        fprintf(fid, '%6.2f %6.2f %6.2f %6.2f\n', [MNI_coord(l1,:) l1]);
    end
    fclose(fid);

    MNI_brain = [template_dir, 'MNI-small.nii'];
    if exist(MNI_brain) ~= 2
        disp(['  *** No MNI template ' MNI_brain ' ***']);
        disp('  Exiting...');
        return
    end
    MNI_brain_mask = [template_dir, 'MNI-small-mask.nii'];
    if exist(MNI_brain_mask) ~= 2
        disp(['  *** No MNI template mask ' MNI_brain_mask '.  Creating... ***']);
        command = ['3dAutomask -prefix ' MNI_brain_mask ' ' MNI_brain];
        unix(command);
        clear command;
    end
    command = ['3dUndump -prefix ' roi_filename '.nii -master ' MNI_brain ...
                ' -xyz -srad ' srad ' ' roi_ascii_file]   % ' -mask ' MNI_brain_mask 
    unix(command);
    clear command;
    unix(['chmod 755 ' roi_filename '.nii']);
    disp('NB: Mask for 3dUndump excluded to ensure user controls ROIs.');
end

if todo == 'a' || todo == 'b'
    disp(' ');
    disp('Now warping each ROI into native space for each subject:');
    for l1 = 1:length(sidx)
        subj_roidir = [main_dir d(sidx(l1)).name '/ROIs/'];
        if exist(subj_roidir) ~= 7
            unix(['mkdir ' subj_roidir]);
        end
        subj_anatdir = [main_dir d(sidx(l1)).name '/Anatomy/'];
        invwarp_file = [subj_anatdir d(sidx(l1)).name '_invfnirt.nii.gz'];
        if exist(invwarp_file) ~= 2
            command = ['invwarp --ref=' subj_anatdir d(sidx(l1)).name '_mprage_AlignEpi.nii.gz ' ...
                        '--warp=' subj_anatdir d(sidx(l1)).name '_fnirt.nii.gz ' ...
                        '--out=' invwarp_file]
            tic;
            unix(command);
            disp(['  Finished inverse warp generation in ' num2str(toc/60) ' minutes.']);
            clear command;
            unix(['chmod 755 ' invwarp_file]);
        end
        output_prefix = [subj_roidir d(sidx(l1)).name '_' roi_fileshort];
        command = ['applywarp --ref=' subj_anatdir d(sidx(l1)).name '_mprage_AlignEpi.nii.gz ' ...
                    '--in=' roi_filename '.nii --warp=' invwarp_file ' --out=' output_prefix ...
                    '.nii.gz --interp=nn']
        unix(command);
        clear command;
        command = ['3dresample -prefix ' output_prefix '-Resample.nii.gz -master ' ...
                    subj_anatdir d(sidx(l1)).name '_Mean.nii.gz -inset ' output_prefix '.nii.gz']
        unix(command);
        clear command;
        epi_mask_file = [subj_anatdir d(sidx(l1)).name '_Mask.nii.gz'];
        command = ['3dcalc -a ' output_prefix '-Resample.nii.gz -b ' epi_mask_file ...
                    ' -expr ''step(b)*a'' -prefix ' output_prefix '-Mask.nii.gz']
        unix(command);
        clear command;
        unix(['rm ' output_prefix '.nii.gz']);
        unix(['rm ' output_prefix '-Resample.nii.gz']);
    end
end
