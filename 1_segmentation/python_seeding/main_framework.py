# -*- coding: utf-8 -*-
"""
framework for calling segmentation seeding for an imageset
running time and accuracy (Dice-coeff) can be also calclated (currently commented out)
"""

import time

import numpy as np

from matplotlib import pyplot as plt

from segmentation_seed import segmentation_seed
from skimage import io

from skimage.color import rgb2gray
from skimage.segmentation import mark_boundaries

from scipy.io import loadmat
import numpy, scipy.io

import pickle
import time

#annots = loadmat('../lesionMasks.mat')      # GT mask
#f = open("dices.txt", "w")                  # lesion mask accuracy
start_time = time.time() 

ABOVE_MASKS = []
EPIDERMIS_MASKS = []
DERMIS_MASKS = []
LESION_MASKS = []
SKIN_MASKS = []
#TIMES = []
#DICES = []
numOfImages = 310;
for i in range(numOfImages):
    
    print('image '+ str(i))
    # INPUT IMAGE - cropped image
    j=i+1
    filename = '../input_images/'+ str(j)+ '.png'
    image = io.imread(filename)

    image = rgb2gray(image)
    
    # SEGMENTATION
    #start = time.time()
    masks = segmentation_seed(image)
    #end = time.time()
    #print(end - start)
    #TIMES.append(end-start)
    
    
    ABOVE_MASKS.append(masks.mask_aboveskin)
    EPIDERMIS_MASKS.append(masks.mask_epidermis)
    DERMIS_MASKS.append(masks.mask_dermis)
    LESION_MASKS.append(masks.mask_lesion)
    SKIN_MASKS.append(masks.mask_skin)
    
    # GT from MATLAB
    #gt_mask = annots['lesionMasks_cropped'][0][i]

    # save matlab masks for classification (.MAT)
    scipy.io.savemat('visual_output/matlab_masks/mask_aboveskin_'+str(i)+'.mat', mdict={'mask_aboveskin': masks.mask_aboveskin})
    scipy.io.savemat('visual_output/matlab_masks/mask_epidermis_'+str(i)+'.mat', mdict={'mask_epidermis': masks.mask_epidermis})
    scipy.io.savemat('visual_output/matlab_masks/mask_dermis_'+str(i)+'.mat', mdict={'mask_dermis': masks.mask_dermis})
    scipy.io.savemat('visual_output/matlab_masks/mask_lesion_'+str(i)+'.mat', mdict={'mask_lesion_seed': masks.mask_lesion})

        
    united_mask = (masks.mask_skin.astype(int)+2*masks.mask_epidermis.astype(int)+
          masks.mask_dermis.astype(int)-2*masks.mask_lesion.astype(int))
    
    # display GT and segmented lesion masks
    fig=plt.figure(dpi=450)
    #io.imshow(mark_boundaries(image, masks.mask_lesion+gt_mask, color=(1, 0, 0), outline_color=None, mode='thick', background_label=0)) 
    io.imshow(mark_boundaries(image, masks.mask_lesion, color=(1, 0, 0), outline_color=None, mode='thick', background_label=0)) 
    fig.savefig('visual_output/final_masks/'+ str(i) + '.png')
    plt.close(fig)
    
    # compute Dice
    #dice = np.sum(masks.mask_lesion[gt_mask==1])*2.0 / (np.sum(masks.mask_lesion) + np.sum(gt_mask))
    #DICES.append(dice)
    #print ('Dice score is {}\n'.format(dice))
    #f.write('image'+str(i)+ ': \t'+ str(dice)+'\n');
    
#f.close()
print("%f seconds" % (time.time() - start_time))


file_temp = open('masks_above', 'wb')
pickle.dump(ABOVE_MASKS, file_temp)
file_temp.close()

file_temp = open('masks_skin', 'wb')
pickle.dump(SKIN_MASKS, file_temp)
file_temp.close()

file_temp = open('masks_epidermis', 'wb')
pickle.dump(EPIDERMIS_MASKS, file_temp)
file_temp.close()

file_temp = open('masks_dermis', 'wb')
pickle.dump(DERMIS_MASKS, file_temp)
file_temp.close()

file_temp = open('masks_lesion', 'wb')
pickle.dump(LESION_MASKS, file_temp)
file_temp.close()


# # read binary file
# file_masks = open("masks_above",'rb')
# masks = pickle.load(file_masks)
# file_masks.close()
