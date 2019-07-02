% % 12 channel data
cd ('/home/sshankar/Categorization/Data/Imaging/Pilots/Sub03_12ch')

% % mprage
% cd('t1_mprage')
% system('to3d -anat -datum float -prefix anat.nii.gz *.dcm')
% cd ..

% EPI_0_Rest1
cd('EPI_0_Rest1')
system('to3d -epan -assume_dicom_mosaic -datum float -time:zt 24 325 1370 alt+z2 -prefix EPI0_Rest1.nii.gz *.dcm')
system('mv *.nii.gz ../../Niftis/')
cd ..

% % EPI_1_Rest1 and Rest2
% cd('EPI_1_Rest1')
% system('to3d -epan -assume_dicom_mosaic -datum float -time:zt 32 100 1800 seq-z -prefix EPI1_Rest1.nii.gz *.dcm')
% system('mv *.nii.gz ../Niftis/')
% cd ..
% cd('EPI_1_Rest2')
% system('to3d -epan -assume_dicom_mosaic -datum float -time:zt 32 100 1800 seq-z -prefix EPI1_Rest2.nii.gz *.dcm')
% system('mv *.nii.gz ../Niftis/')
% cd ..

% % EPI_2_Rest1 and Rest2
% cd('EPI_2_Rest1')
% to3d -epan -assume_dicom_mosaic -datum float -time:zt 31 120 1500 seq-z -prefix EPI2_Rest1.nii.gz *.dcm
% system('mv *.nii.gz ../Niftis/')
% cd ..
% cd('EPI_2_Rest2')
% to3d -epan -assume_dicom_mosaic -datum float -time:zt 31 120 1500 seq-z -prefix EPI2_Rest2.nii.gz *.dcm
% system('mv *.nii.gz ../Niftis/')
% cd ..

% % 32 channel data
% cd ('/home/sshankar/Categorization/Data/Imaging/Pilots/Sub03_32ch')

% % mprage
% cd('t1_mprage')
% system('to3d -anat -datum float -prefix anat.nii.gz *.dcm')
% cd ..

% % EPI_3_Rest1 and Rest2
% cd('EPI_3_Rest1')
% system('to3d -epan -assume_dicom_mosaic -datum float -time:zt 64 160 1200 seq-z -prefix EPI3_Rest1.nii.gz *.dcm')
% system('mv *.nii.gz ../Niftis/')
% cd ..
% cd('EPI_3_Rest2')
% system('to3d -epan -assume_dicom_mosaic -datum float -time:zt 64 160 1200 seq-z -prefix EPI3_Rest2.nii.gz *.dcm')
% system('mv *.nii.gz ../Niftis/')
% cd ..


% % To create mean and std nii.gz files
cd('/home/sshankar/Categorization/Data/Imaging/Pilots/Niftis')

system('3dTstat -mean -prefix EPI0_Rest1_mean.nii.gz EPI0_Rest1.nii.gz')
system('3dTstat -stdev -prefix EPI0_Rest1_std.nii.gz EPI0_Rest1.nii.gz')

% system('3dTstat -mean -prefix EPI1_Rest1_mean.nii.gz EPI1_Rest1.nii.gz')
% system('3dTstat -stdev -prefix EPI1_Rest1_std.nii.gz EPI1_Rest1.nii.gz')

% system('3dTstat -mean -prefix EPI1_Rest2_mean.nii.gz EPI1_Rest2.nii.gz')
% system('3dTstat -stdev -prefix EPI1_Rest2_std.nii.gz EPI1_Rest2.nii.gz')

% system('3dTstat -mean -prefix EPI2_Rest1_mean.nii.gz EPI2_Rest1.nii.gz')
% system('3dTstat -stdev -prefix EPI2_Rest1_std.nii.gz EPI2_Rest1.nii.gz')
% 
% system('3dTstat -mean -prefix EPI2_Rest2_mean.nii.gz EPI2_Rest2.nii.gz')
% system('3dTstat -stdev -prefix EPI2_Rest2_std.nii.gz EPI2_Rest2.nii.gz')

