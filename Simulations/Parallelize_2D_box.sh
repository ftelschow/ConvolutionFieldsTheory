#!/bin/bash
########################################################################
####  script for parallization of the bHPE
########################################################################
# Loop over parallelisations
for parallel_count in {1..5}
do
    matlab -nodesktop -nosplash -r "LKCsim_Article( 0, 'stationary', 'box', 2, 200, $parallel_count ); exit" &
done

# Loop over parallelisations
for parallel_count in {1..5}
do
    matlab -nodesktop -nosplash -r "LKCsim_Article( 1, 'stationary', 'box', 2, 200, $parallel_count ); exit" &
done
