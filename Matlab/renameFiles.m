main_dir = '/ace/old-ace/8tb/sshankar/Categorization/Data/'; 
subs = {'Sub01','Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
baseSess = [1 1 1 2 1 1 1 1 1];
% subs = {'Sub02','Sub04','Sub05','Sub06','Sub08','Sub10','Sub11','Sub13'};
% baseSess = [1 1 2 1 1 1 1 1];
% subs = {'Sub01'};
% baseSess = 1;
baseDir = 'MNI';

for si = 1:length(subs)
    cd([main_dir 'Imaging/' subs{si} '/Session_' int2str(baseSess(si)) '/' baseDir '/']);
%     cd([main_dir 'Behavior/Scanner/']);
%     cd([main_dir subs{si}]);
%     command = ['rename PositiveClusterCorr Positive *ClusterCorr*'];
%     system(command);
%     command = ['mv ' subs{si} '_betaMat.mat ' main_dir 'Imaging/' subs{si} '/Session_' int2str(baseSess(si)) '/' baseDir '/'];
%     system(command);
%     command = 'mkdir ROI_AnovaCorr_005corr';
%     system(command);
%     command = 'mv *ClusterCorr* ../ROI_AnovaCorr_005corr/';
%     system(command);
    command = 'rm *PEAbsDistMinusAbsCoh*.nii*';
    system(command);
%     command = 'rmdir *AnovaCorr_005corr';
%     system(command);
%     command = 'cp ../ROI_3x3_005/*BehavForTC* .';
%     system(command);
%     command = 'gunzip *ComboCD_MNI*.gz';
%     system(command);
%     for sess = 1:4
%         cd([main_dir 'Imaging/' subs{si} '/Session_' int2str(sess) '/' baseDir '/']);
%         command = 'gunzip *Smooth*nii.gz';
%         system(command);
%     end
%     command = 'gunzip *SingleTrial.nii.gz';
%     system(command);
end
