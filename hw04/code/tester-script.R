#==============================================================================
# Title: Test Script for 'Functions.R'
# Description: Runs unit tests for all functions in 'functions.R'. 
# Description cont'd: Each function is tested with 4 inputs and the results are 
# Description cont'd: stored in '../output/test-reporter.txt'
# Input: Numeric values, vectors, boolean named 'na.rm' to remove empty cells
# Output: Text file with summary of test results. Text file located in 
# Output cont'd: Text file located at '../output/test-reporter.txt'
# Author: Bryant Luong
# Date: 2017-11-22
#==============================================================================
# load 'testthat' library into R session
library(testthat)

# source in functions to be tested
source('../../code/functions.R')

# save test results from running 'tests.R' in '../output/test-reporter.txt'
sink('../../output/test-reporter.txt')
test_file('../../code/tests.R')
sink()