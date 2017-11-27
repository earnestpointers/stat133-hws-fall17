#==============================================================================
# Title: Unit Tests for 'Functions.R'
# Description: Unit test functions for all functions in 'functions.R'. 
# Description cont'd: 4 tests per function.
# Input: Numeric values, vectors, boolean named 'na.rm' to remove empty cells
# Output: Boolean
# Author: Bryant Luong
# Date: 2017-11-22
#==============================================================================
library(testthat)

context('remove_missing')

test_that('remove_missing', {
  expect_equal(remove_missing(c(1, NA, 4)),c(1, 4))
  expect_length(length(remove_missing(c(1, NA, NA))),length(c(1)))
  expect_that(length(remove_missing(c(NA, NA, NA, NA))), equals(0))
  expect_equal(remove_missing(c(1, NA, 4, NA)),c(1, 4))
})

context('get_minimum')

test_that('get_minimum', {
  expect_equal(get_minimum(), 1)
  expect_length(get_minimum(na.rm = TRUE), 1)
  expect_equal(get_minimum(c(0.00001, 1)), 0.00001)
  expect_error(get_minimum(c('a')), 'Input vector must be numeric type.')
})

context('get_maximum')

test_that('get_maximum', {
  expect_equal(get_maximum(), 10)
  expect_length(get_maximum(na.rm = TRUE), 1)
  expect_that(get_maximum(1000), equals(1000))
  expect_error(get_maximum(c('a')), 'Input vector must be numeric type.')
})

context('get_range')

test_that('get_range', {
  expect_equal(get_range(), 9)
  expect_equal(get_range(na.rm = TRUE), 9)
  expect_equal(get_range(c(10,10,10)), 0)
  expect_error(get_range(c('a')), 'Input vector must be numeric type.')
})

context('get_percentile10')

test_that('get_percentile10', {
  expect_equal(get_percentile10(), 1.9)
  expect_equal(get_percentile10(na.rm = TRUE), 1.9)
  expect_that(length(get_percentile10()), equals(1))
  expect_error(get_percentile10(c('a')), 'Input vector must be numeric type.')
})

context('get_percentile90')

test_that('get_percentile10', {
  expect_equal(get_percentile90(), 9.1)
  expect_equal(get_percentile90(na.rm = TRUE), 9.1)
  expect_that(length(get_percentile90()), equals(1))
  expect_error(get_percentile90(c('a')), 'Input vector must be numeric type.')
})

context('get_quartile1')

test_that('get_quartile1', {
  expect_equal(get_quartile1(), 3.25)
  expect_equal(get_quartile1(na.rm = TRUE), 3.25)
  expect_that(length(get_quartile1()), equals(1))
  expect_error(get_quartile1(c('a')), 'Input vector must be numeric type.')
})

context('get_quartile3')

test_that('get_quartile3', {
  expect_equal(get_quartile3(), 7.75)
  expect_equal(get_quartile3(na.rm = TRUE), 7.75)
  expect_that(length(get_quartile3()), equals(1))
  expect_error(get_quartile3(c('a')), 'Input vector must be numeric type.')
})

context('get_median')

test_that('get_median', {
  expect_equal(get_median(), 5.5)
  expect_equal(get_median(c(1, 2, 3, 4, 5), na.rm = TRUE), 3)
  expect_that(length(get_median()), equals(1))
  expect_error(get_median(c('a')), 'Input vector must be numeric type.')
})

context('get_average')

test_that('get_average', {
  expect_equal(get_average(), 5.5)
  expect_equal(get_average(na.rm = TRUE), 5.5)
  expect_that(length(get_average()), equals(1))
  expect_error(get_average(c('1')), 'Input vector must be numeric type.')
})

context('get_stdev')

test_that('get_stdev', {
  expect_equal(round(get_stdev(), digits = 2), 3.87)
  expect_equal(round(get_stdev(na.rm = TRUE), digits = 2), 3.87)
  expect_that(length(get_stdev()), equals(1))
  expect_error(get_stdev(c('a')), 'Input vector must be numeric type.')
})

context('count_missing')

test_that('count_missing', {
  expect_equal(count_missing(), 1)
  expect_equal(count_missing(c(NA, NA, NA)), 3)
  expect_that(length(count_missing()), equals(1))
  expect_type(count_missing(), 'double')
})

context('summary_stats')

test_that('summary_stats', {
  
  arg1 <- summary_stats(c(1, 3, 5, 7, 9))
  arg2 <- summary_stats()
  
  expect_equal(summary_stats(c(1, 3, 5, 7, 9)), arg1)
  expect_equal(summary_stats(), arg2)
  expect_that(length(summary_stats()), equals(11))
  expect_type(summary_stats(), 'list')
})

# context('print_stats')

# test_that('print_stats', {
# expect_equal(length(print_stats()), 0)
# expect_equal(length(print_stats()), 0)
# expect_equal(length(print_stats()), 0)
# })

context('drop_lowest')

test_that('drop_lowest', {
  expect_equal(drop_lowest(), c(10, 10, 8.5, 7, 9))
  expect_equal(drop_lowest(c(1, 1, 1)), c(1, 1))
  expect_that(length(drop_lowest(c(100, 100, 100))), equals(2))
  expect_type(drop_lowest(), 'double')
})

context('rescale100')

test_that('rescale100', {
  expect_error(rescale100(xmin = 'a'), 'xmin must be numeric type.')
  expect_error(rescale100(xmax = 'a'), 'xmax must be numeric type.')
  expect_equal(rescale100(), c(90, 75, 80, 20, 85, 45))
  expect_that(length(rescale100()), equals(6))
})

context('score_homework')

test_that('score_homework',{
  expect_equal(round(score_homework(), digits = 1), 73.3)
  expect_equal(score_homework(c(2, 2, 1), drop = TRUE), 2)
  expect_equal(score_homework(c(1, 1, 1), drop = TRUE), 1)
  expect_that(length(score_homework()), equals(1))
})

context('score_quiz')

test_that('score_quiz', {
  expect_equal(round(score_quiz(), digits = 1), 62.5)
  expect_equal(score_quiz(c(18, 18, 0), drop = TRUE), 18)
  expect_equal(score_quiz(c(1, 1, 1), drop = TRUE), 1)
  expect_that(length(score_quiz()), equals(1))
})

context('score_lab')

test_that('score_lab', {
  expect_error(score_lab(13), 'Invalid input: score must be between 0 and 12.')
  expect_equal(score_lab(1), 0)
  expect_equal(score_lab(11), 100)
  expect_equal(score_lab(12), 100)
})



