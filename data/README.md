# Data Science Support Intern - Assessment Datasets

## Overview
This folder contains all the datasets you'll need for the technical assessment. Please read this document carefully before starting.


## Data Dictionary

### transactions.csv
| Column | Type | Description |
|--------|------|-------------|
| transaction_id | Integer | Unique transaction identifier |
| user_id | Integer | User identifier (1001-1200) |
| amount | Float | Transaction amount in KES |
| transaction_date | Datetime | When transaction occurred |
| merchant_name | String | Name of merchant/service |
| category | String | Transaction category (NULL if unclassified) |

**Row Count:** 1,000 transactions  
**Date Range:** Last 45 days from current date

### users.csv
| Column | Type | Description |
|--------|------|-------------|
| user_id | Integer | Unique user identifier |
| credit_score | Integer | Credit score (300-850) |
| registration_date | Datetime | When user registered |
| default_flag | Integer | 1 if user has defaulted, 0 otherwise |

**Row Count:** ~200 unique users


### python_transactions.csv
| Column | Type | Description |
|--------|------|-------------|
| transaction_id | Integer | Unique transaction identifier |
| merchant_name | String | Merchant name (may have NULLs) |
| amount | Float | Transaction amount (may be invalid) |
| transaction_date | String | Transaction timestamp (may be invalid) |
| description | String | Transaction description |

**Row Count:** 200 transactions  
**Note:** Contains data quality issues for validation testing

### ground_truth.csv
| Column | Type | Description |
|--------|------|-------------|
| transaction_id | Integer | Transaction identifier |
| description | String | Transaction description |
| true_category | String | Correct category (manual label) |

**Row Count:** 150 transactions

### predictions.csv
| Column | Type | Description |
|--------|------|-------------|
| transaction_id | Integer | Transaction identifier (matches ground_truth) |
| predicted_category | String | Category predicted by classifier |

**Row Count:** 150 transactions  
**Note:** Should match ground_truth by transaction_id

---

## Categories Reference

The following transaction categories are used in the datasets:
- **Airtime** - Mobile airtime purchases
- **Groceries** - Supermarket and grocery shopping
- **Food** - Restaurants and food delivery
- **Transport** - Uber, taxis, matatus
- **Shopping** - General retail purchases
- **Utilities** - Water, electricity, internet bills
- **Banking** - Bank transfers and services
- **Fuel** - Petrol station purchases
