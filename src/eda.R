#! /usr/bin/env Rscript 
# Authors: Alden Chen, Birinder Singh
# Date: 2018/11/23
# This script takes in the titanic dataset and does some
# exploratory data analysis. It produces a set of box and 
# bar plots and saves them to the specified folder. It takes
# two arguments: the input file location, and the folder to store
# the results in
# usage: Rscript src/eda.R "data/titanic_data.csv" "results"

library(tidyverse)
library(grid)

args = commandArgs(trailingOnly = TRUE)
input = args[1]
output = args[2]


main <- function(){
  
  require(tidyverse)
  require(grid)
  titanic_data <- read_csv(input)
  
  # create factors
  titanic_data <- titanic_data %>% 
    mutate(Sex = as.factor(Sex),
           Survived = as.factor(Survived),
           Embarked = as.factor(Embarked),
           Pclass = as.factor(Pclass)) 
  
  # replace 1s and 0s with category names
  titanic_data <- titanic_data %>% 
    mutate(Survived = fct_recode(titanic_data$Survived,
                      "Survived" = "1",
                      "Died" = "0"),
           Sex = fct_recode(titanic_data$Sex,
                            "Female" = "0",
                            "Male" = "1"))
  
  # box plot of port of age vs survival
  boxplot_age <- titanic_data %>% 
    ggplot(aes(x = Survived, y = Age)) +
    geom_boxplot() +
    geom_jitter(alpha = 0.2) +
    ggtitle("Survival vs Age") +
    xlab(" ")+theme_bw()+
    theme(plot.title=element_text(size= 30 ), strip.text=element_text(size=25), text= element_text(size=26))
  
  # box plot of port of fare vs survival
  boxplot_fare <- titanic_data %>% 
    ggplot(aes(x = Survived, y = Fare)) +
    geom_boxplot() +
    geom_jitter(alpha = 0.2) +
    ylim(0, 135) +
    ggtitle("Survival vs Fare") +
    xlab(" ")+theme_bw()+
    theme(plot.title=element_text(size= 30 ), strip.text=element_text(size=25), text= element_text(size=26))
  
  # bar plot of count of survivors
  barplot_survival <- titanic_data %>% 
    ggplot(aes(x = Survived)) +
    geom_bar() +
    ggtitle("Survival")
  
  # bar plot of port of sex vs survival
  barplot_sex_survival <- titanic_data %>%
    ggplot(aes(x = Survived)) +
    geom_bar() +
    facet_wrap(~Sex) +
    ggtitle("Survival by Sex") +
    xlab(" ")+theme_bw()+
    theme(plot.title=element_text(size= 30 ), strip.text=element_text(size=25), text= element_text(size=27))
  
  # bar plot of port of passenger class vs survival
  barplot_class_survival <- titanic_data %>% 
    ggplot(aes(x = Survived)) +
    geom_bar() +
    facet_wrap(~Pclass) +
    ggtitle("Survival by Cabin Class") +
    xlab(" ")+theme_bw()+
    theme(plot.title=element_text(size= 30 ), 
          strip.text=element_text(size=25), text= element_text(size=23))
  
  # bar plot of port of embarkation vs survival
  barplot_port_survival <- titanic_data %>% 
    mutate(Embarked = fct_recode(titanic_data$Embarked, 
                                 "Cherbourg" = "1",
                                 "Queenstown" = "2",
                                 "Southampton" = "3")) %>% 
    ggplot(aes(x = Survived)) +
    geom_bar() +
    facet_wrap(~Embarked) +
    ggtitle("Survival by Embarkation Port")+
    xlab(" ")+theme_bw()+
    theme(plot.title=element_text(size= 30 ), strip.text=element_text(size=23), text= element_text(size=23))
  
  # save plots
  ggsave("eda_boxplot-age-survival.png", plot = boxplot_age, device = "png",
         path = output)
  ggsave("eda_boxplot-fare-survival.png", plot = boxplot_fare, device = "png",
         path = output)
  ggsave("eda_barplot-survival.png", plot = barplot_survival, device = "png",
         path = output)
  ggsave("eda_barplot-sex-survival.png", plot = barplot_sex_survival, device = "png",
          path = output)
  ggsave("eda_barplot-class-survival.png", plot = barplot_class_survival, device = "png",
         path = output)
  ggsave("eda_barplot-port-survival.png", plot = barplot_port_survival, device = "png",
         path = output)

  
  }

main()
  

