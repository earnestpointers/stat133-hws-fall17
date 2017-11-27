#==============================================================================
# Title: Functions for cleaning data
# Description: functions.R contains all data processing functions for HW04
# Description cont'd: All 'get_" functions check if input is numeric class
# Input: Numeric values, vectors, boolean named 'na.rm' to remove empty cells
# Output: Numeric values and vectors
# Author: Bryant Luong
# Date: 2017-11-22
#==============================================================================

# load libraries
library(stringr)

#==============================================================================
# function name: remove_missing
# description:  returns input vector without missing values
# input: numeric vector
# output: numeric vector
#==============================================================================
remove_missing <- function(v = c(1, 4, 7, NA, 10)){
  x <- c()
  
  for (i in v){
    if (!is.na(i)){
      x <- append(x, i)
    }
  }
  
  v <- x
   return(v)
}

#==============================================================================
# function name: get_minimum
# description:  returns minimum value of input vector
# input: numeric vector and optional logical 'na.rm' 
# output: numeric value
#==============================================================================
get_minimum <- function(v = c(1, 4, 7, NA, 10), na.rm = FALSE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (na.rm){
    v <- remove_missing(v)
  }
  
  v <- sort(v)
  return(v[1])
}

#==============================================================================
# function name: get_maximum
# description:  returns maximum of numeric vector
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_maximum <- function(v = c(1, 4, 7, NA, 10), na.rm = FALSE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (na.rm){
    v <- remove_missing(v)
  }
  
  v <- sort(v)
  return(v[length(v)])
}

#==============================================================================
# function name: get_range
# description:  returns range of values of numeric vector
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_range <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (na.rm){
    v <- remove_missing(v)
  }
  range <- get_maximum(v) - get_minimum(v)
  return(range)
}

#==============================================================================
# function name: get_percentile10
# description: returns 10th percentile numeric value
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_percentile10 <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (!na.rm){
    v <- remove_missing(v)
  }
  quantiles <- quantile(v, probs = seq(0, 1, 0.10), na.rm = TRUE)
  quantiles['10%'][[1]]
}

#==============================================================================
# function name: get_percentile90
# description: returns 90th percentile numeric value
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_percentile90 <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (!na.rm){
    v <- remove_missing(v)
  }
  quantiles <- quantile(v, probs = seq(0, 1, 0.10), na.rm = TRUE)
  quantiles["90%"][[1]]
}

#==============================================================================
# function name: get_quartile1
# description: returns 1st quartile numeric value
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_quartile1 <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (!na.rm){
    v <- remove_missing(v)
  }
  quantiles <- quantile(v, na.rm = TRUE)
  quantiles['25%'][[1]]
}

#==============================================================================
# function name: get_quartile3
# description: returns 3rd quartile numeric value
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_quartile3 <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (!na.rm){
    v <- remove_missing(v)
  }
  quantiles <- quantile(v, na.rm = TRUE)
  quantiles['75%'][[1]]
}
# function name: get_median
# description: returns median value of numeric vector
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
get_median <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (na.rm){
    v <- remove_missing(v)
  }
  v <- sort(v)
  len <- length(v)
  if (len %% 2 != 0){
    remainder <- len %% 2
    middleIndex <- (len-remainder) / 2 + remainder
    v[middleIndex]
  } else if (len %% 2 == 0){
    middleIndex_left <- len / 2
    middleIndex_right <- len / 2 + 1
    (v[middleIndex_left] + v[middleIndex_right]) / 2 
  }
}

#==============================================================================
# function name: get_average
# description: returns average value of numeric vector
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_average <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (na.rm){
    v <- remove_missing(v)
  }
  
  sum <- 0 
  for (i in v){
    sum <- sum + i
  }
  
  sum / length(v)
  
}

#==============================================================================
# function name: get_stdev
# description: returns standard deviation of values in numeric vector
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
get_stdev <- function(v = c(1, 4, 7, NA, 10), na.rm = TRUE){
  if (!is.numeric(v)){
    stop('Input vector must be numeric type.')
  }
  if (na.rm){
    v <- remove_missing(v)
  }
  avg <- get_average(v)
  constant <- 1 / (length(v) - 1)
  sum <- 0
  for (i in v){
   sum <- sum + (i - avg)^2
  }
  sqrt(constant * sum)
}

#==============================================================================
# function name: count_missing 
# description: returns numeric value of number of missing values in input vector 
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
count_missing <- function(v = c(1, 4, 7, NA, 10)){
  count <- 0
  for (i in v){
    for (j in i){
      if (is.na(j)){
        count <- count + 1 
      }
    }
  }
  return(count)
}

