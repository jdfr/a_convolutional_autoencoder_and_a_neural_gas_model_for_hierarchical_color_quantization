import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from torchvision import datasets, transforms
import cv2
import matplotlib.pyplot as plt
import numpy as np
import sys
import os
from scipy.io import savemat, loadmat
import argparse

class LoadSingleImage(Dataset):  # for training/testing
    def __init__(self, path):
        self.img = np.ascontiguousarray(cv2.imread(path)[:,:,::-1])
        self.t = transforms.ToTensor()(self.img)
        self.t1 = torch.unsqueeze(self.t, 0).to(device=0)
    def __len__(self):
        return 1
    def __getitem__(self, index):
        return self.t

class RoundGradient(torch.autograd.Function):
    @staticmethod
    def forward(ctx, x):
        return x.round()
    @staticmethod
    def backward(ctx, g):
        return g 

class Encoder(nn.Module):
    
    def __init__(self, dimhop, numsteps, deeper, r, precision):
        super().__init__()
        steps = []
        dim = 3
        for n in range(numsteps):
          idim = dim
          if deeper:
            idim = dim+1
            steps.append(nn.Conv2d(dim,  idim,       r, stride=1, padding=1))
            steps.append(nn.Sigmoid())
          steps.append(  nn.Conv2d(idim, dim+dimhop, r, stride=2, padding=1))
          steps.append(  nn.Sigmoid())
          dim = dim+dimhop
        #print(steps)
        self.encoder = nn.Sequential(*steps)
        if precision in [0,32]:
          self.precision = None
        else:
          self.precision = 2**precision
        if self.precision is not None:
          self.round = RoundGradient.apply
        
    def forward(self, x):
        x = self.encoder(x)
        if self.precision is not None:
          x = self.round(x*self.precision)/self.precision
        return x

class Decoder(nn.Module):
    
    def __init__(self, dimhop, numsteps, deeper, r):
        super().__init__()
        steps = []
        dim = 3
        for n in range(numsteps):
          idim = dim+dimhop
          steps.append(nn.Sigmoid())
          if deeper:
            idim = dim+1
          steps.append(nn.ConvTranspose2d(idim, dim, r, stride=2, padding=1, output_padding=1))
          if deeper:
            steps.append(nn.Sigmoid())
            steps.append(nn.ConvTranspose2d(dim+dimhop, idim, r, stride=1, padding=1))
          dim = dim+dimhop
        #print(steps)
        steps = steps[::-1]
        self.decoder = nn.Sequential(*steps)
        
    def forward(self, x):
        x = self.decoder(x)
        return x

def get_args():
  parser = argparse.ArgumentParser(description='fitting convolutional autoencoders to images')
  parser.add_argument('--device', type=str, help='pytorch''s cuda device like "cuda:0"')
  parser.add_argument('--destdir', type=str, help='directory to store results, WITH SLASH AT THE END!!!!!!')
  parser.add_argument('--train', action='store_true', help='flag to train')
  parser.add_argument('--imgpath', type=str, help='full path to image')
  parser.add_argument('--r', type=int, help='convolution radius')
  parser.add_argument('--dimhop', type=int, help='how many dimensions to add in each image size reduction')
  parser.add_argument('--numsteps', type=int, help='number of reductions')
  parser.add_argument('--deeper', type=int, help='flag to add a convolution (adding/substracting a dimension) before each reduction / after each expansion')
  parser.add_argument('--precision', type=int, help='number of bits of precision of the intermediate encoding. Should be 8, 16 or 32.')
  parser.add_argument('--base_num_epochs', type=int, help='number of training epochs per convolution in the encoder')
  parser.add_argument('--numTrainings', type=int, help='number of different trainings to perform')
  parser.add_argument('--encode', action='store_true', help='flag to encode')
  parser.add_argument('--basename', type=str, help='basename to save encoding results')
  parser.add_argument('--decode', action='store_true', help='flag to decode')
  parser.add_argument('--matpath', type=str, help='full path to matlab file with autoencoder parameters')
  parser.add_argument('--weightpath', type=str, help='full path to weights file')
  parser.add_argument('--encodedpath', type=str, help='full path to *.mat file with encoded image, must be in variable ''encoded''')
  parser.add_argument('--resultpath', type=str, help='full path to image file to store results')
  args = parser.parse_args()
  return args
#CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "png/baboon.png" --destdir "png/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 32 --base_num_epochs 5000 --numTrainings 10
"""
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Baboon.tiff" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/House.tiff" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lake.tiff" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lena.tiff" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bike.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bird.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/building.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/chicks.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/mall.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/night.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/picturesque.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/snow.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/street.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/woman.png" --destdir "convP16H3/" --r 3 --dimhop 3 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10


CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Baboon.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/House.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lake.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lena.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bike.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bird.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/building.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/chicks.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/mall.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/night.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/picturesque.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/snow.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/street.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/woman.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Baboon.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/House.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lake.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lena.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bike.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bird.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/building.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/chicks.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/mall.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/night.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/picturesque.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/snow.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/street.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/woman.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 1 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Baboon.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/House.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lake.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lena.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bike.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bird.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/building.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/chicks.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/mall.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/night.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/picturesque.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/snow.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/street.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/woman.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Baboon.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/House.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lake.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lena.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bike.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bird.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/building.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/chicks.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/mall.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/night.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/picturesque.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/snow.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/street.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/woman.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 2 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Baboon.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/House.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lake.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lena.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bike.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bird.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/building.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/chicks.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/mall.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/night.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/picturesque.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/snow.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/street.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/woman.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 0 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Baboon.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/House.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lake.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/Lena.tiff" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bike.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/bird.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/building.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/chicks.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/mall.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/night.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/picturesque.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/snow.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/street.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10
CUDA_VISIBLE_DEVICES=1 python pruebaconv1.py --train --device "cuda:0" --imgpath "all/woman.png" --destdir "convP16H2/" --r 3 --dimhop 2 --numsteps 3 --deeper 1 --precision 16 --base_num_epochs 20000 --numTrainings 10


"""

class Args:
  def __init__(self):
    if False:
      self.device = "cuda:0"
      self.imgpath = 'png/baboon.png'
      self.destdir = 'png/'
      self.r=3
      self.dimhop=2
      self.numsteps=2
      self.deeper=0
      self.precision=8
      self.base_num_epochs=20000
      self.numTrainings = 10
    else:
      i=1
      self.device    = sys.argv[i]; i+=1
      self.imgpath   = sys.argv[i]; i+=1
      self.destdir   = sys.argv[i]; i+=1
      self.r         = int(sys.argv[i]); i+=1
      self.dimhop    = int(sys.argv[i]); i+=1
      self.numsteps  = int(sys.argv[i]); i+=1
      self.deeper    = int(sys.argv[i]); i+=1
      self.precision = int(sys.argv[i]); i+=1
      self.base_num_epochs = int(sys.argv[i]); i+=1
      self.numTrainings    = int(sys.argv[i]); i+=1
#python pruebaconv1.py "cuda:0" "png/baboon.png" "png/" 3 2 2 0 32 5000 10

def init_weights(m):
    if isinstance(m, nn.Conv2d) or isinstance(m, nn.ConvTranspose2d):
        #z1=torch.min(m.weight)
        #z2=torch.max(m.weight)
        torch.nn.init.uniform_(m.weight, -1.9, 1.9)
        torch.nn.init.uniform_(m.bias, -1.9, 1.9)
        #z3=torch.min(m.weight)
        #z4=torch.max(m.weight)
        #print(f"HOLA {z1} {z2} {z3} {z4}")

def trainOneAutoEncoder(args):
  train_data = LoadSingleImage(args.imgpath)
  train_loader = torch.utils.data.DataLoader(train_data, batch_size=1)

  ### Define the loss function
  loss_fn = torch.nn.MSELoss()

  ### Define an optimizer (both for the encoder and the decoder!)
  lr= 0.001

  ### Set the random seed for reproducible results
  #torch.manual_seed(0)

  #model = Autoencoder(encoded_space_dim=encoded_space_dim)
  encoder = Encoder(args.dimhop, args.numsteps, args.deeper, args.r, args.precision)
  decoder = Decoder(args.dimhop, args.numsteps, args.deeper, args.r)
  encoder.encoder.apply(init_weights)
  decoder.decoder.apply(init_weights)

  params_to_optimize = [
      {'params': encoder.parameters()},
      {'params': decoder.parameters()}
  ]

  optim = torch.optim.Adam(params_to_optimize, lr=lr, weight_decay=1e-05)

  # Check if the GPU is available
  device = torch.device(args.device) if torch.cuda.is_available() else torch.device("cpu")

  # Move both the encoder and the decoder to the selected device
  encoder.to(device)
  decoder.to(device)

  num_epochs = args.base_num_epochs*args.numsteps
  if args.deeper:
    num_epochs *= 2
  prev_train_loss = np.inf
  period_print=10000
  #period_show=50000
  for epoch in range(num_epochs):
    train_loss = train_epoch(encoder,decoder,device,train_loader,loss_fn,optim)
    if (epoch+1)%period_print==0:
      print(f'\n EPOCH {epoch+1}/{num_epochs} \t train loss {train_loss} \t diff_train_loss {prev_train_loss-train_loss}')
    prev_train_loss = train_loss
    #if (epoch+1)%period_show==0:
    #  plot_ae_outputs(encoder,decoder,train_data.t1)
  img_result, encoded, params = get_results(encoder, decoder, train_data.t1)
