# 🛒 Freshcart Data Platform

A complete, end-to-end modern data pipeline project designed to serve as the foundation of a future **SaaS data platform**. Built using best-in-class tools like **Terraform**, **Python**, **DBT**, and **Looker Studio**, this project automates data infrastructure, ingestion, transformation, and visualization in the cloud.

---

## 🔍 What is Freshcart?

**Freshcart** is a fictional e-commerce grocery platform modeled to simulate real-world online retail activity: customer orders, products, reviews, deliveries, and more.

This project uses Freshcart as a prototype to build and test a professional-grade data platform, laying the foundation for a scalable, multi-tenant SaaS data infrastructure in future iterations.

---

## 🧱 Architecture Overview

| Stage          | Tools Used                              |
| -------------- | --------------------------------------- |
| Infrastructure | Terraform (GCP provisioning)            |
| Data Ingestion | Python scripts (CSV to GCS to BigQuery) |
| Data Warehouse | BigQuery                                |
| Transformation | DBT (core)                              |
| Dashboarding   | Looker Studio                           |
| Automation     | GitHub Actions / Shell                  |

---

## ⚙️ Infrastructure as Code with Terraform

We use **Terraform** to provision all GCP resources:

### ✅ Steps:

1. Defined `main.tf`, `variables.tf`, and `terraform.tfvars`
2. Provisioned:

   * Google Cloud Storage bucket for raw data
   * BigQuery datasets: `raw`, `staging`, `marts`
3. Authentication via service account JSON key
4. IAM roles assigned:

   * `BigQuery Admin`
   * `Storage Admin`

```bash
cd terraform-infra
terraform init
terraform apply
```

---

## 📥 Data Ingestion with Python

Raw CSV files are loaded into GCS and then moved into BigQuery using modular and reusable Python scripts.

### ✅ Features:

* Schema validation using `pandas`
* Load to `GCS` then to `BigQuery` raw tables
* Modular scripts per entity (orders, customers, reviews, etc.)

```bash
python3 scripts/load_orders.py
python3 scripts/load_customers.py
...
```

---

## 🧪 Transformation with DBT

Data is transformed using **DBT**, with a clean staging → marts pipeline structure.

### ✅ Structure:

```
models/
├── staging/
├── marts/
│   ├── fact/
│   │   ├── fact_orders.sql
│   │   └── fact_customers.sql
│   └── dimensions/
```

### ✅ Features:

* Jinja SQL templating
* Tests, schema enforcement, documentation
* Customer geolocation enrichment
* Segmentation logic (High, Medium, Low value)

```bash
dbt run
dbt test
dbt docs generate && dbt docs serve
```

---

## 📊 Visualization with Looker Studio

Looker Studio dashboards are built directly on top of the `fact_customers` and `fact_orders` tables in BigQuery.

### ✅ Dashboard Highlights:

* KPIs: Total Orders, Total Customers, Revenue, AOV
* Geo Heatmaps: Revenue by state, customer clusters
* Trendlines: New customers over time by region
* Segments: Filter by customer segment or date

📸 Screenshots available in `/images/` folder for GitHub showcase.

---

## 🚧 Problems Solved

| Problem                            | Solution                                               |
| ---------------------------------- | ------------------------------------------------------ |
| Manual infra setup                 | Automated via Terraform                                |
| Repetitive ingestion code          | Modular Python scripts for scalable ingestion          |
| Inconsistent data modeling         | DBT with layered approach and tests                    |
| No visibility on customer behavior | Fact models with spend, review score, and time metrics |
| No geolocation context             | Enriched with zip-code level location data             |
| Hard to share insights             | Looker dashboards connected live to BigQuery           |

---

## 💡 Value Added

* 🔁 Fully automated and reproducible data pipeline
* 🧱 Professional-grade infra ready for SaaS productization
* 🧠 Insightful analytics: segmentation, behavior, and geography
* 📈 CI/CD friendly for team collaboration and growth

---

## 🚀 Future Vision

This project is the **foundation for a professional SaaS data platform**, enabling:

* Multi-tenant data modeling
* Customer-facing analytics
* Embedded dashboards
* Subscription-based insights for business clients

---

## 📁 Repo Structure

```
├── terraform-infra/         # GCP infrastructure
├── scripts/                 # Python ingestion scripts
├── models/                  # DBT models
├── macros/                  # DBT reusable logic
├── .github/workflows/       # GitHub Actions automation
├── README.md
└── images/                  # Dashboard screenshots
```

---

## 🛠 How to Run (Locally)

```bash
# Provision infrastructure
cd terraform-infra
terraform apply

# Run ingestion
python3 scripts/load_all.py

# Run DBT
cd dbt_project
dbt deps
dbt run
dbt docs generate && dbt docs serve
```

---

> This project reflects best practices in modern data engineering and prepares for scalable analytics products. Contributions and feedback are welcome!