#==============================================================================
# function name: summary_stats
# description: returns a list of following summary statistics: minimum, maximum, 
# median, mean, standard deviation, 10th percentile, 90th percentile, 1st 
# quartile, 3rd quartile, range, number of missing values
# input: numeric vector and optional logical 'na.rm'
# output: numeric value
#==============================================================================
summary_stats <- function(v = c(1, 4, 7, NA, 10)){
  stats <- list()
  stats$minimum <- get_minimum(v)
  stats$percent10 <- get_percentile10(v)
  stats$quartile1 <- get_quartile1(v)
  stats$median <- get_median(v)
  stats$mean <- get_average(v)
  stats$quartile3 <- get_quartile3(v)
  stats$percent90 <- get_percentile90(v)
  stats$maximum <- get_maximum(v)
  stats$range <- get_range(v)
  stats$stdev <- get_stdev(v)
  stats$missing <- count_missing(v)
  return(stats)
}

#==============================================================================
# function name: reformat
# description: returns a formatted double number with 4 significant digits
# input: numeric value
# output: character
#==============================================================================
reformat <- function(x){
  return(format(x, nsmall = 4))
}

#==============================================================================
# function name: print_stats
# description: prints summary statistics to console
# input: list of summary statistics
# output: string of summary statistics with format 'statistic: value'
#==============================================================================
print_stats <- function(v = summary_stats()){
  fields <- str_pad(string = names(v),
                    width = 9,
                    side = 'right',
                    pad = " ")
  i <- 1
  while(i <= length(v)){
    field <- names(v)[i]
    fieldValue <- v[field][[1]]
    cat(fields[i], ':', reformat(round(fieldValue, 4)), '\n')
    i <- i + 1
  }
} 

#==============================================================================
# function name: drop_lowest
# description: return numeric vector with minimum value removed
# input: numeric vector
# output: numeric vector
#==============================================================================
drop_lowest <- function(v = c(10, 10, 8.5, 4, 7, 9)){
  new <- vector(mode = 'double', length = 0)
  min <- get_minimum(v) 
  i <- 1
  j <- 1
  while (i <= length(v)) {
    if (v[i] == min & j == 1) {
      j <- j - 1
      } else if ((v[i] != min) | (v[i] == min & j == 0)){
        new <- append(new, v[i])
        }
    i <- i + 1
    }
  return(new)
}

#==============================================================================
# function name: rescale100
# description: return numeric vector with each value normalized by xmax - xmin
# input: numeric vector and minimum and maximum x scale value
# output: numeric vector
#==============================================================================
rescale100 <- function(v = c(18, 15, 16, 4, 17, 9), xmin = 0, xmax = 20){
  if (!is.numeric(xmin)){
    stop('xmin must be numeric type.')
  } else if (!is.numeric(xmax)){
    stop('xmax must be numeric type.')
  }
 rescaled <- c()
 scale <- xmax - xmin
 for (i in v){
   z <- 100 * (i - xmin) / scale
   rescaled <- append(rescaled, z)
 }
 return(rescaled)
}

#==============================================================================
# function name: score_homework
# description: return average value of numeric vector
# input: numeric vector and boolean to drop minimum value 
# output: numeric value
#==============================================================================
score_homework <- function(v = c(100, 80, 30, 70, 75, 85), drop = FALSE){
  if (drop){
    return(get_average(drop_lowest(v)))
  } else {
    return(get_average(v))
  }
}

#==============================================================================
# function name: score_quiz
# description: return average value of numeric vector 
# input: numeric vector and boolean to drop minimum value 
# output: numeric value
#==============================================================================
score_quiz <- function(v = c(100, 80, 70, 0), drop = FALSE){
  if (drop){
    return(get_average(drop_lowest(v)))
  } else {
    return(get_average(v))
  }
}

#==============================================================================
# function name: score_lab
# description: return score of lab 
# input: numeric value
# output: numeriv value
# need to return error for numbers greater than 12 i.e. score_lab(100)
#==============================================================================
score_lab <- function(score){
  if (score == 11 || score == 12){
    return(100)
  } else if (score == 10){
    return(80)
  } else if (score == 9){
    return(60)
  } else if (score == 8){
    return(40)
  } else if (score == 7){
    return(20)
  } else if (score <= 6){
    return(0)
  } else { stop('Invalid input: score must be between 0 and 12.')}
}