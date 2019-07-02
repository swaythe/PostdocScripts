main_dir = '/home/sshankar/Categorization/Data/Imaging/All/';
coord_dir = [main_dir 'ROI_3x3_005unc_ParamSplit'];
cd(coord_dir)

coord_file = dir('*.txt');
for ci = 1:length(coord_file)
    ctr = 0;
    fid = fopen(coord_file(ci).name,'r');
    txt = textscan(fid,'%s','Delimiter','\n');
    txt = txt{1};
    op_txt = cell(length(txt),1);
    
    for li = 1:length(txt)
        ln = txt{li};
        if length(ln)>2 && strcmp(ln(1),'(')==1 && strcmp(ln(2),' ')==1
            if ctr == 0 
                ctr = 1; 
            else
                ctr = ctr + 1;
            end
            op_txt{li} = [num2str(ctr) '. ' ln];
        else
            op_txt{li} = ln;
        end
    end
    fclose(fid);
    
    fid = fopen(coord_file(ci).name,'w');
    for li = 1:length(txt)
        fprintf(fid,'%s\n',op_txt{li});
    end
    fclose(fid);
end