cd('/home/sshankar/Categorization/Data/Imaging/Sub02/Session_1/NIFTIS');

a = load_nii('EPI_Task_6.nii');
b = load_nii('EPI_Task_6_CoReg.nii');
c = load_nii('EPI_Task_6_Smooth.nii');
a = a.img;
b = b.img;
c = c.img;

xya = a(:,:,50);
xyb = b(:,:,50);
xyc = c(:,:,50);

figure
hold on
subplot(1,3,1)
pcolor(double(xya/max(max(xya))));
axis square
subplot(1,3,2)
pcolor(double(xyb/max(max(xyb))));
axis square
subplot(1,3,3)
pcolor(double(xyc/max(max(xyc))));
axis square