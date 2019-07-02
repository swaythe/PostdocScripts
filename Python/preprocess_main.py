from dipy.segment.mask import median_otsu
#import matplotlib.pyplot as plt
from preprocess import meanmask
#import nibabel as nib
#import numpy
import os

data_dir = 'C:\\Users\\Swetha The Mighty\\Documents\\Categorization\\Data\\Imaging\\'
nifti_dir = 'NIFTIS'
epi_file = 'EPI_Task1.nii.gz'

subs = [1,2,4,5,6,8,10,11,13]

for s in subs:
	if s < 10:
		sub = 'Sub0' + str(s)
	else:
		sub = 'Sub' + str(s)
	
	if s == 5:
		sess = 'Session_2'
	else:
		sess = 'Session_1'
	
	os.chdir(os.path.join(data_dir, sub, sess, nifti_dir))
	print(os.getcwd())
	
	meanmask(sub, epi_file)
	