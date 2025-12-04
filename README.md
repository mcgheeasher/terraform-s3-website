# Terraform S3 Website

This project demonstrates using **Terraform** to deploy a static website to **AWS S3**.

## What it does
- Creates a unique S3 bucket
- Configures the bucket for website hosting
- Uploads an `index.html` file
- Demonstrates version control with GitHub

## How to use
1. Clone this repository
2. Run `terraform init`
3. Run `terraform plan -out=plan.out`
4. Run `terraform apply -auto-approve plan.out`
5. Update website content by editing `website/index.html` and repeating the plan/apply steps

