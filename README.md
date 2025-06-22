# AWS Terraform Infrastructure Project

This project provides a basic example of using [Terraform](https://www.terraform.io/) to provision AWS infrastructure, including remote state management and automated CI/CD with GitHub Actions.

## Features
- **AWS EC2 Instance Provisioning**: Deploys a demo EC2 instance using configurable AMI and instance type.
- **Remote State Management**: Uses an S3 bucket and DynamoDB table for storing Terraform state and managing state locks.
- **Backend Bootstrapping**: Includes scripts to bootstrap the S3 bucket and DynamoDB table required for remote state.
- **CI/CD Pipeline**: Automated Terraform format check, plan, and apply using GitHub Actions.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with permissions to create S3, DynamoDB, and EC2 resources

## Project Structure
```
.
├── main.tf                # Main Terraform configuration (EC2 instance)
├── s3-backend.tf          # Remote backend configuration
├── init/
│   └── bootstrap-backend.tf # Script to bootstrap S3 and DynamoDB for state
├── .github/
│   └── workflows/
│       └── terraform.yml  # GitHub Actions workflow for CI/CD
└── README.md              # Project documentation
```

## Setup Instructions

### 1. Bootstrap Remote Backend
Before running Terraform in the root, you must create the S3 bucket and DynamoDB table for remote state:

```sh
cd init
terraform init
terraform apply
```

### 2. Deploy Infrastructure
After bootstrapping the backend, return to the root directory:

```sh
cd ..
terraform init
terraform plan
terraform apply
```

## CI/CD with GitHub Actions
This project includes a workflow that automatically:
- Checks Terraform formatting on pull requests and pushes
- Runs `terraform plan` on pull requests
- Applies changes to AWS on push to the `main` branch

Secrets required in your GitHub repository:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION` (optional, defaults to `us-east-1`)

## Customization
- Change the AMI and instance type in `main.tf` as needed.
- Update backend bucket/table names in `s3-backend.tf` and `init/bootstrap-backend.tf` if required.

## License
[Specify your license here]
No newline at end of file
# AWS Terraform Infrastructure Project

This project provisions a secure AWS VPC environment using Terraform, including:
- VPC with public and private subnets
- Security groups and network ACLs
- Bastion host for secure SSH access
- NAT instance for private subnet internet access (cost-effective)
- Automated CI/CD with GitHub Actions

## Features
- **VPC**: Custom VPC with 2 public and 2 private subnets across different AZs.
- **Security Groups**: 
  - Bastion host SG allows SSH from anywhere (customize for production).
  - Private instance SG allows SSH only from the bastion host.
- **Network ACLs**: Separate NACLs for public and private subnets with open rules (customize for production).
- **Bastion Host**: EC2 instance in a public subnet for secure SSH access to private instances.
- **NAT Instance**: Low-cost NAT instance in a public subnet, allowing private subnet instances to access the internet.
- **CI/CD**: GitHub Actions pipeline for Terraform format, plan, and apply.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with permissions to create S3, DynamoDB, and EC2 resources

## Project Structure
```
.
├── main.tf                # Main Terraform configuration (EC2 instance)
├── s3-backend.tf          # Remote backend configuration
├── init/
│   └── bootstrap-backend.tf # Script to bootstrap S3 and DynamoDB for state
├── .github/
│   └── workflows/
│       └── terraform.yml  # GitHub Actions workflow for CI/CD
└── README.md              # Project documentation
```

## Setup Instructions

### 1. Bootstrap Remote Backend
Before running Terraform in the root, you must create the S3 bucket and DynamoDB table for remote state:

```sh
cd init
terraform init
terraform apply
```

### 2. Deploy Infrastructure
After bootstrapping the backend, return to the root directory:

```sh
cd ..
terraform init
terraform plan
terraform apply
```

## Accessing Instances
- **Bastion Host**: SSH to the bastion host using its public IP.
- **Private Instances**: SSH to the private instance from the bastion host (use the private IP of the target instance).

Example:
```
ssh -i <your-key.pem> ec2-user@<bastion-public-ip>
# From bastion:
ssh ec2-user@<private-instance-private-ip>
```

## NAT Instance
- A single NAT instance is used for both private subnets to minimize cost.
- Private subnet route tables are configured to use the NAT instance for outbound internet access.

## Security
- **Security Groups**: Restrict SSH access in production by setting your IP in the bastion SG.
- **NACLs**: Currently allow all traffic for demonstration; tighten for production.

## GitHub Actions Pipeline
- Located in `.github/workflows/terraform.yml`.
- Runs `terraform fmt`, `plan`, and `apply` on push/PR to main.

## Customization
- Change AMI and instance type in `variables.tf` as needed.
- Update security group and NACL rules for your security requirements.

## License
[Specify your license here]
