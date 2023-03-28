#!/bin/bash
#-------------------------------------------------------------------------------
# Parallelize FWER calculations
#-------------------------------------------------------------------------------
# Loop over parallelisations
for run in {1..28}
do
    matlab -nodesktop -nosplash -r "runLKC2D($run); exit" &
done