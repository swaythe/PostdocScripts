% Which subject do you want to create nuisance files for?
sub = 'Sub11';

% Which sessions?
sessions = 1:4;

% This is to identify which session was used to create the mean and mask
% files
baseSess = 1;

% Location of output files
glm_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess) '/GLM/'];

% Create one file per nuisance parameters
% Nuisance params - roll, pitch, yaw, dL, dP and dS not necessarily in that
% order

% Create identifiers for the 6 files you will create
fids = zeros(6,1);

% Open 6 files to save nuisance parameters. The files have extension .1D
% (just an AFNI text format)
for fi = 1:6
    fids(fi) = fopen([glm_dir 'nuisance' int2str(fi) '.1D'], 'w+');
end

% Main imaging directory
cd(['/home/sshankar/Categorization/Data/Imaging/' sub]);

for sessId = 1:length(sessions)
    % Change to directory in which you saved the nuisance parameters
    cd(['Session_' int2str(sessions(sessId)) '/NIFTIS/'])
    % Specify the file which contains the nuisance parameters
    % My nuisance files were saved as EPI_Task1_1D.txt, for instance
    nuisFiles = dir('EPI*_1D.txt');
    
    % For each file:
    % load it into memory
    % Extract column of interest
    % Save to file of interest, using fprintf
    for ni = 1:length(nuisFiles)
        nuis = load(nuisFiles(ni).name);
        for fi = 1:6 
            for i = 1:size(nuis,1)
                fprintf(fids(fi), '%d\n', nuis(i,fi));
            end
        end
    end
    cd ../..
end

% Close all newly created files
for fi = 1:6
    fclose(fids(fi));
end
