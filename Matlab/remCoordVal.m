main_dir = '/home/sshankar/Categorization/Data/Imaging/All/';
coord_dir = [main_dir 'ROI_3x3_005unc_ParamSplit'];
cd(coord_dir)

coord_file = dir('Combined reduced');
for ci = 1:length(coord_file)
    ctr = 1;
    fid = fopen(coord_file(ci).name,'r');
    txt = textscan(fid,'%s','Delimiter','()');
    txt = txt{1};
    op_txt = cell(length(txt),1);
    
    for li = 2:3:length(txt)
        op_txt{ctr} = [txt{li} ' ' int2str(ctr)];
        ctr = ctr + 1;
    end
    fclose(fid);
    
    fid = fopen(coord_file(ci).name,'w');
    for li = 1:length(ctr)-1
        fprintf(fid,'%s\n',op_txt{li});
    end
    fclose(fid);
end