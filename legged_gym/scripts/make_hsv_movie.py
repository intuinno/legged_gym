import os
import matplotlib
import matplotlib.image
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
                 'value' : 2}.items():
        img = x_hsv[index, :, :]
        cam_img = img.numpy().squeeze()
        filename = os.path.join(directory, color, basename)
        matplotlib.image.imsave(filename, cam_img)
        print("Saved ", filename)
    
    saturation = x_hsv[1,:,:]
    min_saturation = 0.4
    one = torch.tensor([1.])
    zero = torch.tensor([0.])
    blues = torch.where(saturation > min_saturation, one, zero)
    cam_img = blues.numpy().squeeze()
    filename = os.path.join(directory, 'filter', basename)
    matplotlib.image.imsave(filename, cam_img)
    print('Saved ', filename)
        
         

directory_name=sys.argv[1]
if os.path.isdir(directory_name):
    for n in ['hue', 'saturation', 'value', 'filter']:
        path = os.path.join(directory_name, n)
        os.makedirs(path, exist_ok=True)
    make_movie(directory_name)
else:
    print('The directory name does not exist', directory_name)
