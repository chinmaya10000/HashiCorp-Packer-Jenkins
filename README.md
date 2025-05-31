# 🚀 Automated Immutable Deployment with Packer, Jenkins, ASG & ALB

This project demonstrates an automated, immutable deployment pipeline using **HashiCorp Packer**, **Jenkins**, **AWS Auto Scaling Group (ASG)**, **Launch Template (LT)**, and **Application Load Balancer (ALB)**. The pipeline builds a custom AMI using Packer, deploys it via a Launch Template, and refreshes the ASG to roll out the latest application version.

---

## 🧰 Tech Stack

- **Jenkins** – CI/CD pipeline automation  
- **Packer** – AMI creation with provisioning  
- **Bash** – App installation and provisioning script  
- **AWS** – EC2, ASG, LT, ALB, Target Group  
- **Node.js + PM2** – Sample backend app stack  

---

## 📌 Prerequisites

Before using this project, ensure you have the following:

- ✅ AWS account with necessary IAM permissions:
  - EC2: Launch Template, AMI, ASG
  - IAM: Create/Use roles for Packer and Jenkins
- ✅ Existing AWS infrastructure setup:
  - Auto Scaling Group (ASG)
  - Launch Template (LT)
  - Application Load Balancer (ALB) with a target group
- ✅ Jenkins installed and configured with:
  - `packer`, `awscli`, and `npm` installed on Jenkins agent
  - AWS credentials stored in Jenkins as:
    - `jenkins_aws_access_key_id`
    - `jenkins_aws_secret_access_key`
- ✅ Source code structure:
  - `app/` directory with Node.js app (including `index.js` and `package.json`)
  - `scripts/install.sh` provisioning script
  - Valid `packer.pkr.hcl` and `Jenkinsfile`

---


