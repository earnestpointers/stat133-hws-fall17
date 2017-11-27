#==============================================================================
# Title: Cleans our data using 'Functions.R'
# Description: Runs unit tests for all functions in 'functions.R'. 
# Description cont'd: Each function is tested with 4 inputs and the results are 
# Description cont'd: stored in '../output/test-reporter.txt'
# Input: Numeric values, vectors, boolean named 'na.rm' to remove empty cells
# Output: text files 
# Author: Bryant Luong
# Date: 2017-11-22
#==============================================================================
# load libraries and project-specific functions
library(stringr)
source('../code/functions.R')

#==============================================================================
# read in rawscores.csv
#==============================================================================
rawdata <- read.csv(file = "../data/rawdata/rawscores.csv", 
                    header = TRUE, 
                    sep = ',')

cleaned_data <- rawdata

#==============================================================================
# sink structure of raw data frame to summary-rawscores.txt inside output/
#==============================================================================
i <- 1
sink(file = '../output/summary-rawscores.txt')
print('Structure of Raw Scores Data Frame')
cat('\n')
str_data <- str(cleaned_data)
cat('\n')

print('Check data dictionary for column information')
cat('\n')

for (j in cleaned_data) {
  cat('Column', i, '\n')
  print_stats(summary_stats(j))
  cat('\n')
  i <- i + 1
}
sink()
#==============================================================================
# for loop to replace all NAs with 0s in columns
#==============================================================================
i <- 1
while (i <= length(cleaned_data)) {
  j <- 1
  while (j <= length(cleaned_data[[i]])) {
    if (is.na(cleaned_data[[i]][j])) {
      cleaned_data[[i]][j] = 0
    }
      j <- j + 1
  }
  i <- i + 1
}

#==============================================================================
# Rescale Lab scores
#==============================================================================
numStudents <- dim(cleaned_data)[1]
i <- 1
while(i <= numStudents){
  cleaned_data$Lab[i] <- score_lab(cleaned_data$ATT[i])
  i <- i + 1
}
#==============================================================================
# Rescale Quiz 1 scores
#==============================================================================
cleaned_data$QZ1 <- rescale100(cleaned_data$QZ1, xmin = 0, xmax = 12)

#==============================================================================
# Rescale Quiz 2 scores
#==============================================================================
cleaned_data$QZ2 <- rescale100(cleaned_data$QZ2, xmin = 0, xmax = 18)

#==============================================================================
# Rescale Quiz 3 scores
#==============================================================================
cleaned_data$QZ3 <- rescale100(cleaned_data$QZ3, xmin = 0, xmax = 20)

#==============================================================================
# Rescale Quiz 4 scores
#==============================================================================
cleaned_data$QZ4 <- rescale100(cleaned_data$QZ4, xmin = 0, xmax = 20)

#==============================================================================
# Rescale Exam 1 scores
#==============================================================================
cleaned_data$Test1 <- rescale100(cleaned_data$EX1, xmin = 0, xmax = 80)

#==============================================================================
# Rescale Exam 2 scores
#==============================================================================
cleaned_data$Test2 <- rescale100(cleaned_data$EX2, xmin = 0, xmax = 90)

#==============================================================================
# Add overall homework scores, dropping lowest
#==============================================================================
x <- 1
while (x <= numStudents){
  homeworkScores <- c(cleaned_data$HW1[x],
                      cleaned_data$HW2[x],
                      cleaned_data$HW3[x],
                      cleaned_data$HW4[x],
                      cleaned_data$HW5[x],
                      cleaned_data$HW6[x],
                      cleaned_data$HW7[x],
                      cleaned_data$HW8[x],
                      cleaned_data$HW9[x])
  cleaned_data$Homework[x] <- score_homework(homeworkScores, drop = TRUE)
  x <- x + 1
}

#==============================================================================
# Add overall quiz scores ,dropping lowest
#==============================================================================
y <- 1
while (y <= numStudents){
  quizScores <- c(cleaned_data$QZ1[y],
                  cleaned_data$QZ2[y],
                  cleaned_data$QZ3[y],
                  cleaned_data$QZ4[y])
  cleaned_data$Quiz[y] <- score_quiz(quizScores, drop = TRUE)
  y <- y + 1
}

#==============================================================================
# Add overall overall grade
#==============================================================================
z <- 1
while (z <= numStudents) {
cleaned_data$Overall[z] <- 0.1*cleaned_data$Lab[z] + 
  0.3*cleaned_data$Homework[z] + 
  0.15*cleaned_data$Quiz[z] + 
  0.2*cleaned_data$Test1[z] + 
  0.25*cleaned_data$Test2[z]

z <- z + 1

}

calc_grade <- function(v = 100) {
  if (v >= 95 & v <= 100){ 
    return('A+')
  } else if (v >= 90 & v < 95) { 
      return('A')
  } else if (v >= 88 & v < 90){ 
    return('A-')
  } else if (v >= 86 & v < 88){ 
    return('B+')
  } else if (v >= 82 & v < 86){ 
    return('B')
  } else if (v >= 79.5 & v < 82){ 
    return('B-')
  } else if (v >= 77.5 & v < 79.5){ 
    return('C+')
  } else if (v >= 70 & v < 77.5){
    return('C')
  } else if (v >= 60 & v < 70){
    return('C-')
  } else if (v >= 50 & v < 60){
    return('D')
  } else if (v >= 0 & v < 50){
    return('F')}
}

x <- 1
while (x <= numStudents) {
 cleaned_data$Grade[x] <- calc_grade(cleaned_data$Overall[x]) 
x <- x + 1
}

#==============================================================================
# for loop for sinking Lab, Test1, Test2, Quiz, Homework, Overall
#==============================================================================
fields <- names(cleaned_data)[17:22]
for (i in fields) {
  filename <- paste('../output/', i, '-stats.txt', sep = "")
  sink(file = filename, append = TRUE)
  print_stats(summary_stats(cleaned_data[i][[1]]))
  sink()
}

#==============================================================================
# sink the str of data frame with cleaned data
#==============================================================================
sink(file = '../output/summary-cleanscores.txt')
str(cleaned_data)
sink()

#==============================================================================
# save cleaned data as csv
#==============================================================================
write.csv(x = cleaned_data, file = '../data/cleandata/cleanscores.csv')
