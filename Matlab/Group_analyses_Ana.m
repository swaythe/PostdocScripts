main_dir = '/home/anavarro/ErrorAwareness/data/';
aver_dir = '/home/anavarro/ErrorAwareness/group_analyses/';
template_dir =  '/home/anavarro/ErrorAwareness/Templates/';
mni_small_template = [template_dir 'MNI-small.nii.gz'];
unix(['mkdir ' aver_dir]);

%Indicate only the subject numbers to include
Aw = {'sub101','sub103','sub105','sub106','sub108','sub109','sub110','sub111','sub112','sub113','sub115','sub116','sub117','sub118'};


Unaw = {'sub101','sub105','sub110','sub111','sub112','sub113','sub115','sub118'};


TTEST = 0;%Ttest across subjects (Using coefficients from GLM)
ROIS_ANA = 1;%Multiply the masks (with ROI) by condition for each subject and then calculates ttest for chosen condition (voxel by voxel) and also calculates the average of all the voxels 
MAXIMA = 0; %Creates file with ROIs choosing the voxels with Maxima values
AVERAGE = 0;
SIG_ROIS_SUBTRACT= 0; %%Subtract significant ROIs in two conditions 
TTESTCOND=0;
CONTRASTS = 0;
REG = 0;
CORR =0;
CORR_DIFF=0;
CORR_D= 0; 

if TTEST || ROIS_ANA
    disp(' ')
    disp('There are two groups of subjects. I.e. if you are working with the aware condition only,');
    disp('you may want to use the "Aw" group because there are more subjects available for this condition');
    disp(' ');
    group=input('What group of subjects are you using? Type Aw or Unaw (type any if you do not need a group): ');
    disp(' ');

    if all(ismember(group,Aw))
       last_set = {55,55,65,55,55,55,65,55,65,55,55,55,55,55}; 
    else
       last_set = {55,65,65,55,65,55,55,55};
    end
    subj_ids=group;

    nsub = length(subj_ids);
end


%icond=0;
cond_names={'main','odd-freq','aw-corr','unaw-corr','aw-unaw','aw_stim','corr_stim','aw_resp2'};
cond_set={14,11,8,5,2,29,34,49};

if TTEST || ROIS_ANA
 cond_name = input('Choose a contrast from the list -or type any if it does not apply- (main,odd-freq,aw-corr,unaw-corr,aw-unaw,aw_stim,corr_stim,aw_resp2):','s');
 
    for i=1:length(cond_names)
       if strcmp(cond_name,cond_names{i})
         icond = i;
       end
    end
     for isub=1:length(subj_ids)
      condit{isub} =int2str(last_set{isub}-cond_set{icond});
     end
end


if TTEST %%Ttest across subjects (Using coefficients from GLM)
     delete_all_prefix = 'n';
     delete_all_norm = 'n';

      command_ttest = ['3dttest -session ' aver_dir  ' -prefix ' cond_name ' -datum short'];
      command_ttest = [command_ttest ' -base1 0 -set2 '];
    for isub= 1:nsub
         cond_num = condit{isub};
         prefix = [cond_name '+tlrc.BRIK']; 
         %prefix = ['aw_stim-corr_stim+tlrc.BRIK'];
         prefix_file = ([aver_dir  prefix]); 

        if exist(prefix_file) >= 1
            disp(['THE FILE ', prefix, ' EXIST']);
                delete_prefix = input('  Delete file (y/n) ?  ','s');
            if delete_prefix == 'y'
                unix(['rm ' prefix_file]);
                unix(['rm ' aver_dir cond_name '+tlrc.HEAD']);
            end
        end

        anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
        align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
        fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz']; 

        glm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz' '[' cond_num ']'];
        %glm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_aw_stim-corr_stim_GLM.nii.gz'];
        norm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM_MNI.nii.gz'];    

        if delete_all_norm == 'y'
             unix(['rm ' norm_name]);
        end
        if exist(norm_name) >= 1
            disp(['THE FILE ', norm_name, ' EXIST']);
            delete_norm = input('  Delete file (y/n) ?  ','s');
            delete_all_norm = input('  Delete files for all other subjects (y/n) ?  ','s');
        if delete_norm == 'y'
            unix(['rm ' norm_name]);
        end
        end

        %NORMALIZE EPI
        command_resamp = ['3dresample -prefix ' norm_name  ' -dxyz 3 3 3 -master '...
           align_epi_anat ' -inset ' glm_name ' '];
        unix(command_resamp);

        command_norm = ['applywarp --ref=' mni_small_template  ' --in=' norm_name ...
      ' --warp=' fnirt_file ' --out=' norm_name];
        unix(command_norm);
        command_ttest = [command_ttest norm_name ' '];
    end
   unix(command_ttest);
