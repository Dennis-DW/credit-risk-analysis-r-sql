import pandas as pd
import json
import os

def run_validation():
    files = {
        'transactions': 'data/python_transactions.csv',
        'ground_truth': 'data/ground_truth.csv',
        'predictions': 'data/predictions.csv',
        'output_json': 'data/validation_summary.json' 
    }

    print("--- 1. LOADING DATA ---")
    try:
        trans = pd.read_csv(files['transactions'])
        ground = pd.read_csv(files['ground_truth'])
        preds = pd.read_csv(files['predictions'])
        print("Success: All files loaded.")
    except FileNotFoundError as e:
        print(f"Error: {e}. Check your 'data' folder.")
        return

    # --- PART A: DATA QUALITY CHECKS ---
    print("\n--- 2. RUNNING CHECKS ---")
    
    missing_merchants = int(trans['merchant_name'].isnull().sum())
    negative_amounts = int((trans['amount'] < 0).sum())
    duplicates = int(trans['transaction_id'].duplicated().sum())

    print(f"Negative Amounts found: {negative_amounts}")

    # --- PART B: CLASSIFIER EVALUATION ---
    merged = pd.merge(ground, preds, on='transaction_id')
    
    correct_count = int(merged[merged['true_category'] == merged['predicted_category']].shape[0])
    total_count = int(len(merged))
    error_count = total_count - correct_count
    accuracy = correct_count / total_count

    # Analyze Errors by Category
    merged['is_error'] = merged['true_category'] != merged['predicted_category']
    errors_df = merged[merged['is_error'] == True]
    
    # Get top error categories
    error_counts = errors_df['true_category'].value_counts()
    
    # Prepare data for export
    results = {
        "data_quality": {
            "labels": ["Negative Amounts", "Missing Merchants", "Duplicate IDs"],
            "values": [negative_amounts, missing_merchants, duplicates]
        },
        "accuracy": {
            "correct": correct_count,
            "errors": error_count,
            "total": total_count,
            "percent": round(accuracy * 100, 2)
        },
        "error_breakdown": {
            "categories": error_counts.index.tolist(),
            "counts": error_counts.values.tolist()
        }
    }

    # --- SAVE RESULTS ---
    with open(files['output_json'], 'w') as f:
        json.dump(results, f, indent=4)
    
    print(f"\n[SUCCESS] Results saved to '{files['output_json']}'")

if __name__ == "__main__":
    run_validation()
