# ========================================================================
# author: Bryant Luong
# title: Data Preparation Script for HW03
# description: This script prepares the data for PCA in HW03. Specifically, 
# it creates 3 tables: NBAstats, NBAroster, and teams. Then, 2 summary 
# text files, 1 star plot, and 1 scatterplot is outputted. The script also
# has @knitr groups so the script can be used in an Rmd file.
# input(s): nba2017-stats.csv, nba2017-roster.csv
# output(s): efficiency-summary.txt, teams-summary.txt, nba2017-teams.csv
# output(s): teams_star_plot.pdf, experience_salary.pdf
# ========================================================================

## @knitr packages
# load packages
library(dplyr)
library(readr)
library(ggplot2)

## @knitr tables
# read tables into R and store into 2 new objects
NBAstats <- read_csv(file = "../data/nba2017-stats.csv")
NBAroster <- read_csv(file = "../data/nba2017-roster.csv")

# add 5 new variables to NBAstats 
# missed_fg
NBAstats <- mutate(NBAstats, 
                   missed_fg = field_goals_atts - field_goals_made)
# missed_ft
NBAstats <- mutate(NBAstats,
                    missed_ft = points1_atts - points1_made)
# points
NBAstats <- mutate(NBAstats,
                   points = points1_made + 2*points2_made + 3*points3_made)
# rebounds
NBAstats <- mutate(NBAstats,
                   rebounds = off_rebounds + def_rebounds)
# efficiency
NBAstats <- mutate(NBAstats,
                   efficiency = (points + rebounds + assists + steals + 
                                   blocks -  missed_fg - missed_ft 
                                 - turnovers)/games_played)

## @knitr summaryEfficiency
# send summary(NBAstats) output to efficiency-summary.txt
sink(file = "../output/efficiency-summary.txt")
summary(NBAstats)
sink()

## @knitr teams
# merge the data frames NBAstats and NBAroster with merge()
m <- merge(NBAroster, NBAstats)

# create data frame 'teams'
teams <- m %>% group_by(team) %>% summarise(experience = round(sum(experience), digits = 2),
                                            salary = round(sum(salary)/1000000, digits = 2),
                                            points3 = sum(points3_made),
                                            points2 = sum(points2_made),
                                            free_throws = sum(points1_made),
                                            points = sum(points1_made + 2*points2_made 
                                                         + 3*points3_made),
                                            off_rebounds = sum(off_rebounds),
                                            def_rebounds = sum(def_rebounds),
                                            assists = sum(assists),
                                            steals = sum(steals),
                                            blocks = sum(blocks),
                                            turnovers = sum(turnovers),
                                            fouls = sum(fouls),
                                            efficiency = sum(efficiency))


## @knitr summaryTeams
# send summary(teams) to teams-summary.txt
sink(file = "../output/teams-summary.txt")                                          
summary(teams)                                         
sink()                                            

## @knitr nab2017
# create nba2017-teams.csv
write_csv(x = teams, path = "../data/nba2017-teams.csv")

## @knitr plots
# create star plot for data in 'teams' data frame and save as 'teams_star_plot.pdf'
stars(teams[,-1], 
      labels = teams$team)

# create scatterplot of experience and salary using ggplot
# create initial plot
p <- ggplot(data = teams, 
            mapping = aes(x = experience, y = salary, label = team))

# add points and team label to plot and adjust relative distance of text to point
ppt <- p + geom_point(colour = "red") + geom_text(vjust = 0.5, hjust = 0, size = 2.5, nudge_x = 1.2, angle = 30)

# add axis labels, title, and caption
ppta <- ppt + labs(x = "Total Years of Experience", 
                   y = "Total Salary of Team ($, millions)",
                   title = "Scatterplot of Total Years of Experience and Total Salary of Team",
                   caption = "Data Source: basketball-reference.com")

# call plot and save as experience_salary.pdf
ppta
