def my_mask(mean_volume, reference_volume=None, m=0.45, M=0.95, cc=True, opening=2, exclude_zeros=False):
	import numpy as np

	"""
	Compute a mask file from fMRI data in 3D or 4D ndarrays.

	Compute and write the mask of an image based on the grey level
	This is based on an heuristic proposed by T.Nichols:
	find the least dense point of the histogram, between fractions
	m and M of the total image histogram.

	In case of failure, it is usually advisable to increase m.

	Parameters
	----------
	mean_volume : 3D ndarray
		mean EPI image, used to compute the threshold for the mask.
	reference_volume: 3D ndarray, optional
		reference volume used to compute the mask. If none is give, the
		mean volume is used.
	m : float, optional
		lower fraction of the histogram to be discarded.
	M: float, optional
		upper fraction of the histogram to be discarded.
	cc: boolean, optional
		if cc is True, only the largest connect component is kept.
	opening: int, optional
		if opening is larger than 0, an morphological opening is performed,
		to keep only large structures. This step is useful to remove parts of
		the skull that might have been included.
	exclude_zeros: boolean, optional
		Consider zeros as missing values for the computation of the
		threshold. This option is useful if the images have been
		resliced with a large padding of zeros.

	Returns
	-------
	mask : 3D boolean ndarray
		The brain mask
	"""

	if reference_volume is None:
		reference_volume = mean_volume
	sorted_input = np.sort(mean_volume.reshape(-1))
	if exclude_zeros:
		sorted_input = sorted_input[sorted_input != 0]
	limiteinf = np.floor(m * len(sorted_input))
	limitesup = np.floor(M * len(sorted_input))

	delta = sorted_input[limiteinf + 1:limitesup + 1] \
			- sorted_input[limiteinf:limitesup]
	ia = delta.argmax()
	threshold = 0.5 * (sorted_input[ia + limiteinf]
						+ sorted_input[ia + limiteinf + 1])

	# mask = (reference_volume >= threshold)
	mask = np.logical_and(reference_volume >= limiteinf, reference_volume <= limitesup)

	return mask.astype(bool), threshold, sorted_input[limiteinf]
