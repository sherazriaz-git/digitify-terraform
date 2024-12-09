name: Terraform with AWS OIDC Role

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  terraform:
    name: Terraform with AWS OIDC
    runs-on: ubuntu-latest

    permissions:
      id-token: write  # Required for OIDC
      contents: read   # For accessing the repository

    steps:
      # Step 1: Checkout the repository
      - name: Checkout Code
        uses: actions/checkout@v3

      # Step 2: Configure AWS credentials using OIDC
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v3
        with:
          role-to-assume: arn:aws:iam::099199746132:role/github-oidc-provider-aws
          aws-region: us-east-1  # Replace with your desired AWS region

      # Step 3: Setup Terraform CLI
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0  # Adjust the version as needed

      # Step 4: Terraform Init
      - name: Terraform Init
        run: cd prod &&  terraform init

      # Step 5: Terraform Format and Validate
      - name: Terraform Format and Validate
        run: |
          terraform fmt -check
          terraform validate

      # Step 6: Terraform Plan
      - name: Terraform Plan
        id: plan
        run: cd prod && terraform plan -out=tfplan

      # Step 7: Terraform Apply (only on main branch)
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: cd prod &&  terraform apply -auto-approve tfplan
