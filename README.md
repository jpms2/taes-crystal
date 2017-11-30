# taes-crystal

This project is a reprodution of an experiment that can be found on the paper: Early detection of collaboration conflicts and risks

To install it, clone this repository (The bash scripts only works on unix environments), you'll need ruby >= 2.0.0 to run the ruby scripts

## Getting merge commits

For retrieving merge commits, use the ruby script found on ruby_scripts/extract_merge_commits.rb, 
set the path where the project you want to use is, then set the commit SHA you want to start with. After these parameters are set,
open a cmd, move to ruby_scripts/ folder and type: ruby extract_merge_commits.rb Base, left and right are gonna be saved on the file
results/Merge*

## Building and running tests

For building and testing every commit found on the results/Merge*, set the parameters on ruby_scripts/call_build_test_script.rb to
the folder containing results/Merge*, to the git url for cloning the project you want to run and for the ruby version the project uses.
After that open the cmd, move to ruby_scripts/ folder and type: ruby call_build_test_script.rb The results of this script will be found on
results/*_build_test_results

## Finding conflicts 

For checking each merge searching for conflicts, set the parameters at ruby_scripts/merge_left_right.rb to the folder containing 
results/Merge*, to the git url for cloning the project you want to run and for the ruby version the project uses.
After that open the cmd, move to ruby_scripts/ folder and type: ruby merge_left_right.rb The results of this script will be 
found on results/*_merge_results
