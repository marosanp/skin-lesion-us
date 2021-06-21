# -*- coding: utf-8 -*-
"""
ULTRASOUND lesion segmentation framework

The parameters provided are indicatory.
Please note for proper functioning, fine tuning of the segmentation parameters may be required.


Current code is based on Marosán, Péter, et al. "Automated seeding for ultrasound skin lesion segmentation." Ultrasonics 110 (2021): 106268.
Computational cost effective version. Active contour model-based growing step is implemented in MATLAB.

"""

#from matplotlib import pyplot as plt
import numpy as np
#from skimage import io

from skimage.filters import threshold_multiotsu
from scipy import ndimage
#from scipy.ndimage.filters import laplace
#from skimage.morphology import disk, dilation
#from skimage import exposure
#from skimage.filters import median
# from skimage.filters import gaussian



from auxiliary_functions import calc_heatmap_aboveskin
from auxiliary_functions import calc_biggest_blob



# SEGMENTATION SEED DETECTION
def segmentation_seed(image):       # imageInx as second parameter for fig title

    # preprocessing steps - to improve robustness for more datasets
    # # Adaptive histogram equalization
    # image = exposure.equalize_adapthist(image, clip_limit=0.03)
    
    # # Adaptive smoothing
    # grad= np.average(np.absolute(np.gradient(image)[0]))
    # smoothness_original = np.average(np.absolute(laplace(image)))
    
    # while grad > 0.05:
    #     image = median(image)#, disk(7)
    #     grad = np.average(np.absolute(np.gradient(image)[0]))
    
    
    # MULTI-THRESHOLD OTSU & BINARIZATION
    # 5 different classes are separated (echogenicity)
    thresholds = threshold_multiotsu(image, 4)
    # regions = np.digitize(image, bins=thresholds)
    
    # io.imshow(regions)    # image, regions, mask_aboveskin
    # plt.show()
    
    
    ################################  ABOVE SKIN  ################################

    # find potential aboveskin blobs
    mask_aboveskin = image < thresholds[0]
    
    
    mask_aboveskin[1:30, :] = 1
    mask_aboveskin[1:70, 0] = 1
    mask_aboveskin[1:70, image.shape[1]-1] = 1
    # io.imshow(mask_aboveskin)    # image, regions, mask_aboveskin
    # plt.show()
    
    
    #fig, axs = plt.subplots(2, 2, sharex='col', sharey='row',
    #                    gridspec_kw={'hspace': 0, 'wspace': 0.1}, dpi=450)
    #fig.suptitle(str(imageInx), fontsize=16)
    #(ax1, ax2), (ax3, ax4) = axs
    #ax1.imshow(mask_aboveskin) 
    
    # calculate weights for above skin region detection
    blob_size_threshold = 900;  # eliminating small blobs
    heatmap_aboveskin = calc_heatmap_aboveskin(image.shape[0], image.shape[1])
    #ax2.imshow(heatmap_aboveskin) 
    # weighted non-maximum supression
    mask_aboveskin = calc_biggest_blob(mask_aboveskin, heatmap_aboveskin, blob_size_threshold)    
    #ax3.imshow(mask_aboveskin)
    #ax1.axis('off')
    #ax2.axis('off')
    #ax3.axis('off')
    #ax4.axis('off') 
    
    
    # post-proc - filling the holes inside the selected region
    mask_aboveskin = ndimage.binary_fill_holes(mask_aboveskin)
    
    # skin part
    mask_skin = np.invert(mask_aboveskin);
    
    
    
    heat_map_ab = ndimage.distance_transform_edt(mask_skin);
    heat_map_ab = np.amax(heat_map_ab) - heat_map_ab;
    heat_map_ab = heat_map_ab*mask_skin;
    mask_ab = heat_map_ab > (np.amax(heat_map_ab-4))
    mask_aboveskin = np.logical_xor(mask_aboveskin,mask_ab)
    mask_aboveskin = ndimage.binary_fill_holes(mask_aboveskin)
    # get skin mask
    mask_skin = np.invert(mask_aboveskin);
    
    ################################  EPIDERMIS  #################################
    
    # radius = 7;
    # mask = disk(radius)
    # for it in range(10):
    #     mask_epidermis = dilation(mask_aboveskin, selem=mask)
    # mask_epidermis = np.logical_xor(mask_epidermis,mask_aboveskin)
    
    
    # epidermis heat map
    heat_map_epidermis = ndimage.distance_transform_edt(mask_skin);
    heat_map_epidermis = np.amax(heat_map_epidermis) - heat_map_epidermis;
    heat_map_epidermis = heat_map_epidermis*mask_skin;
    epidermis_thickness = 12;       # based on pre-defined information (biology: epidermis thickness, ultrasound image frequency)
    
    mask_epidermis = heat_map_epidermis > (np.amax(heat_map_epidermis-epidermis_thickness))
    
    # io.imshow(mask_epidermis)       # heat_map_epidermis
    # plt.show()
    
    #ax4.imshow(mark_boundaries(image, mask_skin+2*mask_epidermis, color=(1, 0, 0), outline_color=None, mode='thick', background_label=0))     
    #fig.savefig('visual_output/skin_border/'+ str(imageInx) + '.png')
    #plt.close(fig)
    
    
    ###################################  DERMIS  ##################################
    
    # dermis thickness
    mask_dermis = np.invert(np.logical_xor(mask_aboveskin,mask_epidermis))
    heat_map_dermis = ndimage.distance_transform_edt(mask_dermis);
    heat_map_dermis = np.amax(heat_map_dermis) - heat_map_dermis;
    heat_map_dermis = heat_map_dermis*mask_dermis;
    dermis_thickness = 40;      # based on pre-defined information (biology: dermis thickness, ultrasound image frequency)
    mask_dermis = heat_map_dermis > (np.amax(heat_map_dermis-dermis_thickness))
    
    # io.imshow(mask_dermis)       # heat_map_dermis
    # plt.show()
    
    # # dermis echogenicity
    # thresholds = threshold_multiotsu(image, 5)
    # #regions = np.digitize(image, bins=thresholds)
    # binary_dermis = image > thresholds[1]
    
    # # io.imshow(binary_dermis)       # heat_map_dermis
    # # plt.show()
    
    # mask_dermis = np.logical_and(mask_dermis, binary_dermis)
    # # io.imshow(mask_dermis)       # heat_map_dermis
    # # plt.show()
    
    # blob_size_threshold = 400;
    # mask_dermis = calc_biggest_blob(mask_dermis, heat_map_dermis, blob_size_threshold)
    # mask_dermis = np.logical_xor(mask_dermis, mask_epidermis)
    # mask_dermis = ndimage.binary_fill_holes(mask_dermis)
    # mask_dermis = np.logical_and(mask_dermis, np.invert(mask_epidermis))
    
    
    # io.imshow(mask_dermis)       # heat_map_dermis
    # plt.show()
    
    #fig2, axs = plt.subplots(2, 2, sharex='col', sharey='row',
    #                   gridspec_kw={'hspace': 0, 'wspace': 0.1}, dpi=450)
    #fig2.suptitle(str(imageInx), fontsize=16)
    #(ax1, ax2), (ax3, ax4) = axs
    #ax1.imshow(mark_boundaries(image, mask_skin+2*mask_epidermis+4*mask_dermis, color=(1, 0, 0), outline_color=None, mode='thick', background_label=0)) 
    
    ###############################  LESION HEATMAP  ##############################
    
    mask_united = np.invert(np.logical_xor(mask_aboveskin, mask_epidermis));
    heatmap_lesion = ndimage.distance_transform_edt(mask_united);
    heatmap_lesion = np.amax(heatmap_lesion) - heatmap_lesion;
    heatmap_lesion = heatmap_lesion*mask_united;
    heatmap_lesion = 2**(heatmap_lesion/2)
    heatmap_lesion = heatmap_lesion/np.amax(heatmap_lesion)
    
    # io.imshow(heatmap_lesion)
    # plt.show()
    
    
    mask_horizontal = np.zeros([image.shape[0], image.shape[1]])
    for i in range(image.shape[0]):
        mask_horizontal[i][round(image.shape[1]/2)] = True;
    
    mask_horizontal = np.invert(mask_horizontal.astype(bool))    
    heatmap_horizontal = ndimage.distance_transform_edt(mask_horizontal);
    heatmap_horizontal = np.amax(heatmap_horizontal) - heatmap_horizontal;
    #heatmap_horizontal = 2**(heatmap_horizontal/1000)        #TODO
    heatmap_horizontal = heatmap_horizontal/np.amax(heatmap_horizontal)
    
    # io.imshow(heatmap_horizontal)
    # plt.show()
    
    
    heatmap_lesion = heatmap_lesion*heatmap_horizontal;
    #ax2.imshow(heatmap_lesion)
    # io.imshow(heatmap_lesion)
    # plt.show()
    
    
    ############################  LESION LOCALIZATION  ############################
    
    # io.imshow(mask_united*image)          # mask_united
    # plt.show()
    
    thresholds = threshold_multiotsu((mask_united*image), 5)
    #regions = np.digitize(image, bins=thresholds)
    mask_lesion = image < thresholds[2]
    #ax3.imshow(mask_lesion)
    
    # io.imshow(mask_lesion)
    # plt.show()
    
    blob_size_threshold = 0;
    mask_lesion = np.logical_and(mask_lesion, mask_dermis)
    mask_lesion = calc_biggest_blob(mask_lesion, heatmap_lesion, blob_size_threshold)
    mask_lesion = ndimage.binary_fill_holes(mask_lesion)
    
    
    #ax4.imshow(mark_boundaries(image, mask_lesion, color=(1, 0, 0), outline_color=None, mode='thick', background_label=0)) 
    #fig2.savefig('visual_output/lesion/'+ str(imageInx) + '.png')
    #plt.close(fig2)
    
    # io.imshow(mask_lesion)
    # plt.show()
    
    ####################################  ACM  ####################################
    
    # growing step and final boundary delimination was implemented in MATLAB
    ##################################  DISPLAY  ##################################
    
    
    masks = Masks();
    masks.mask_aboveskin = mask_aboveskin
    masks.mask_skin = mask_skin
    masks.mask_epidermis = mask_epidermis
    masks.mask_dermis = mask_dermis
    masks.mask_lesion = mask_lesion

    
    
    
    # final_mask = (mask_skin.astype(int)+2*mask_epidermis.astype(int)+
    # mask_dermis.astype(int)-2*mask_lesion.astype(int))
    # io.imshow(final_mask)       # heat_map_dermis
    # plt.show()
    return masks;

class Masks:
    mask_lesion = 0;

         
