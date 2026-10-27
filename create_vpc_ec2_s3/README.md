# Terraform VPC, EC2, and S3 Deployment

This Terraform configuration provisions a simple AWS networking and compute environment in the `ap-south-1` region.

## Resources Created

The configuration creates the following AWS resources:

- VPC: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24`
- Internet Gateway
- Route Table with default route to the Internet Gateway
- Route Table Association to the public subnet
- Security Group allowing SSH access from anywhere (`0.0.0.0/0` on port 22)
- EC2 instance in the public subnet
- S3 bucket with a generated unique prefix

## File Overview

- `main.tf` — Contains the Terraform configuration for the VPC, subnet, route table, security group, EC2 instance, and S3 bucket.

## Prerequisites

Before running this Terraform project, make sure you have:

- Terraform installed
- AWS CLI configured with valid credentials
- Access to an AWS account
- Permission to create VPC, EC2, Security Group, and S3 resources

## Usage

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Review the execution plan:

   ```bash
   terraform plan
   ```

3. Apply the configuration:

   ```bash
   terraform apply
   ```

4. When finished, destroy the infrastructure:

   ```bash
   terraform destroy
   ```

## Notes

- The EC2 instance uses the Amazon Linux 2023 AMI ID specified in the configuration.
- The security group allows SSH access (`22/tcp`) from all IP addresses. For production use, restrict ingress access to a known IP range.
- The S3 bucket uses `bucket_prefix` instead of a fixed bucket name, which helps avoid naming conflicts.

## Example Architecture

```text
Internet
   |
   v
Internet Gateway
   |
   v
VPC (10.0.0.0/16)
   |
   +--> Public Subnet (10.0.1.0/24)
          |
          +--> EC2 Instance
          |
          +--> Security Group

S3 Bucket
```

## Important Security Reminder

This example is intended for learning and demonstration. In real-world deployments, you should:

- Restrict SSH access to your IP address only
- Use IAM roles for EC2 access instead of long-lived credentials
- Enable encryption for S3 buckets
- Use least-privilege security policies
