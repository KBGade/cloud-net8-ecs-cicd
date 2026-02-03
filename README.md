**#About me: https://kbgade.github.io/kiran-gade-intro/**


# Cloud .NET 8 → Docker → AWS ECR/ECS (Fargate) CI/CD
"Trigger first deploy...."
hello..
A minimal, **hire-ready demo** repo that builds a .NET 8 Web API, containerizes it, pushes the image to **Amazon ECR**, and runs it on **Amazon ECS (Fargate)**. Infra is provisioned using **Terraform**. Deployments are triggered from **GitHub Actions** using **OIDC** (no long‑lived keys).

## What happens on `main` push?
1. Build & publish the .NET 8 API
2. Build Docker image and push to ECR with tag **latest** (and commit SHA)
3. Force a new ECS deployment so the service pulls the **latest** image

## Stack
- .NET 8, ASP.NET Core Minimal API
- Docker
- AWS: ECR, ECS Fargate, ALB, CloudWatch Logs, IAM
- Terraform
- GitHub Actions (OIDC)

---

## Quick Start

### 1) Prereqs
- AWS account with permissions to create ECR/ECS/ALB/VPC/IAM
- Terraform >= 1.6
- Docker
- GitHub repo with Actions enabled

### 2) Configure GitHub OIDC
Create (one-time) an **IAM role** that GitHub can assume via OIDC and attach permissions for ECR/ECS/Logs/EC2/ElasticLoadBalancing. Put the role ARN into GitHub repo **Secrets and Variables → Actions** as `AWS_ROLE_ARN`.

> You can also test locally with standard AWS credentials. OIDC is preferred for security.

### 3) Provision Infra (Terraform)
```
cd infra/terraform
terraform init
terraform apply -auto-approve
```
Outputs include:
- `alb_dns`: The public URL of your service
- `ecr_repo_url`: Your ECR repository URL

### 4) Push Code
Commit and push to `main`. The workflow will:
- Build/push Docker image to ECR both as `:latest` and `:<commit>`
- Force a new ECS deployment so tasks pull the new image

### 5) Test
Open the ALB URL:
- `/health` → `{ "status": "ok" }`
- `/weather` → simple random forecast

---

## Local Run
```
dotnet run --project src/WeatherApi/WeatherApi.csproj
# http://localhost:5000/swagger
```

## Repo Structure
```
cloud-net8-ecs-cicd/
├─ src/WeatherApi/         # .NET 8 Minimal API
├─ Dockerfile              # Multi-stage build
├─ .github/workflows/      # CI/CD
└─ infra/terraform/        # Infrastructure as Code (ECR, ECS, ALB, VPC, IAM)
```

## Cost Note
Using a small Fargate service in `ap-south-1` with an ALB typically costs a few dollars/day if left running. Destroy infra when not needed:
```
cd infra/terraform && terraform destroy
```

---

## Customization
- Change AWS region in Terraform vars or workflow env (`ap-south-1` by default).
- Update service/container names if you fork the repo.
- Add real tests (xUnit/NUnit) and code scanning.