#save_encoded(encoder, decoder, train_data.t1, f'{basename}.decoded.png')
#plot_ae_outputs(encoder,decoder,train_data.t1)

  return encoder, decoder, img_result, encoded, params, train_loss

def trainManyAutoEncoders(args):

  name = args.imgpath[:args.imgpath.rfind('.')]
  name = name[name.rfind('/'):]
  basename = f'{args.destdir}{name}_convautoenc_R{args.r}_H{args.dimhop}_N{args.numsteps}_D{int(args.deeper)}_P{args.precision}_E{args.base_num_epochs}'
  best = None

  for x in range(args.numTrainings):
    print(f'TRAINING {x+1}/{args.numTrainings}')
    res = trainOneAutoEncoder(args)
    loss = res[-1]
    if best is None or loss<best[-1]:
      best = res
    saveAutoEncoder(args, *res, name, f'{basename}_{x+1:02d}')
  saveAutoEncoder(args, *best, name, f'{basename}_best')

def saveAutoEncoder(args, encoder, decoder, img_result, encoded, params, loss, name, basename):
  basename = basename.replace('//', '/')
  decoder_params = np.empty((len(params),), dtype=object)
  for k in range(len(params)):
    decoder_params[k] = params[k]
  specs = {
    'imgname': name,
    'r': args.r,
    'dimhop': args.dimhop,
    'numsteps': args.numsteps,
    'deeper': args.deeper,
    'precision': args.precision,
    'base_num_epochs': args.base_num_epochs,
    'numTrainings': args.numTrainings,
    'loss': loss,
    'encoded': encoded,
    'decoder_params': decoder_params,
    }
  for ext in ('.mat', '.png', '.pt'):
    name = f'{basename}{ext}'
    if os.path.isfile(name):
      os.remove(name)
  savemat(f'{basename}.mat', {'autoenc': specs})
  cv2.imwrite(f'{basename}.png', img_result)
  torch.save({'encoder': encoder.state_dict(), 'decoder': decoder.state_dict()}, f'{basename}.pt')

def doEncode(args):
  d = loadmat(args.matpath)
  r        = int(d['autoenc']['r'])
  dimhop   = int(d['autoenc']['dimhop'])
  numsteps = int(d['autoenc']['numsteps'])
  deeper   = int(d['autoenc']['deeper'])
  precision= int(d['autoenc']['precision'])
  wgs      = torch.load(args.weightpath)
  encoder  = Encoder(dimhop, numsteps, deeper, r, precision)
  encoder.load_state_dict(wgs['encoder'])
  decoder  = Decoder(dimhop, numsteps, deeper, r)
  decoder.load_state_dict(wgs['decoder'])
  encoder.eval()
  decoder.eval()
  device = torch.device(args.device) if torch.cuda.is_available() else torch.device("cpu")
  encoder.to(device)
  decoder.to(device)
  img      = np.ascontiguousarray(cv2.imread(args.imgpath)[:,:,::-1])
  t        = transforms.ToTensor()(img)
  t1       = torch.unsqueeze(t, 0).to(device=0)
  img_result, encoded, params = get_results(encoder, decoder, t1)
  specs = {
    'encoded': encoded,
    }
  for ext in ('.mat', '.png'):
    name = f'{args.basename}{ext}'
    if os.path.isfile(name):
      os.remove(name)
  savemat(f'{args.basename}.mat', {'autoenc': specs})
  cv2.imwrite(f'{args.basename}.png', img_result)

