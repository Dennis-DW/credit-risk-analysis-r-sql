## Project Overview

This repository contains the end-to-end solution for the **Pezesha Data Analysis Assessment**. The project implements a scalable data pipeline that ingests raw transaction logs, validates data quality, audits machine learning predictions, and generates executive-level visualizations.

The solution adopts a "Best Tool for the Job" philosophy:
* **R (tidyverse + ggplot2):** Used for exploratory data analysis (EDA), SQL integration, and generating high-quality static reporting charts.
* **Python (pandas):** Used for robust data validation, automated quality checks, and performance metrics calculation for the ML classifier.

##  Project Structure

The project is organized into modular scripts to ensure reproducibility and ease of debugging.


## Methodology

### 1. Data Ingestion & SQL Querying

Data is loaded into an in-memory `SQLite` database within R. This simulates a real-world production environment where data is queried from a warehouse rather than loaded from flat CSVs.

### 2. Exploratory Data Analysis (EDA)

Utilized `ggplot2` to visualize key financial metrics:

* **Risk Profiling:** Comparing credit score distributions for defaulting vs. non-defaulting users.
* **Spend Analysis:** Identifying high-volume transaction categories (Utilities, Groceries).
* **User Segmentation:** Ranking users by activity frequency to identify "Power Users."

### 3. Automated Validation Pipeline

A Python script (`python_validation.py`) acts as a quality gatekeeper:

* **Sanity Checks:** Flags logical errors (e.g., negative transaction amounts).
* **Completeness:** Checks for missing merchant names or IDs.
* **Model Audit:** Compares `predictions.csv` against `ground_truth.csv` to calculate accuracy and identify specific confusion patterns (e.g., *Food* vs. *Groceries*).


## Data Dictionary

The following datasets are used in this analysis:

| File Name | Description | Key Columns |
| --- | --- | --- |
| **`transactions.csv`** | Primary transaction ledger used for R visualizations. | `user_id`, `amount`, `transaction_date`, `merchant_name` |
| **`python_transactions.csv`** | Dataset used specifically for data quality validation. | `transaction_id`, `amount`, `description` |
| **`ground_truth.csv`** | Contains verified true categories for testing. | `transaction_id`, `true_category` |
| **`predictions.csv`** | The output from the ML classifier being tested. | `transaction_id`, `predicted_category` |


## Setup & Requirements

### 1. R Dependencies

Run this command in your R Console to install the necessary packages:

```r
install.packages(c("DBI", "RSQLite", "tidyverse", "scales", "ggplot2"))

```

### 2. Python Dependencies

Run this command in your Terminal to install the necessary libraries:

```bash
pip install pandas matplotlib numpy

```

## How to Run

### Option A: The "One-Click" Pipeline (Recommended)

You can trigger the entire analysis—SQL queries, R charts, and Python validation—from a single entry point.

1. Open **RStudio**.
2. Open **`analysis.R`**.
3. Click the **Source** button (or run the line below):

```r
source("analysis.R")

```

**What happens?**

> 1. It executes all 6 R scripts in the `R/` folder.
> 2. It automatically saves the charts to `presentation_plots/`.
> 3. It triggers the Python validation scripts to generate the quality report.
> 4. It saves the Python results to the `data/` folder.

## Outputs & Deliverables

After execution, the following artifacts are generated:

| Output Folder | File Name | Description |
| --- | --- | --- |
| **`presentation_plots/`** | `1_credit_score_density.png` | Distribution of scores for Defaulters vs. Good Users |
|  | `2_volume_bar.png` | Total transaction volume per category |
|  | `3_risk_lollipop.png` | Risk ranking (Default Rate) by category |
|  | `4_latest_activity_scatter.png` | Snapshot of user recency and amounts |
|  | `5_daily_trend.png` | Daily transaction trends (Last 30 Days) |
|  | `6_top_users_ranked.png` | Top 5 most active users (Gold/Silver/Bronze) |
| **`data/`** | `part3_summary_charts.png` | **Python Dashboard**: Data Quality & Accuracy Visuals |
|  | `validation_summary.json` | Raw metrics for the validation report |


## Future Improvements

To scale this project for production, the following improvements are recommended:

* **Dockerization:** Containerize the pipeline to ensure it runs identically on any machine without manual package installation.
* **Unit Testing:** Add `testthat` (R) and `pytest` (Python) to verify data transformations before plotting.
* **Interactive Dashboard:** Migrate static R plots to a **Shiny App** for real-time data exploration by stakeholders.