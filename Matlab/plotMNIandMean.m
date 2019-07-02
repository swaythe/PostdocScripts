cd('/home/sshankar/Categorization/Data/Imaging/Sub02/Trials/Unzipped/');

% a = load_nii('EPI_Task1NormAnat.nii');
% b = load_nii('EPI_Task1NormMean.nii');
% c = load_nii('EPI_Task1NormVol3.nii');
d = load_nii('Sub02_NormGLMAnat.nii');
e = load_nii('Sub02_NormGLMMean.nii');
f = load_nii('Sub02_NormGLMVol3.nii');
g = load_nii('Sub02_GLM_Main.nii');
% d = load_nii('EPI_Task1NormSmoothAnat.nii');
% e = load_nii('EPI_Task1NormSmoothMean.nii');
% f = load_nii('EPI_Task1NormSmoothVol3.nii');
% d = load_nii('MNI-Brain.nii');
% e = load_nii('EPI_Task1_Vol3.nii');
% f = load_nii('Sub02_Task1Vol3Norm.nii');

% a = a.img;
% b = b.img;
% c = c.img;
d = d.img;
e = e.img;
f = f.img;
g = g.img;

% xya = a(:,:,50);
% xyb = b(:,:,50);
% xyc = c(:,:,50);
xyd = d(:,:,50);
xye = e(:,:,50);
xyf = f(:,:,50);
xyg = g(:,:,15);

figure
hold on
% subplot(2,3,1)
% pcolor(double(xya/max(max(xya))));
% axis square
% subplot(2,3,2)
% pcolor(double(xyb/max(max(xyb))));
% axis square
% subplot(2,3,3)
% pcolor(double(xyc/max(max(xyc))));
% axis square
subplot(2,2,1)
pcolor(double(xyd/max(max(xyd))));
axis square
subplot(2,2,2)
pcolor(double(xye/max(max(xye))));
axis square
subplot(2,2,3)
pcolor(double(xyf/max(max(xyf))));
axis square
subplot(2,2,4)
pcolor(double(xyg/max(max(xyg))));
axis square