% system('3dTstat -mean -prefix EPI3_Rest1_mean.nii.gz EPI3_Rest1.nii.gz')
% system('3dTstat -stdev -prefix EPI3_Rest1_std.nii.gz EPI3_Rest1.nii.gz')
% 
% system('3dTstat -mean -prefix EPI3_Rest2_mean.nii.gz EPI3_Rest2.nii.gz')
% system('3dTstat -stdev -prefix EPI3_Rest2_std.nii.gz EPI3_Rest2.nii.gz')

% % To create tSNR (mean/std)
system('3dcalc -a EPI0_Rest1_mean.nii.gz -b EPI0_Rest1_std.nii.gz -expr a/b -prefix EPI0_Rest1_tsnr.nii.gz')
% system('3dcalc -a EPI1_Rest1_mean.nii.gz -b EPI1_Rest1_std.nii.gz -expr a/b -prefix EPI1_Rest1_tsnr.nii.gz')
% system('3dcalc -a EPI1_Rest2_mean.nii.gz -b EPI1_Rest2_std.nii.gz -expr a/b -prefix EPI1_Rest2_tsnr.nii.gz')
% system('3dcalc -a EPI2_Rest1_mean.nii.gz -b EPI2_Rest1_std.nii.gz -expr a/b -prefix EPI2_Rest1_tsnr.nii.gz')
% system('3dcalc -a EPI2_Rest2_mean.nii.gz -b EPI2_Rest2_std.nii.gz -expr a/b -prefix EPI2_Rest2_tsnr.nii.gz')
% system('3dcalc -a EPI3_Rest1_mean.nii.gz -b EPI3_Rest1_std.nii.gz -expr a/b -prefix EPI3_Rest1_tsnr.nii.gz')
% system('3dcalc -a EPI3_Rest2_mean.nii.gz -b EPI3_Rest2_std.nii.gz -expr a/b -prefix EPI3_Rest2_tsnr.nii.gz')

system('gunzip *mean*gz')
system('gunzip *std*gz')
system('gunzip *tsnr*gz')

% Plot figures

% % One tSNR per figure
% nii11 = load_untouch_nii('EPI1_Rest1_tsnr.nii');
% img11 = nii11.img;
% a = figure;
% for ai = 1:4
%     subplot(4,8,ai)
%     aimg = img11(:,:,ai);
%     pcolor(double(aimg/max(max(aimg))))
% end

% One slice of all tSNRs per figure
nii0 = load_untouch_nii('EPI0_Rest1_tsnr.nii');
img0 = nii0.img;
nii11 = load_untouch_nii('EPI1_Rest1_tsnr.nii');
img11 = nii11.img;
nii12 = load_untouch_nii('EPI1_Rest2_tsnr.nii');
img12 = nii12.img;
nii21 = load_untouch_nii('EPI2_Rest1_tsnr.nii');
img21 = nii21.img;
nii22 = load_untouch_nii('EPI2_Rest2_tsnr.nii');
img22 = nii22.img;
nii31 = load_untouch_nii('EPI3_Rest1_tsnr.nii');
img31 = nii31.img;
nii32 = load_untouch_nii('EPI3_Rest2_tsnr.nii');
img32 = nii32.img;

% nimg0 = zeros(size(img0));
% nimg11 = zeros(size(img11));
% nimg12 = zeros(size(img12));
% nimg21 = zeros(size(img21));
% nimg22 = zeros(size(img22));
% nimg31 = zeros(size(img31));
% nimg32 = zeros(size(img32));
% 
% for i = 1:24
%     img = img0(:,:,i);
%     nimg0(:,:,i) = double(img/max(max(img))); % / (96*96) / 3.5);
% end
% for i = 1:32
%     img = img11(:,:,i);
%     nimg11(:,:,i) = double(img/max(max(img))); % / (70*70) / 3);
%     img = img12(:,:,i);
%     nimg12(:,:,i) = double(img/max(max(img))); % / (70*70) / 3);
% end
% for i = 1:31
%     img = img21(:,:,i);
%     nimg21(:,:,i) = double(img/max(max(img))); % / (70*70) / 3);
%     img = img22(:,:,i);
%     nimg22(:,:,i) = double(img/max(max(img))); % / (70*70) / 3);
% end
% for i = 1:64
%     img = img31(:,:,i);
%     nimg31(:,:,i) = double(img/max(max(img))); % / (84*84) / 2.5);
%     img = img32(:,:,i);
%     nimg32(:,:,i) = double(img/max(max(img))); % / (84*84) / 2.5);
% end

