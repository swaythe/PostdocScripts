cd('/home/sshankar/Categorization/Data/Imaging/Sub02/Session_1/NIFTIS');

giant = load_nii('Sub02_mprage_Giant_AlignEpi.nii');
big = load_nii('Sub02_mprage_Big_AlignEpi.nii');
anat = load_nii('Sub02_mprage.nii');
giant = giant.img;
big = big.img;
anat = anat.img;

xya = anat(:,:,85);
xyb = big(:,:,70);
xyg = giant(:,:,30);

figure
hold on
subplot(1,3,1)
pcolor(double(xya/max(max(xya))));
axis square
subplot(1,3,2)
pcolor(double(xyb/max(max(xyb))));
axis square
subplot(1,3,3)
pcolor(double(xyg/max(max(xyg))));
axis([0 240 32 192]);
axis square