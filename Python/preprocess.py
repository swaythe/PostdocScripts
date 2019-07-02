from dipy.segment.mask import median_otsu
import nibabel as nib
import numpy

def meanmask(sub, fname):	
	from dipy.segment.mask import median_otsu
	import nibabel as nib
	import numpy

	img = nib.load(fname)
	task1 = img.get_data()
	
	# Calculate the image mean
	meanImg = task1.mean(axis=-1)
	mean_image = nib.Nifti1Image(meanImg, img.affine)
	nib.save(mean_image, sub + '_mean.nii')
	
	# Calculate the brain mask with defaults
	# mvol, maskImg = median_otsu(meanImg, 2, 1)
	# mask_image = nib.Nifti1Image(maskImg, img.affine)
	# nib.save(maskImg, sub + '_mask.nii')
	