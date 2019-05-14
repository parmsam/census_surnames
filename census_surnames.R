# Created by SAM on 2019-05-14
# Validated by NAME on YEAR-MT-DY
# Purpose: Pull census info on group of surnames that the user can specify 
# Use Case: Show group of friends how common their last names are in the US 
# Production Schedule (if program is to be run on a regular basis):
# Limitations and Warnings: 
# Data Source Info: https://www.census.gov/data/developers/data-sets/surnames.html
#   API: api.census.gov/data/2010/surname
#   Provides frequency, prop per 100,000, percent by race/ethnicity for name, and rank
# Program Derived From "other_program_name.R" (if applicable)
# Program Flow Description (high level review of the steps of the program) ; ----
#  1) Load libraries and define key parameters
#  2) Create api function
#  3) Test out single names
#  4) Create list of multiple names 
#  5) Obtain surname data on group of names
#  X) Clean up. 

# Leave mark at beginning of program log see when the run started (if needed)
#print("###############################################")
#paste("Run started at", Sys.time())
#print("###############################################")

# 1) Load libraries and define key constants, formats, etc. ; ----
#### PROJECT CODE GOES HERE ####
library(tidyverse)
library(knitr)
library(httr)
library(jsonlite)

# 2) Create api pull function ; ----
surname_datpull<-function(name){
  base_url <- "https://api.census.gov/data/2010/surname?get=RANK,COUNT,PCTAIAN,PCTAPI,PCTBLACK,PCTHISPANIC,PCTWHITE,PCT2PRACE,CUM_PROP100K&NAME="
  query_url<-paste0(base_url,name)
  api_response <- GET(query_url)
  api_response_json <- content(api_response, as = "text")
  
  api_data <- fromJSON(api_response_json) %>% data.frame() 
  
  api_data<- api_data %>% mutate_if(is.factor, as.character) %>% data.frame()
  
  colnames(api_data)<-api_data[1,]
  api_data<-api_data[-1,] %>% data.frame()  %>% select(NAME,everything())
  return(api_data)
}
# 3) Test single name ; -----
surname_datpull("JOHNSON") %>% glimpse() #working for single name
# 4) Create list of names of interest ; ----
list_names<-c("JOHNSON","SMITH","JONES", "PATEL", "NGO")  #testing for multiple names
# 5) Pass list of names through api and obtain data frame output
a<-map(list_names,surname_datpull) %>% bind_rows(); a %>% print() #working for multiple names
#can now pass group of names onto the census api to 

# X) Clean up. ----
# Delete all objects that were created to clean up environment
# Uncomment when ready to run
#rm(list=ls())

# Leave mark at end of program to see when the run ended (if needed)
#print("###############################################")
#paste("Run ended at", Sys.time())
#print("###############################################")
