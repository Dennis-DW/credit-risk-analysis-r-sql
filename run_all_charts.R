library(DBI)
library(RSQLite)
library(tidyverse)
library(scales)

print(">>> STARTING CHART GENERATION...")

#Helper function to run scripts inside the 'R' folder
run_script_safely <- function(script_name) {
  file_path <- file.path("R", script_name)
  
  if (file.exists(file_path)) {
    print(paste("   [Running]", script_name, "..."))
    source(file_path)
  } else {
    print(paste("   [ERROR] File missing:", file_path))
    print("   -> Please check if you saved this file in the 'R' folder with this exact name.")
  }
}

#Run Individual Chart Scripts
print("   [1/6] Generating Credit Score Distribution...")
source("R/plot_credit_scores.R")

print("   [2/6] Generating Category Volume Chart...")
source("R/plot_category_volume.R")

print("   [3/6] Generating Risk Lollipop Chart...")
source("R/plot_risk_by_category.R")

print("   [4/6] Generating Latest User Activity Scatter Plot...")
source("R/plot_latest_user_activity.R")

print("   [5/6] Generating Daily Trend Area Chart...")
source("R/plot_daily_trend.R")

print("   [6/6] Generating Top Users Ranked Bar Chart...")
source("R/plot_top_users.R")

print("==========================================")
print(">>> SUCCESS! All charts saved to 'presentation_plots' folder.")
print("==========================================")