# Terraform Infrastructure Creation via Pipeline

This repository provides a streamlined way to manage and deploy Terraform infrastructure using an automated CI/CD pipeline.

## Features
- Automatic Terraform best practices checks on each commit.
- `terraform plan` execution on pull request creation.
- Plan file storage and retrieval from an S3 bucket.
- Automatic application of plans when pull requests are merged.
- Integration with AWS using OIDC-based IAM roles for secure connectivity.
- Reusable workflows and composite actions for modular pipeline design.

## Prerequisites

### Tools and Services
- **GitHub Actions**: To automate the workflow.
- **Terraform**: For infrastructure as code (IaC).
- **AWS**:
  - S3 Bucket for storing Terraform plans.
  - IAM role with OIDC integration for GitHub.
- **AWS CLI**: For manual debugging and verification (optional).

### Configuration
1. **AWS OIDC Role**
   - Ensure you have configured an AWS IAM role that GitHub can assume via OpenID Connect (OIDC).
   - Assign the role appropriate permissions for S3 and Terraform operations.

2. **S3 Bucket**
   - Create an S3 bucket (e.g., `example-terraform`) to store Terraform plan files.

3. **GitHub Secrets**
   - Add the following secrets to your repository:
     - `AWS_ROLE_ARN`: The ARN of your AWS OIDC role.
     - `AWS_REGION`: The region of your AWS resources.
     - `S3_BUCKET_NAME`: Name of the S3 bucket to store plan files.
     - `TERRAFORM_WORKSPACE`: Optional, if using multiple Terraform workspaces.

## Workflow

### On Commit
1. Lint and format Terraform code.
2. Run `terraform validate` to check configuration validity.
3. Run `terraform fmt -check` to ensure consistent code formatting.

### On Pull Request Creation
1. Execute `terraform plan -var=maintainer=$USER ` to generate an execution plan.
2. Save the plan file in the S3 bucket with the naming convention:
   `commit_<COMMIT_ID>_pr_<PR_ID>.tfplan`.

### On Pull Request Merge
1. Retrieve the corresponding plan file from the S3 bucket.
2. Apply the plan to the infrastructure using `terraform apply -var=maintainer=$USER `.

## Folder Structure
```
.
├── .github
│   ├── actions
│   │   ├── terraform-checks
│   │   └── terraform-apply
│   └── workflows
│       ├── terraform-commit.yml
│       ├── terraform-pr.yml
│       └── terraform-merge.yml
├── infra
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── README.md
└── scripts
    ├── prepare.sh
    └── cleanup.sh
```

## Setup

### Step 1: Clone Repository
```
git clone https://github.com/sherazriaz-git/digitify-terraform.git
cd <repository-directory>
```

### Step 2: Initialize Terraform
```
cd infra
terraform init
```

### Step 3: Configure GitHub Actions
1. Ensure all necessary secrets are added to the repository.
2. Review and customize workflows in `.github/workflows/` if needed.

### Step 4: Push Changes
Push the repository to GitHub to trigger the pipeline.

## Troubleshooting
- **Pipeline Fails**:
  - Verify that all required secrets are correctly set in the GitHub repository.
  - Check AWS IAM role permissions.
- **Plan Retrieval Issues**:
  - Ensure the S3 bucket name and region are correctly configured.

## Contributing
Feel free to open issues or submit pull requests for enhancements and bug fixes.

## License
This project is licensed under the [MIT License](LICENSE).