end
 

if ROIS_ANA
     ROI_file_name =input('File name for the ROI file to use (i.e. LCing_ROI): ','s');
     for isub=1:nsub
       anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
       ROIS_file = [main_dir subj_ids{isub} '/ROIs/' subj_ids{isub} '_' ROI_file_name '-Mask'];          

       %Multiply the masks (with ROI) by condition for each subject
       cond_num = condit{isub};
           
       %input_mask = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz[' cond_num ']'];
       input_mask = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_aw_stim-corr_stim_GLM.nii.gz'];
       output_calc = [main_dir subj_ids{isub} '/ROIs/' subj_ids{isub} '_' cond_name ];
       unix(['rm ' output_calc '.nii.gz']);
       command_calc = ['3dcalc -a ' ROIS_file '.nii.gz -b ' input_mask ...
                        ' -expr a*b -prefix ' output_calc '.nii.gz'];
       unix(command_calc);
     end
     delete_all_norm = 'n';
     
     aver_sess=[aver_dir 'ROI_ANA/' 'aver_' ROI_file_name '_' cond_name '.txt']; 
     fid = fopen(aver_sess, 'w');
     command_ttest = ['3dttest -session ' aver_dir  ' -prefix ' [cond_name '_' ROI_file_name] ' -datum short -base1 0 -set2 '];
     for isub=1:nsub
        input_mask = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz[' cond_num ']'];
        input_mask = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_aw_stim-corr_stim_GLM.nii.gz'];
        cond_file = [main_dir subj_ids{isub} '/ROIs/' subj_ids{isub} '_' cond_name];
        anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
        norm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM_MNI.nii.gz']; 
        align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
        fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz']; 
        ROIS_file = [main_dir subj_ids{isub} '/ROIs/' subj_ids{isub} '_' ROI_file_name '-Mask'];  
        if delete_all_norm == 'y'
           unix(['rm ' norm_name]);
        end
        if exist(norm_name) >= 1
            disp(['THE FILE ', norm_name, ' EXIST']);
            delete_norm = input('  Delete file (y/n) ?  ','s');
            delete_all_norm = input('  Delete files for all other subjects (y/n) ?  ','s');
        if delete_norm == 'y'
            unix(['rm ' norm_name]);
        end
        end
        %NORMALIZE EPI
         command_resamp = ['3dresample -prefix ' norm_name  ' -dxyz 3 3 3 -master '...
         align_epi_anat ' -inset ' cond_file '.nii.gz '];
        unix(command_resamp);

        command_norm = ['applywarp --ref=' mni_small_template  ' --in=' norm_name ...
      ' --warp=' fnirt_file ' --out=' norm_name];
        unix(command_norm);
        command_ttest = [command_ttest  norm_name ' '];
      
         maskave_output=[aver_dir 'ROI_ANA/' subj_ids{isub} '_' ROI_file_name '.txt'];
         command_maskave = ['3dmaskave -quiet -mask ' ROIS_file '.nii.gz ' input_mask ' >' maskave_output];
         unix(command_maskave);
         
         aver = load([aver_dir 'ROI_ANA/' subj_ids{isub} '_' ROI_file_name '.txt']);     
         count=fprintf(fid, '%-5.4f  ', aver);
         count=fprintf(fid, '\n');
     end
     unix(command_ttest);

     fclose(fid);
end

