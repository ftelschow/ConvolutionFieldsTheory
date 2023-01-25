#!/bin/bash
#--------------------------------------------------------------------------
# Parallelize LKC estimation in 1D for stationary field on box manifold
#--------------------------------------------------------------------------
# Loop over parallelisations
for D in {1..3}
do
    matlab -nodesktop -nosplash -r "LKCsim_Article_Timing( $D,  $D ); exit" &
done
