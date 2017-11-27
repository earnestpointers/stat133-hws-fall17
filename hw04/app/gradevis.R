#==============================================================================
# Title: Shiny App Front-end and Back-end Code
# Description: Renders Shiny app UI with cleaned data and 
# Description cont'd: responds to user input
# Input: User selects tabs, variables for plots, and regression model
# Output: Barplot, histogram, scatterplots, data summaries, and
# Output cont'd: correlation coefficient
# Author: Bryant Luong
# Date: 2017-11-26
#==============================================================================
# =============================================================================
# LOAD LIBRARIES AND FUNCTIONS.R
# =============================================================================
library(shiny)
library(ggplot2)
library(ggvis)
library(dplyr)
source('../code/functions.R')

# =============================================================================
# MAKE DATA FRAME FOR CLEANED DATA
# =============================================================================
# load data
cleandata <- read.csv(file = '../data/cleandata/cleanscores.csv', sep = ',')
    
# Create data frame for barplot
freq <- summary(cleandata$Grade)
tbl <- data.frame("Grades" = names(freq), 
                  "Freq" = freq, 
                  "Prop" = round(freq/sum(freq), digits = 2))
# Reorder factor for graph and store ordered data into its own variable
tbl$Grades = factor(tbl$Grades, 
                      levels(tbl$Grades)[c(3, 1, 2, 6, 4, 5, 9, 7, 8, 10 ,11)])
graph = tbl

# Reorder data in data frame for table
tbl$Grades = tbl$Grades[c(3, 1, 2, 6, 4, 5, 9, 7, 8, 10 ,11)]
tbl$Freq = tbl$Freq[c(3, 1, 2, 6, 4, 5, 9, 7, 8, 10 ,11)]
tbl$Prop = tbl$Prop[c(3, 1, 2, 6, 4, 5, 9, 7, 8, 10 ,11)]

# Remove first(X) and last(Grade) column of data so user cannot choose them
scatter_choices = names(cleandata)[2:23]
# =============================================================================
# BEGINNING OF UI FUNCTION
# =============================================================================
ui = fluidPage(
  titlePanel(h1("Grade Visualizer by Bryant Luong")),
  
  sidebarLayout(
    sidebarPanel(
# =============================================================================
# BARPLOT SIDEBAR UI CODE BELOW
# =============================================================================
      conditionalPanel(condition = "input.tab1 == 1",
                       h3('Grades Distribution'),
                       tableOutput('distTbl')),
# =============================================================================
# HISTOGRAM SIDEBAR UI CODE BELOW
# =============================================================================
      conditionalPanel(condition = "input.tab1 == 2",
                       selectInput(inputId = 'histx',
                                   label = h3("X-axis variable"),
                                   choices = names(cleandata)[2:23]),
                       sliderInput(inputId = 'width',
                                   label = h3('Bin Width'),
                                   min = 1,
                                   max = 10, 
                                   value = 10,
                                   step = 1)),
# =============================================================================
# SCATTERPLOT SIDEBAR UI CODE BELOW
# =============================================================================
    conditionalPanel(condition = "input.tab1 == 3",
                     selectInput(inputId = "x",
                                 label = h3("X-axis variable"),
                                 choices = rev(scatter_choices)),
                     selectInput(inputId = "y",
                                 label = h3("Y-axis variable"),
                                 choices = scatter_choices),
                     sliderInput(inputId = "opacity",
                                 label = h3("Opacity"),
                                 min = 0,
                                 max = 1,
                                 value = 0.5, 
                                 step = 0.1),
                     radioButtons(inputId = 'line',
                                  label = h3("Show line"),
                                  choices = c('none', 'lm', 'loess'),
                                  selected = 'none'))),
# =============================================================================
# TAB UI CODE BELOW
# GRAPH UI CODE BELOW 
# =============================================================================
    mainPanel(
      tabsetPanel(id = 'tab1',
        tabPanel(title = "Barchart", value = 1,
                 ggvisOutput('barPlot')),
        tabPanel(title = "Histogram", value = 2,
                 ggvisOutput("histoPlot"),
                 h3('Summary Statistics'),
                 verbatimTextOutput(outputId = "summary")),
        tabPanel(title = "Scatterplot", value = 3,
                 ggvisOutput("scatterPlot"),
                 h3("Correlation:"),
                 verbatimTextOutput(outputId = "corr"))
      )
    )
  )
)
# =============================================================================
# BEGINNING OF SERVER FUNCTION
# =============================================================================
server <- function(input, output) {
# =============================================================================
# BARPLOT CODE BELOW
# =============================================================================
  # make Grade Distribution table
  output$distTbl <- renderTable(tbl)
  # make barplot
  bar_plot <- graph %>% ggvis(x = ~Grades, y = ~freq) %>% layer_bars()
  bar_plot %>% bind_shiny("barPlot")
# =============================================================================
# HISTOGRAM CODE BELOW
# =============================================================================
  # Create and render histogram for user-selected field
  vis_plot <- reactive({
    xvar <- prop("x", as.symbol(input$histx))
    histogram <- cleandata %>%
      ggvis(x = xvar) %>%
      layer_histograms(fill := '#abafb4', 
                       stroke := 'white', 
                       width = input$width)
  })
  vis_plot %>% bind_shiny("histoPlot")
  
  # Generate summary for user-selected field
  output$summary <- renderPrint({
    cleandata_col <- cleandata[input$histx]
    print_stats(summary_stats(cleandata_col[[1]]))
  })
# =============================================================================
# SCATTERPLOT CODE BELOW
# =============================================================================
  # calculate correlation between 2 variables chosen by user
  output$corr <- renderText({
    cor(x = cleandata[input$x], y = cleandata[input$y])
  })
  # Create and render scatterplot for user-selected field
  scatter_plot <- reactive({
    # Normally we could do something like props(x = ~HW1, y = ~HW2),
    # but since the inputs are strings, we need to do a little more work.
    x <- prop("x", as.symbol(input$x))
    y <- prop("y", as.symbol(input$y))
    if (input$line == 'none'){
    scatterplot <- cleandata %>%
      ggvis(x = x, y = y) %>%
      layer_points(fill := rgb(0.6, 0.3, 0.1, input$opacity))
    } else if (input$line == 'lm') {
    scatterplot <- cleandata %>%
      ggvis(x = x, y = y) %>%
      layer_points(fill := rgb(0.6, 0.3, 0.1, input$opacity)) %>%
      layer_model_predictions(model = "lm")
    } else if (input$line == "loess"){
    scatterplot <- cleandata %>%
      ggvis(x = x, y = y) %>%
      layer_points(fill := rgb(0.6, 0.3, 0.1, input$opacity)) %>%
      layer_model_predictions(model = "loess")
    }
  })
  scatter_plot %>% bind_shiny("scatterPlot")
}
# =============================================================================
# Run the application 
# =============================================================================
shinyApp(ui = ui, server = server)