if MAXIMA
    %Creates file with ROIs for max values 
    display(' ');
    max_input=input('What is the name of the input file?:','s');
    display(' ');
    threshold=input('What threshold do you want to use?:','s');
    display(' ');
    maxima_file = [aver_dir '3dMax_' max_input '.nii.gz'];
    unix (['rm ' maxima_file]);
    voxels=input('How many voxels of radius do you want to use?:','s');
    command_max= ['3dmaxima -input ' [aver_dir max_input] '+tlrc[1]' ' -spheres_1 -thresh ' threshold ' -out_rad ' voxels ' -prefix ' maxima_file ];%add -neg_ext for neg values % MAIN=3.262 (p=.01) // dont=3.21 // w=3.39
    unix(command_max); 
end
 

if CORR_D %correlation of ICR (sess1-sess2) and want-ctr (sess1-sess2)
        for isub = 1:nsub
           command = '3dcalc ';
           expr = ['"("'];
          for icond = 1:2
            alphabet=('a':'z');
            glm_file = dir([main_dir subj_ids{isub} '/GLM/*GLM.nii*']);
            if icond ==1
             glm_name = [main_dir subj_ids{isub} '/GLM/' glm_file.name '[55]']; %% Coef.; Main: 37
            else
             glm_name = [main_dir subj_ids{isub} '/GLM/' glm_file.name '[61]'];
            end
            output_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_' int2str(icond) '_GLM_MNI.nii.gz'];         

            anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
            align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
            fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz'];            
            
            %Normalize EPI
            unix(['rm ' output_name]);
        
            command_resample = ['3dresample -prefix ' output_name  ' -dxyz 3 3 3 -master '...
               align_epi_anat ' -inset ' glm_name ' '];
            unix(command_resample);


            command_warp = ['applywarp --ref=' mni_small_template  ' --in=' output_name ...
          ' --warp=' fnirt_file ' --out=' output_name];
            unix(command_warp);


            command = [command '-' alphabet(icond) ' '];
            command = [command output_name ' '];
            if icond == 2
                expr = [expr alphabet(icond) '")"' ];
            else
                expr = [expr alphabet(icond) '-'];
            end
          end 
      command = [command '-expr ' expr ' -prefix ' subj_ids{isub} '_want-ctr_sess1-sess2' ' -session ' main_dir subj_ids{isub} '/GLM/' ' -datum short '];     
      unix(command) 
      %unix(['rm ' main_dir subj_ids{isub} '/GLM/'  subj_ids{isub} '_want-ctr_sess1-sess2+tlrc.BRIK']);
      %unix(['rm ' main_dir subj_ids{isub} '/GLM/'  subj_ids{isub} '_want-ctr_sess1-sess2+tlrc.HEAD']);
    end
        
        command_ttest = '3dttest++ -setA ';
        for isub = 1:nsub
            %in_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_want-ctr_sess1-sess2'];
            ttest_input = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_want-ctr_sess1-sess2+tlrc']; 
            command_ttest = [command_ttest ' ' ttest_input ' '];
        end
        command_ttest = [command_ttest '-covariates ' aver_dir 'CovaFile_w-c_s1-s2.txt '];
        command_ttest = [command_ttest '-center DIFF '];
        prefix_name = ['CORRE_ICR_s1-s2_2.nii.gz '];
        command_ttest = [command_ttest '-prefix ' aver_dir prefix_name];
        unix(command_ttest);
end

if AVERAGE %%% Average across subjects (Using coefficients from GLM)
    command = '3dcalc ';
    expr = ['"("'];
        for isub = 1:nsub
            %alphabet = char('a'+(1:26)-1)';
            alphabet=('a':'z');
            glm_file = dir([main_dir subj_ids{isub} '/GLM/*GLM.nii*']);
            glm_name = [main_dir subj_ids{isub} '/GLM/' glm_file.name '[' cond_num ']']; %% Coef.; Main: 56; odd-freq: 59
            output_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM_MNI.nii.gz'];         

            anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
            align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
            fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz'];            
            
            %Normalize EPI
            unix(['rm ' output_name]);
        
            command_resample = ['3dresample -prefix ' output_name  ' -dxyz 3 3 3 -master '...
               align_epi_anat ' -inset ' glm_name ' ']; %%% WHEN BOTH -master AND -dxyz ARE USED -dxyz OVERWRITES -master
