library(DBI)
library(RSQLite)
library(tidyverse)
library(scales)

print(">>> STARTING PROJECT PIPELINE...")
print("------------------------------------------")
print(">>> PHASE 1: GENERATING R CHARTS...")


# Run R Chart Scripts
# prevent crashing if a file is missing
run_script_safely("plot_credit_scores.R")
run_script_safely("plot_category_volume.R")
run_script_safely("plot_risk_by_category.R") 
run_script_safely("plot_latest_user_activity.R")
run_script_safely("plot_daily_trend.R")
run_script_safely("plot_top_users.R")

print("------------------------------------------")
print(">>> PHASE 2: RUNNING PYTHON VALIDATION...")

# Run Python Scripts
# 'system' to tell the terminal to run the python commands

# Run the Validation Logic
print("   [Running] python_validation.py ...")
# 'wait=TRUE' ensures R waits for Python to finish before continuing
result_val <- system("python3 python_validation.py", wait = TRUE)

if (result_val == 0) {
  print("   [Success] Validation Data Saved.")
} else {
  print("   [WARNING] Validation script failed. Check if 'python_validation.py' is in the root folder.")
}

# Step B: Run the Visualization
print("   [Running] visualize_results.py ...")
result_viz <- system("python3 visualize_results.py", wait = TRUE)

if (result_viz == 0) {
  print("   [Success] Python Charts Saved.")
} else {
  print("   [WARNING] Visualization script failed.")
}

print("==========================================")
print(">>> PIPELINE COMPLETE.")
print(">>> 1. R Charts are in 'presentation_plots/'")
print(">>> 2. Python Results are in 'data/'")
print("==========================================")