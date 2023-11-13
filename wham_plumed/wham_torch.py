#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 31 13:42:19 2023

@author: bird
"""

import numpy as np
import torch  
import time
import matplotlib.pyplot as plt

def wham(bias,
        *,
        frame_weight=None,
        traj_weight=None,
        T: float = 1.0,
        maxiter: int = 100000,
        threshold: float = 1e-20,
        verbose: bool = False):

    nframes = bias.shape[0]
    ntraj = bias.shape[1]
    bias_cuda = torch.tensor(bias).to('cuda')
    
    # default values
    if frame_weight is None:
        frame_weight = torch.ones(nframes,dtype=torch.float64).to('cuda')
    if traj_weight is None:
        traj_weight = torch.ones(ntraj,dtype=torch.float64).to('cuda')

    assert len(traj_weight) == ntraj
    assert len(frame_weight) == nframes


    # divide by KBT_ once for all
    shifted_bias =  (bias_cuda - torch.min(bias_cuda))/KBT_

    # do exponentials only once
    expv = torch.exp(-shifted_bias)

    Z = torch.ones(ntraj,dtype=torch.float64).to('cuda')

    Zold = Z

    if verbose:
        sys.stderr.write("WHAM: start\n")
    for nit in range(maxiter):
        # find unnormalized weights
        weight = 1.0/torch.matmul(expv, 1.0/Z)*frame_weight
        # update partition functions
        Z = torch.matmul(weight, expv)
        # normalize the partition functions
        Z /= torch.sum(Z*traj_weight)
        # monitor change in partition functions
        eps = torch.sum(torch.log(Z/Zold)**2)
        Zold = Z
        if verbose:
            sys.stderr.write("WHAM: iteration "+str(nit)+" eps "+str(eps)+"\n")
        if eps < threshold:
            break
    nfev=nit
    weight /=torch.sum(weight)
    logW = KBT_*torch.log(weight)

    if verbose:
        sys.stderr.write("WHAM: end")

    return {"weight":weight, "logW":logW, "logZ":torch.log(Z), "nit":nit, "eps":eps}

FILENAME_ = 'all_bias.dat'
bias_M = np.loadtxt(FILENAME_,skiprows=1)[:,1:]
KBT_ = 0.593

t1 = time.time()
w = wham(bias_M,T=0.593)
t1 = time.time() - t1
print(t1)

#plt.plot(-KBT_*w['logZ'].detach().to('cpu').numpy())
np.savetxt('weights.dat',w['weight'].detach().to('cpu').numpy())