%             command_resample = ['3dresample -prefix ' output_name  ' -dxyz 3 3 3 '...
%              ' -inset ' glm_name ' '];
            unix(command_resample);


            command_warp = ['applywarp --ref=' mni_small_template  ' --in=' output_name ...
          ' --warp=' fnirt_file ' --out=' output_name];
            unix(command_warp);


            command = [command '-' alphabet(isub) ' '];
            command = [command output_name ' '];
            if isub == nsub
                expr = [expr alphabet(isub) '")/"' int2str(nsub)];
            else
                expr = [expr alphabet(isub) '+'];
            end
        end 
    command = [command '-expr ' expr ' -prefix ' 'subj_aver_' cond_name  ' -session ' aver_dir ' -datum short '];
     unix(command)
end




if SIG_ROIS_SUBTRACT %%Subtract significant ROIs in two conditions 
     condition_1='aw-corr';
     condition_2='odd-freq';
     t_value = '4.5';
     
     cond_1=[aver_dir condition_1 '+tlrc.BRIK'];   
     cond_2=[aver_dir condition_2 '+tlrc.BRIK'];
     
     cond_calc_1 = [aver_dir condition_1 '_mask'];
     cond_calc_2 = [aver_dir condition_2 '_mask'];

     command_calc1 = ['3dcalc -a ' cond_1  ' -expr  1*ispositive"("a-' t_value '")" -prefix ' cond_calc_1 ];
     unix(command_calc1);
     command_calc2 = ['3dcalc -a ' cond_2  ' -expr  2*ispositive"("a-' t_value '")" -prefix ' cond_calc_2 ];
     unix(command_calc2);
     command_calc3 = ['3dcalc -a ' cond_calc_1 '+tlrc.BRIK -b ' cond_calc_2 '+tlrc.BRIK -expr  a+b -prefix ' [aver_dir condition_1 '+' condition_2] ];
     unix(command_calc3);
end

% T-Test - conditions
if TTESTCOND
     command = ['3dttest -session ' aver_dir  ' -prefix ' 'Ttest_sess1-sess2_w-c -datum short -paired '];
     ncond=2;
    for icond=1:ncond

         command = [command  ' -set' int2str(icond) ' '];
        for isub= 1:nsub
            glm_file = dir([main_dir subj_ids{isub} '/GLM/*GLM.nii*']);
           if icond == 1
            glm_name = [main_dir subj_ids{isub} '/GLM/' glm_file.name '[61] '];
           else
            glm_name = [main_dir subj_ids{isub} '/GLM/' glm_file.name '[55] '];
           end
            output_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_' int2str(icond) '_GLM_MNI.nii.gz'];         
            unix(['rm ' output_name]);
            anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
            align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
            fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz'];            
            %Normalize EPI
            command2 = ['3dresample -prefix ' output_name  ' -dxyz 3 3 3 -master '...
               align_epi_anat ' -inset ' glm_name ' '];
            unix(command2);

            command2 = ['applywarp --ref=' mni_small_template  ' --in=' output_name ...
          ' --warp=' fnirt_file ' --out=' output_name];
            unix(command2);
            command = [command output_name ' '];
        end
    end
   unix(command);
end



