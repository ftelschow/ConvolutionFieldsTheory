#!/bin/bash
#--------------------------------------------------------------------------
# Parallelize LKC estimation in 2D for stationary field on box manifold
#--------------------------------------------------------------------------
# Loop over parallelisations
for parallel_count in {1..10}
do
    matlab -nodesktop -nosplash -r "LKCsim_Article( 0, 'stationary', 'box', 2, 100, $parallel_count ); exit" &
done

# Loop over parallelisations
for parallel_count in {1..10}
do
    matlab -nodesktop -nosplash -r "LKCsim_Article( 1, 'stationary', 'box', 2, 100, $parallel_count ); exit" &
done