% f = zeros(1,32);
% for i=1:32
%     f(i) = figure;
% end
% 
% for ai = 1:24
%     figure(ai)
%     subplot(2,2,1)
%     aimg = img0(:,:,ai);
%     pcolor(double(aimg)); %/max(max(aimg))))
% end
% 
% for ai = 1:32
%     figure(ai)
%     subplot(2,2,2)
%     aimg = (img11(:,:,ai) + img12(:,:,ai)) / 2.0;
%     pcolor(double(aimg)); %/max(max(aimg))))
% end
% 
% for ai = 1:31
%     figure(ai);
%     subplot(2,2,3)
%     aimg = (img21(:,:,ai) + img22(:,:,ai)) / 2.0;
%     pcolor(double(aimg)); %/max(max(aimg))))
% end
% 
% for ai = 1:32
%     figure(ai);
%     subplot(2,2,4)
%     aimg = (img31(:,:,ai*2) + img32(:,:,ai*2)) / 2.0;
%     pcolor(double(aimg)); %/max(max(aimg))))
% end

% Average raw tSNR values across two runs
s0 = mean(mean(img0));
s1 = mean([mean(mean(img11)), mean(mean(img12))]);
s2 = mean([mean(mean(img21)), mean(mean(img22))]);
s3 = mean([mean(mean(img31)), mean(mean(img32))]);
s0f = mean(mean(img0(1:48,:,:)));
s1f = mean([mean(mean(img11(1:35,:,:))), mean(mean(img12(1:35,:,:)))]);
s2f = mean([mean(mean(img21(1:35,:,:))), mean(mean(img22(1:35,:,:)))]);
s13 = mean([mean(mean(img31(1:42,:,:))), mean(mean(img32(1:42,:,:)))]);
s0b = mean(mean(img0(49:96,:,:)));
s1b = mean([mean(mean(img11(36:end,:,:))), mean(mean(img12(36:end,:,:)))]);
s2b = mean([mean(mean(img21(36:end,:,:))), mean(mean(img22(36:end,:,:)))]);
s3b = mean([mean(mean(img31(43:end,:,:))), mean(mean(img32(43:end,:,:)))]);

% Average normalized tSNR values across two runs
% ns0 = sum(sum(nimg0));
% ns1 = mean([sum(sum(nimg11)), sum(sum(nimg12))]);
% ns2 = mean([sum(sum(nimg21)), sum(sum(nimg22))]);
% ns3 = mean([sum(sum(nimg31)), sum(sum(nimg32))]);
% ns0f = sum(sum(nimg0(1:48,:,:)));
% ns1f = mean([sum(sum(nimg11(1:35,:,:))), sum(sum(nimg12(1:35,:,:)))]);
% ns2f = mean([sum(sum(nimg21(1:35,:,:))), sum(sum(nimg22(1:35,:,:)))]);
% ns3f = mean([sum(sum(nimg31(1:42,:,:))), sum(sum(nimg32(1:42,:,:)))]);
% ns0b = sum(sum(nimg0(49:end,:,:)));
% ns1b = mean([sum(sum(nimg11(36:end,:,:))), sum(sum(nimg12(36:end,:,:)))]);
% ns2b = mean([sum(sum(nimg21(36:end,:,:))), sum(sum(nimg22(36:end,:,:)))]);
% ns3b = mean([sum(sum(nimg31(43:end,:,:))), sum(sum(nimg32(43:end,:,:)))]);

mean0 = load_untouch_nii('EPI0_Rest1_mean.nii');
mimg0 = mean0.img;
mean11 = load_untouch_nii('EPI1_Rest1_mean.nii');
mimg11 = mean11.img;
mean12 = load_untouch_nii('EPI1_Rest2_mean.nii');
mimg12 = mean12.img;
mean21 = load_untouch_nii('EPI2_Rest1_mean.nii');
mimg21 = mean21.img;
mean22 = load_untouch_nii('EPI2_Rest2_mean.nii');
mimg22 = mean22.img;
mean31 = load_untouch_nii('EPI3_Rest1_mean.nii');
mimg31 = mean31.img;
mean32 = load_untouch_nii('EPI3_Rest2_mean.nii');
mimg32 = mean32.img;