if CONTRASTS % Group contrasts
    contrasts_dir = [aver_dir 'GroupContrasts/'];
    coef = {'21','23','48','50'};%{'7','16','1','10','52','58'}; %% want_s1, want_s2, ctr_s1, ctr_s2, w-c_s1, w-c_s2
    cond = {'want_amt_1','want_time_1','want_amt_2','want_time_2'};%{'want_s1', 'want_s2', 'ctr_s1', 'ctr_s2', 'w-c_s1', 'w-c_s2'};
    ncoef = length(coef);

    for icoef=1:ncoef
        command_calc = '3dcalc ';
    expr = ['"("'];
        for isub = 1:nsub
            %alphabet = char('a'+(1:26)-1)';
            alphabet=('a':'z');
            glm_file = dir([main_dir subj_ids{isub} '/GLM/*GLM.nii*']);
            glm_name = [main_dir subj_ids{isub} '/GLM/' glm_file.name '[' coef{icoef} ']']; 
            output_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM_MNI.nii.gz'];         

            anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
            align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
            fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz'];            
            
            %Normalize EPI
            unix(['rm ' output_name]);
        
            command_resample = ['3dresample -prefix ' output_name  ' -dxyz 3 3 3 -master '...
               align_epi_anat ' -inset ' glm_name ' '];
            unix(command_resample);


            command_warp = ['applywarp --ref=' mni_small_template  ' --in=' output_name ...
          ' --warp=' fnirt_file ' --out=' output_name];
            unix(command_warp);


            command_calc = [command_calc '-' alphabet(isub) ' '];
            command_calc = [command_calc output_name ' '];
            if isub == nsub
                expr = [expr alphabet(isub) '")/"' int2str(nsub)];
            else
                expr = [expr alphabet(isub) '+'];
            end
        end 
    command_calc = [command_calc '-expr ' expr ' -prefix ' 'subj_aver_' cond{icoef} ' -session ' contrasts_dir ' -datum short '];
     unix(command_calc)
    end
    
% Ttests across subjects
  for icoef = 1:ncoef
     delete_all_prefix = 'n';
     delete_all_norm = 'n';

      condition= ['Ttest_' cond{icoef}];
      command_ttest = ['3dttest -session ' contrasts_dir  ' -prefix ' condition ' -datum short'];
      command_ttest = [command_ttest ' -base1 0 -set2 '];
    for isub= 1:nsub
         prefix = [condition '+tlrc.BRIK'];  
         prefix_file = ([contrasts_dir  prefix]); 

        if exist(prefix_file) >= 1
            disp(['THE FILE ', prefix, ' EXIST']);
                delete_prefix = input('  Delete file (y/n) ?  ','s');
            if delete_prefix == 'y'
                unix(['rm ' prefix_file]);
                unix(['rm ' contrasts_dir condition '+tlrc.HEAD']);
            end
        end

        anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
        align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
        fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz']; 

        glm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz' '[' coef{icoef} ']']; 
        norm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_1_GLM_MNI.nii.gz'];    

        if delete_all_norm == 'y'
             unix(['rm ' norm_name]);
        end
        if exist(norm_name) >= 1
            disp(['THE FILE ', norm_name, ' EXIST']);
            delete_norm = input('  Delete file (y/n) ?  ','s');
            delete_all_norm = input('  Delete files for all other subjects (y/n) ?  ','s');
        if delete_norm == 'y'
            unix(['rm ' norm_name]);
        end
        end

        %NORMALIZE EPI
        command_resamp = ['3dresample -prefix ' norm_name  ' -dxyz 3 3 3 -master '...
           align_epi_anat ' -inset ' glm_name ' '];
        unix(command_resamp);

        command_norm = ['applywarp --ref=' mni_small_template  ' --in=' norm_name ...
      ' --warp=' fnirt_file ' --out=' norm_name];
        unix(command_norm);
        command_ttest = [command_ttest norm_name ' '];
    end
   unix(command_ttest);
  end
  

  
    sess1 = {'21','23'}; %{'7','1','53'}; %% want_s1, ctr_s1, w-c_s1
    sess2 = {'48', '50'}; %{'16','10','58'}; %% want_s2, ctr_s2, w-c_s2
    cond = {'want_amt_s1-s2', 'want_time_s1-s2'}; %{'want_s1-s2', 'ctr_s1-s2', 'w-c_s1-s2'};
    nttests = length(cond);
    for ittest=1:nttests
         delete_all_prefix = 'n';
         delete_all_norm = 'n';
         condition= ['Ttest_' cond{ittest}];
         command_ttest = ['3dttest -session ' contrasts_dir  ' -prefix ' condition ' -datum short' ' -paired '];
      for icond=1:2
         command_ttest = [command_ttest  ' -set' int2str(icond) ' '];
            for isub= 1:nsub
                 prefix = [condition '+tlrc.BRIK'];  
                 prefix_file = ([contrasts_dir  prefix]); 

                if exist(prefix_file) >= 1
                    disp(['THE FILE ', prefix, ' EXIST']);
                        delete_prefix = input('  Delete file (y/n) ?  ','s');
                    if delete_prefix == 'y'
                        unix(['rm ' prefix_file]);
                        unix(['rm ' contrasts_dir condition '+tlrc.HEAD']);
                    end
                 end
                anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
                align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
                fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz']; 

                glm_file = dir([main_dir subj_ids{isub} '/GLM/param/*GLM.nii*']);
                
               if icond ==1
                glm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz' '[' sess2{ittest} '] ']; 
               else
                glm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz' '[' sess1{ittest} '] ']; 
               end


                norm_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_' int2str(icond) '_GLM_MNI.nii.gz'];    
                    if delete_all_norm == 'y'
                         unix(['rm ' norm_name]);
                    end
                    if exist(norm_name) >= 1
                        disp(['THE FILE ', norm_name, ' EXIST']);
                        delete_norm = input('  Delete file (y/n) ?  ','s');
                        delete_all_norm = input('  Delete files for all other subjects (y/n) ?  ','s');
                    if delete_norm == 'y'
                        unix(['rm ' norm_name]);
                    end
                    end

                %NORMALIZE EPI
                command_resamp = ['3dresample -prefix ' norm_name  ' -dxyz 3 3 3 -master '...
                   align_epi_anat ' -inset ' glm_name ' '];
                unix(command_resamp);

                command_norm = ['applywarp --ref=' mni_small_template  ' --in=' norm_name ...
              ' --warp=' fnirt_file ' --out=' norm_name];
                unix(command_norm);
                command_ttest = [command_ttest norm_name ' '];
            end
        end
       unix(command_ttest);
    end

