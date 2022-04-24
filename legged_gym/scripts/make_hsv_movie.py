import os
import matplotlib
import numpy as np
import sys
import kornia as K
import torch, torchvision 

def make_movie(directory):
    # iterate over files in
    # that directory
    for filename in os.listdir(directory):
        f = os.path.join(directory, filename)
        # checking if it is a file
        if filename.endswith('.png'):
            make_hsv(directory, f)

def make_hsv(directory, f_path):
    basename = os.path.basename(f_path) 
    x_rgba: torch.tensor = torchvision.io.read_image(f_path)  # CxHxW / torch.uint8
    x_rgb = K.color.rgba_to_rgb(x_rgba/255.)
    x_hsv = K.color.rgb_to_hsv(x_rgb)

    for color, index in {'hue' : 0, 
                 'saturation' : 1,
                 'value' : 2}:
        img = x_hsv[:, index, :, :]
        cam_img = img.numpy().squeeze()
        filename = os.path.join(directory, color, basename)
        matplotlib.image.imsave(filename, cam_img)
        
         

try:
    directory_name=sys.argv[1]
    for n in ['hue', 'saturation', 'value']:
        path = os.path.join(directory_name, n)
        os.makedirs(path, exist_ok=True)
    make_movie(directory_name)
except:
    print('Please pass directory_name')

