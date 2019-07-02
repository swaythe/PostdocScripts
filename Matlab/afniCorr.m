% subs = {'Sub11'};
% baseSess = 1;
% subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 1 2 1 1 1 1 1];
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub13'};
baseSess = [1 1 1 2 1 1 1 1];
% subs = {'Sub11','Sub13'};
% baseSess = [1 1];

roi_set= 'MEPosPositive.nii.gz';
folder_prefix = 'ME';
% coord_file = [folder_prefix 'PosCoord'];
main_dir = '/home/sshankar/Categorization/';
data_dir = [main_dir 'Data/Imaging/'];
roi_dir_postfix = ['ROI_3x3_005unc_' folder_prefix];
tc_dir_postfix = 'GLM_TC';

for si = 1:length(subs)
    sub = subs{si};
    roi_dir = [data_dir sub '/Session_' int2str(baseSess(si)) '/' roi_dir_postfix '/'];
    tc_dir = [data_dir sub '/Session_' int2str(baseSess(si)) '/' tc_dir_postfix '/'];
    cd(roi_dir)
%     load([sub '_' coord_file])
%     nROI = size(top_vox,1);
    
    for cdi = 1:20
        % Create correlation matrix and afni volume
        command = ['@ROI_Corr_Mat -zval -mat FULL -ts ' tc_dir 'TC' int2str(cdi) '.nii.gz -roi ' sub roi_set ' -prefix corrTC' int2str(cdi)];
        system(command)
        
        % Modify the correlation file and save as .mat file
        ccFile = ['corrTC' int2str(cdi) '.corr.1D'];
        fid = fopen(ccFile,'r');
        txt = textscan(fid,'%s','Delimiter','\n');
        fclose(fid);
        txt = txt{1};
        
        if cdi == 1
            nROI = length(txt) - 1;
            ccAfni = zeros(4,5,nROI,nROI);
            zvAfni = zeros(4,5,nROI,nROI);
        end
 
        for ti = 2:length(txt)
            temp = textscan(txt{ti},'%f','Delimiter',' ');
            temp = temp{1};
            ccAfni(floor((cdi-1)/5)+1,mod(cdi-1,5)+1,ti-1,:) = temp(~isnan(temp));
        end
        
        % Repeat the above steps for the z-value file
        zvFile = ['corrTC' int2str(cdi) '.zval.1D'];
        fid = fopen(zvFile,'r');
        txt = textscan(fid,'%s','Delimiter','\n');
        fclose(fid);
        txt = txt{1};
        
        for ti = 2:length(txt)
            temp = textscan(txt{ti},'%f','Delimiter','\t');
            zvAfni(floor((cdi-1)/5)+1,mod(cdi-1,5)+1,ti-1,:) = temp{1};
        end
    end
    save([sub '_CZAfni'], 'ccAfni', 'zvAfni');
end