end




  command_convert = ['3dAFNItoNIFTI -prefix ' aver_dir 'CORR_ICR_w-c_s2_float.nii.gz -float '  aver_dir 'CORR_ICR_Future_w-c_s2.nii.gz[3] '];
   %unix(command_convert);
   command_convert = ['3dcalc -a ' aver_dir 'CORR_ICR_w-c_s2_float.nii.gz ' '-prefix ' aver_dir 'CORR_ICR_w-c_s2_short -datum short -expr "a"'];
   %unix(command_convert);


if REG
    %%% CORRELATION across subjects between normalized ROI and ICR values
    %%% (CovFileWant.txt)

             %unix(['rm ' aver_dir 'corr_*']);
        % for isess = 1:nsess
        isess=1;
             unix(['rm ' main_dir 'Scripts/*3dregana*' ]);
             command_corr = ['3dRegAna -rows 13 -cols 1 '];
%              aver_sess=[aver_dir 'aver_' int2str(isess) '.1D']; 
              var = load([aver_dir 'CovFile_prueba1.txt']);
%              fid = fopen(aver_sess, 'w');
             for isub = 1:13
                 corr_input = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_' int2str(isess) '.nii.gz']; 
                 corr_output = [aver_dir 'corr_' int2str(isess) '-ICR'];
                 command_corr = [command_corr ' -xydata ' num2str(var(isub,2)) ' ' corr_input ' '];
                 
%                  aver = load([aver_dir subj_ids{isub} '_sess' int2str(isess) '.txt']);
                 
%                  count=fprintf(fid, '%-5.4f  ', aver);
%                  count=fprintf(fid, '\n');
             end  
%                 fclose(fid);
                 command_corr= [command_corr ' -model 1 : 0 -bucket 0 ' corr_output ];
                 unix(command_corr);
%                  ICR = load([aver_dir 'CovWant_sess' int2str(isess) '.txt']);
%                  ICR_in = [aver_dir 'CovWant_sess' int2str(isess) '.1D'];
%                  fid = fopen(ICR_in, 'w');
                 for isub=1:nsub
%                      count=fprintf(fid, '%-5.4f  ',ICR(isub));
%                      count=fprintf(fid, '\n');
                 end
%                  fclose(fid);
%                  command_dot= ['1ddot ' ICR_in ' ' aver_sess ];
%                  unix(command_dot);
         %end
