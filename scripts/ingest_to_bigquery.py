
import os
import json
import pandas as pd
from google.cloud import storage, bigquery

# ---- CONFIG ----
PROJECT_ID = "freshcart-platform"
DATASET_ID = "raw"
BUCKET_NAME = f"{PROJECT_ID}-raw-bucket"
CREDENTIALS_PATH = "../credentials/sa-key.json"
CONFIG_PATH = "../config/datasets_config.json"

# ---- HELPERS ----

def read_and_validate_csv(csv_path, required_columns):
    print(f"Reading {csv_path}")
    df = pd.read_csv(csv_path)
    for col in required_columns:
        if col not in df.columns:
            raise ValueError(f"Missing required column: {col}")
    return df

def save_as_parquet(df, parquet_path):
    df.to_parquet(parquet_path, index=False)
    print(f"Saved Parquet: {parquet_path}")

def upload_to_gcs(parquet_path, blob_name):
    client = storage.Client.from_service_account_json(CREDENTIALS_PATH)
    bucket = client.bucket(BUCKET_NAME)
    blob = bucket.blob(blob_name)
    blob.upload_from_filename(parquet_path)
    print(f"Uploaded to GCS: gs://{BUCKET_NAME}/{blob_name}")

def load_to_bigquery(blob_name, table_name):
    client = bigquery.Client.from_service_account_json(CREDENTIALS_PATH)
    table_id = f"{PROJECT_ID}.{DATASET_ID}.{table_name}"
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.PARQUET,
        autodetect=True,
        write_disposition="WRITE_TRUNCATE"
    )
    uri = f"gs://{BUCKET_NAME}/{blob_name}"
    load_job = client.load_table_from_uri(uri, table_id, job_config=job_config)
    load_job.result()
    print(f"Loaded into BigQuery: {table_id}")

# ---- MAIN PIPELINE ----

def main():
    with open(CONFIG_PATH) as f:
        config = json.load(f)

    for table_name, settings in config.items():
        csv_path = settings["csv_path"]
        required_columns = settings["required_columns"]
        parquet_path = csv_path.replace(".csv", ".parquet")
        blob_name = f"raw/{table_name}.parquet"

        print(f" Processing table: {table_name}")
        try:
            df = read_and_validate_csv(csv_path, required_columns)
            save_as_parquet(df, parquet_path)
            upload_to_gcs(parquet_path, blob_name)
            load_to_bigquery(blob_name, table_name)
        except Exception as e:
            print(f" Failed to process {table_name}: {e}")

if __name__ == "__main__":
    main()
