#!/bin/bash
#-------------------------------------------------------------------------------
# Parallelize LKC estimation in 2D for nonstationary sphere manifold
#-------------------------------------------------------------------------------
# Loop over parallelisations
for parallel_count in {1..5}
do
    matlab -nodesktop -nosplash -r "LKCsim_Article( 0, 'nonstationary', 'sphere', 2, 200, $parallel_count ); exit" &
done

# Loop over parallelisations
for parallel_count in {1..5}
do
    matlab -nodesktop -nosplash -r "LKCsim_Article( 1, 'nonstationary', 'sphere', 2, 200, $parallel_count ); exit" &
done