end

if CORR
    coef = {'7','16'}; %% w-c_s1 55, w-c_s2 61, w_s1: 7, w_s2: 16
    cond = {'1','2'};
    ncond = length(cond);
    for icond = 1:ncond
        command_ttest = '3dttest++ -setA ';
        text_file = [aver_dir 'CovFile_s' cond{icond} '.txt'];    
         fid = fopen(text_file,'w');
         fprintf(fid, 'subject\t');
         fprintf(fid, '%10s\t', columns{icond+1}); 
         fprintf(fid, 'BIS\t LOC\t future\n');
        for isub = 1:nsub
            in_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz[' coef{icond} ']'];
            ttest_input = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_' int2str(icond) '.nii.gz']; 
            unix(['rm ' ttest_input]);
            anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
            align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
            fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz'];   
            
            %Normalize EPI
            %command_mask = ['3dautomask -prefix ' ttest_input in_name];
            command_resample = ['3dresample -prefix ' ttest_input  ' -dxyz 3 3 3 -master '...
             align_epi_anat ' -inset ' in_name ' '];
            unix(command_resample);

            command_norm = ['applywarp --ref=' mni_small_template  ' --in=' ttest_input ...
            ' --warp=' fnirt_file ' --out=' ttest_input];
             unix(command_norm);
             

            command_ttest = [command_ttest ' ' ttest_input ' '];
             fprintf(fid,'%3sA_%1s\t', num2str(data(isub,1)),num2str(icond));
             fprintf(fid,'%1.4s\t', num2str(data(isub,icond+1)));
             fprintf(fid,'%1.4s\t', num2str(data(isub,4)));
             fprintf(fid,'%1.4s\t', num2str(data(isub,5)));
             fprintf(fid,'%1.4s\n', num2str(data(isub,6)));

        end
        fclose(fid);
        command_ttest = [command_ttest '-covariates ' aver_dir 'CovFile_s' cond{icond} '.txt '];
        %command_ttest = [command_ttest '-center DIFF '];
        prefix_name = ['CORR_icr-W_sess' cond{icond} '.nii.gz '];
        command_ttest = [command_ttest '-prefix ' aver_dir prefix_name];
        unix(command_ttest);
    end
    %clear command_ttest;
end

if CORR_DIFF
    coef = {'67'}; %% want_s1, want_s2, ctr_s1, ctr_s2, w-c_s1, w-c_s2
    cond = {'w-c_s1-s2'};
    ncond = length(cond);
    for icond = 1:ncond
        command_ttest = '3dttest++ -setA ';
        for isub = 1:nsub
            in_name = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_GLM.nii.gz[' coef{icond} ']'];
            ttest_input = [main_dir subj_ids{isub} '/GLM/' subj_ids{isub} '_' int2str(icond) '.nii.gz']; 
            unix(['rm ' ttest_input]);
            anat_dir = [main_dir subj_ids{isub} '/Anatomy/'];
            align_epi_anat = [anat_dir  subj_ids{isub} '_mprage_AlignEpi.nii.gz'];
            fnirt_file = [anat_dir subj_ids{isub} '_fnirt.nii.gz'];   
            
            %Normalize EPI
            %command_mask = ['3dautomask -prefix ' ttest_input in_name];
            command_resample = ['3dresample -prefix ' ttest_input  ' -dxyz 3 3 3 -master '...
             align_epi_anat ' -inset ' in_name ' '];
            unix(command_resample);

            command_norm = ['applywarp --ref=' mni_small_template  ' --in=' ttest_input ...
            ' --warp=' fnirt_file ' --out=' ttest_input];
             unix(command_norm);
             

            command_ttest = [command_ttest ' ' ttest_input ' '];
        end
        command_ttest = [command_ttest '-covariates ' aver_dir 'CovFile_' cond{icond} '.txt '];
        %command_ttest = [command_ttest '-center DIFF '];
        prefix_name = ['CORR_ICR_' cond{icond} '.nii.gz '];
        command_ttest = [command_ttest '-prefix ' aver_dir prefix_name];
        unix(command_ttest);
    end
end
clear all