def doDecode(args):
  d = loadmat(args.matpath)
  r        = int(d['autoenc']['r'])
  dimhop   = int(d['autoenc']['dimhop'])
  numsteps = int(d['autoenc']['numsteps'])
  deeper   = int(d['autoenc']['deeper'])
  decoder = Decoder(dimhop, numsteps, deeper, r)
  decoder.load_state_dict(torch.load(args.weightpath)['decoder'])
  #encoded = d['autoenc']['encoded'][0,0]
  encoded = loadmat(args.encodedpath)['encoded']
  #import code; code.interact(local=vars())
  encoded = np.array(encoded, dtype=np.float32)
  encoded = np.ascontiguousarray(encoded.transpose((2, 0, 1)))
  encoded = torch.from_numpy(encoded)
  encoded = torch.unsqueeze(encoded, 0)
  decoder.eval()
  with torch.no_grad():
    img = decoder(encoded)
    img = img.cpu().squeeze().numpy().transpose((1,2,0))
  img = np.array(img[:,:,::-1]*255, dtype=np.uint8)
  cv2.imwrite(args.resultpath, img)

def get_results(encoder, decoder, img1):
  encoder.eval()
  decoder.eval()
  with torch.no_grad():
    enc = encoder(img1)
    enc_save = enc.cpu().squeeze().numpy().transpose((1,2,0))
    img2  = decoder(enc)
    params = [p.cpu().squeeze().numpy() for p in decoder.parameters()]
    img2 = img2.cpu().squeeze().numpy().transpose((1,2,0))
  img2 = np.array(img2[:,:,::-1]*255, dtype=np.uint8)
  return img2, enc_save, params


### Training function
def train_epoch(encoder, decoder, device, dataloader, loss_fn, optimizer):
    # Set train mode for both the encoder and the decoder
    encoder.train()
    decoder.train()
    #train_loss = []
    # Iterate the dataloader (we do not need the label values, this is unsupervised learning)
    for image_batch in dataloader:
        # Move tensor to the proper device
        image_batch = image_batch.to(device)
        enc = encoder(image_batch)
        decoded_data = decoder(enc)
        # Evaluate loss
        loss = loss_fn(decoded_data, image_batch)
        # Backward pass
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        # Print batch loss
        #print('\t partial train loss (single batch): %f' % (loss.data))
        #train_loss.append(loss.detach().cpu().numpy())
        train_loss = loss.detach().cpu().numpy()

    return train_loss #np.mean(train_loss)

def plot_ae_outputs(encoder,decoder,img1):
    encoder.eval()
    decoder.eval()
    with torch.no_grad():
       img2  = decoder(encoder(img1))
    img1 = img1.cpu().squeeze().numpy().transpose((1,2,0))
    img2 = img2.cpu().squeeze().numpy().transpose((1,2,0))
    plt.figure()#(figsize=(16,4.5))
    ax = plt.subplot(1,2,1)
    ax.get_xaxis().set_visible(False)
    ax.get_yaxis().set_visible(False)  
    plt.imshow(img1)
    ax.set_title('Original image')
    ax = plt.subplot(1,2,2)
    ax.get_xaxis().set_visible(False)
    ax.get_yaxis().set_visible(False)  
    plt.imshow(img2)
    ax.set_title('Reconstructed image')
    plt.show()

def save_encoded(encoder, decoder, img1, basename):
    encoder.eval()
    decoder.eval()
    with torch.no_grad():
       enc = encoder(img1)
       enc_save = enc.cpu().squeeze().numpy().transpose((1,2,0))
       img2  = decoder(enc)
       params = [p.cpu().squeeze().numpy() for p in decoder.parameters()]
       #import code; code.interact(local=vars())
    #https://stackoverflow.com/questions/70582920/using-python-to-create-a-mat-file-with-a-cell-array-in-it
    img2 = img2.cpu().squeeze().numpy().transpose((1,2,0))
    #plt.figure()#(figsize=(16,4.5))
    #plt.imshow(img2)
    #plt.show()
    #import code; code.interact(local=vars())
    img2 = np.array(img2[:,:,::-1]*255, dtype=np.uint8)
    cv2.imwrite(f'{basename}_decodedimg.png', img2)

if __name__ == "__main__":
  #args = Args()
  args = get_args()
  if args.train:
    trainManyAutoEncoders(args)
  elif args.decode:
    doDecode(args)
  elif args.encode:
    doEncode(args)

