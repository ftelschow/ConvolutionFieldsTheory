#!/bin/bash
#-------------------------------------------------------------------------------
# Parallelize FWER calculations
#-------------------------------------------------------------------------------
# Loop over parallelisations
for run in {0..23}
do
    matlab -nodesktop -nosplash -r "runLKC2D($run); exit" &
done
