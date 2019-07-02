subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
sessions = 1:4;
% subs = {'Sub11'};
% baseSess = 1;

for si = 1:length(subs)
    sub = subs{si};
    nuis_dir = ['/home/sshankar/Categorization/Data/Imaging/' sub '/Session_' int2str(baseSess(si)) '/Nuisance_params/'];
    % Create one file per nuisance parameters
    % Nuisance params - roll, pitch, yaw, dL, dP and dS not necessarily in that
    % order
    fids = zeros(6,1);
    for fi = 1:6
        fids(fi) = fopen([nuis_dir 'NuisanceROIAlt' int2str(fi) '.1D'], 'w+');
    end

    cd(['/home/sshankar/Categorization/Data/Imaging/' sub]);

    for sessId = 1:length(sessions)
        cd(['Session_' int2str(sessions(sessId)) '/NIFTIS/'])
        nuisFiles = dir('EPI*_1D.txt');
        
        % Define runs in ROI
        nuisFiles = nuisFiles(end-1:end);
        
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

    for fi = 1:6
        fclose(fids(fi));
    end
end