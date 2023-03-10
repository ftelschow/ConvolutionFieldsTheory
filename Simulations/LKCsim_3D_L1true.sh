#!/bin/bash
#--------------------------------------------------------------------------
# Parallelize LKC estimation in 1D for stationary field on box manifold
#--------------------------------------------------------------------------
matlab -nodesktop -nosplash -r "LKCsim_3D_L1true( 100 ); exit" &
