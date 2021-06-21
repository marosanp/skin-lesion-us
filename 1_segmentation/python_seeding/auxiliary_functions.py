# -*- coding: utf-8 -*-
"""
auxiliary function used for lesion seed detection
"""


import numpy as np
from skimage import measure
from matplotlib import pyplot as plt
from skimage import io


# heat map calculation
def calc_heatmap_aboveskin(height, width):
    # HEATMAP line-by-line reducing prob
    heat_map = np.zeros([height, width])
    for i in range(height):
            heat_map[i] = (i**(0.8));
    
    #heat_map = heat_map.astype(int)
    heat_map =  np.amax(heat_map)-heat_map
    heat_map[round(height*2/3):height,:] = 0
    
    # heat_map = np.zeros([height, width])
    # for i in range(height):
    #     for j in range(width):
    #         heat_map[j][i] = j;
    
    # #heat_map = heat_map.astype(int)
    # heat_map =  np.amax(heat_map)-heat_map

    return heat_map;


# weighted non-maximum suppression
def calc_biggest_blob(binary, heat_map, blob_size_threshold):
    
    labels_mask = measure.label(binary)                       
    regions = measure.regionprops(labels_mask)
    regions.sort(key=lambda x: x.area, reverse=True)
    
    if blob_size_threshold > 0:
        remove_counter = 0;
        # REMOVE REGION BELOW A THRESHOLD
        if len(regions) >= 1:
            for rg in regions[0:]:
                if len(rg.coords) > blob_size_threshold:
                    remove_counter = remove_counter+1
        del(regions[remove_counter:])  
    
    
    # FIND BIGGEST WEIGHT REGION
    weights = np.zeros(len(regions))
    label_mask = regions[0]._label_image;
    # go through all regions if exists some
    if len(regions) > 1:
        counter = 0;
        # for each single region
        for rg in regions:
            binaryValue = binary[rg.coords[0,0], rg.coords[0,1]]
            label = label_mask[rg.coords[0,0], rg.coords[0,1]]
            if binaryValue.all() ==True:  
                weights[counter] = sum(sum((label_mask == label)*heat_map))    
            counter = counter+1;
    
    
    max_index = np.argmax(weights)
    selected_region = regions[max_index]
    
         
    # Remove other blobs!
    aboveskin_mask = np.zeros([binary.shape[0], binary.shape[1]]);
    aboveskin_mask[selected_region.coords[:,0], selected_region.coords[:,1]] = 1
    
    return aboveskin_mask;

