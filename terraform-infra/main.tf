terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_path)
}

# Google Cloud Storage bucket
resource "google_storage_bucket" "raw_data" {
  name          = "${var.project_id}-raw-bucket"
  location      = var.region
  force_destroy = true
}

# BigQuery Datasets
resource "google_bigquery_dataset" "raw" {
  dataset_id = "raw"
  location   = var.region
}

resource "google_bigquery_dataset" "staging" {
  dataset_id = "staging"
  location   = var.region
}

resource "google_bigquery_dataset" "marts" {
  dataset_id = "marts"
  location   = var.region
}