std0 = load_untouch_nii('EPI0_Rest1_std.nii');
simg0 = std0.img;
std11 = load_untouch_nii('EPI1_Rest1_std.nii');
simg11 = std11.img;
std12 = load_untouch_nii('EPI1_Rest2_std.nii');
simg12 = std12.img;
std21 = load_untouch_nii('EPI2_Rest1_std.nii');
simg21 = std21.img;
std22 = load_untouch_nii('EPI2_Rest2_std.nii');
simg22 = std22.img;
std31 = load_untouch_nii('EPI3_Rest1_std.nii');
simg31 = std31.img;
std32 = load_untouch_nii('EPI3_Rest2_std.nii');
simg32 = std32.img;

% nmimg0 = zeros(size(mimg0));
% nmimg11 = zeros(size(mimg11));
% nmimg12 = zeros(size(mimg12));
% nmimg21 = zeros(size(mimg21));
% nmimg22 = zeros(size(mimg22));
% nmimg31 = zeros(size(mimg31));
% nmimg32 = zeros(size(mimg32));
% 
% nsimg0 = zeros(size(simg0));
% nsimg11 = zeros(size(simg11));
% nsimg12 = zeros(size(simg12));
% nsimg21 = zeros(size(simg21));
% nsimg22 = zeros(size(simg22));
% nsimg31 = zeros(size(simg31));
% nsimg32 = zeros(size(simg32));
% 
% for i = 1:24
%     img = mimg0(:,:,i);
%     nmimg0(:,:,i) = double(img/max(max(img)) / 3.5); %(96*96) / 3.5);
%     img = simg0(:,:,i);
%     nsimg0(:,:,i) = double(img/max(max(img))); % / (96*96));
% end
% for i = 1:32
%     img = mimg11(:,:,i);
%     nmimg11(:,:,i) = double(img/max(max(img)) / 3); %(70*70) / 3);
%     img = mimg12(:,:,i);
%     nmimg12(:,:,i) = double(img/max(max(img)) / 3); %(70*70) / 3);
%     img = simg11(:,:,i);
%     nsimg11(:,:,i) = double(img/max(max(img))); % / (70*70));
%     img = simg12(:,:,i);
%     nsimg12(:,:,i) = double(img/max(max(img))); % / (70*70));
% end
% for i = 1:31
%     img = mimg21(:,:,i);
%     nmimg21(:,:,i) = double(img/max(max(img)) / 3); %(70*70) / 3);
%     img = mimg22(:,:,i);
%     nmimg22(:,:,i) = double(img/max(max(img)) / 3); %(70*70) / 3);
%     img = simg21(:,:,i);
%     nsimg21(:,:,i) = double(img/max(max(img))); % / (70*70));
%     img = simg22(:,:,i);
%     nsimg22(:,:,i) = double(img/max(max(img))); % / (70*70));
% end
% for i = 1:64
%     img = mimg31(:,:,i);
%     nmimg31(:,:,i) = double(img/max(max(img)) / 2.5); %(84*84) / 2.5);
%     img = mimg32(:,:,i);
%     nmimg32(:,:,i) = double(img/max(max(img)) / 2.5); %(84*84) / 2.5);
%     img = simg31(:,:,i);
%     nsimg31(:,:,i) = double(img/max(max(img))); % / (84*84));
%     img = simg32(:,:,i);
%     nsimg32(:,:,i) = double(img/max(max(img))); % / (84*84));
% end

% Average raw mean values across two runs
ms0 = mean(mean(mimg0));
ms1 = mean([mean(mean(mimg11)), mean(mean(mimg12))]);
ms2 = mean([mean(mean(mimg21)), mean(mean(mimg22))]);
ms3 = mean([mean(mean(mimg31)), mean(mean(mimg32))]);
ms0f = mean(mean(mimg0(1:48,:,:)));
ms1f = mean([mean(mean(mimg11(1:35,:,:))), mean(mean(mimg12(1:35,:,:)))]);
ms2f = mean([mean(mean(mimg21(1:35,:,:))), mean(mean(mimg22(1:35,:,:)))]);
ms3f = mean([mean(mean(mimg31(1:42,:,:))), mean(mean(mimg32(1:42,:,:)))]);
ms0b = mean(mean(mimg0(49:end,:,:)));
ms1b = mean([mean(mean(mimg11(36:end,:,:))), mean(mean(mimg12(36:end,:,:)))]);
ms2b = mean([mean(mean(mimg21(36:end,:,:))), mean(mean(mimg22(36:end,:,:)))]);
ms3b = mean([mean(mean(mimg31(43:end,:,:))), mean(mean(mimg32(43:end,:,:)))]);

% % Average normalized mean values across two runs
% nms0 = sum(sum(nmimg0));
% nms1 = mean([sum(sum(nmimg11)), sum(sum(nmimg12))]);
% nms2 = mean([sum(sum(nmimg21)), sum(sum(nmimg22))]);
% nms3 = mean([sum(sum(nmimg31)), sum(sum(nmimg32))]);
% nms0f = sum(sum(nmimg0(1:48,:,:)));
% nms1f = mean([sum(sum(nmimg11(1:35,:,:))), sum(sum(nmimg12(1:35,:,:)))]);
% nms2f = mean([sum(sum(nmimg21(1:35,:,:))), sum(sum(nmimg22(1:35,:,:)))]);
% nms3f = mean([sum(sum(nmimg31(1:42,:,:))), sum(sum(nmimg32(1:42,:,:)))]);
% nms0b = sum(sum(nmimg0(49:end,:,:)));
% nms1b = mean([sum(sum(nmimg11(36:end,:,:))), sum(sum(nmimg12(36:end,:,:)))]);
% nms2b = mean([sum(sum(nmimg21(36:end,:,:))), sum(sum(nmimg22(36:end,:,:)))]);
% nms3b = mean([sum(sum(nmimg31(43:end,:,:))), sum(sum(nmimg32(43:end,:,:)))]);

% Average raw std values across two runs
ss0 = mean(mean(simg0));
ss1 = mean([mean(mean(simg11)), mean(mean(simg12))]);
ss2 = mean([mean(mean(simg21)), mean(mean(simg22))]);
ss3 = mean([mean(mean(simg31)), mean(mean(simg32))]);
ss0f = mean(mean(simg0(1:48,:,:)));
ss1f = mean([mean(mean(simg11(1:35,:,:))), mean(mean(simg12(1:35,:,:)))]);
ss2f = mean([mean(mean(simg21(1:35,:,:))), mean(mean(simg22(1:35,:,:)))]);
ss3f = mean([mean(mean(simg31(1:42,:,:))), mean(mean(simg32(1:42,:,:)))]);
ss0b = mean(mean(simg0(49:end,:,:)));
ss1b = mean([mean(mean(simg11(36:end,:,:))), mean(mean(simg12(36:end,:,:)))]);
ss2b = mean([mean(mean(simg21(36:end,:,:))), mean(mean(simg22(36:end,:,:)))]);
ss3b = mean([mean(mean(simg31(43:end,:,:))), mean(mean(simg32(43:end,:,:)))]);

% % Average normalized std values across two runs
% nss0 = sum(sum(nsimg0));
% nss1 = mean([sum(sum(nsimg11)), sum(sum(nsimg12))]);
% nss2 = mean([sum(sum(nsimg21)), sum(sum(nsimg22))]);
% nss3 = mean([sum(sum(nsimg31)), sum(sum(nsimg32))]);
% nss0f = sum(sum(nsimg0(1:48,:,:)));
% nss1f = mean([sum(sum(nsimg11(1:35,:,:))), sum(sum(nsimg12(1:35,:,:)))]);
% nss2f = mean([sum(sum(nsimg21(1:35,:,:))), sum(sum(nsimg22(1:35,:,:)))]);
% nss3f = mean([sum(sum(nsimg31(1:42,:,:))), sum(sum(nsimg32(1:42,:,:)))]);
% nss0b = sum(sum(nsimg0(49:end,:,:)));
% nss1b = mean([sum(sum(nsimg11(36:end,:,:))), sum(sum(nsimg12(36:end,:,:)))]);
% nss2b = mean([sum(sum(nsimg21(36:end,:,:))), sum(sum(nsimg22(36:end,:,:)))]);
% nss3b = mean([sum(sum(nsimg31(43:end,:,:))), sum(sum(nsimg32(43:end,:,:)))]);
