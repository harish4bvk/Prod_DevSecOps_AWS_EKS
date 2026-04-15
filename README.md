# 🚀 3-Tier DevSecOps Pipeline on AWS (EKS + Terraform)

## 📌 Overview

This project demonstrates a **production-grade DevSecOps pipeline** for deploying a 3-tier application (frontend, backend, and database) on AWS using modern infrastructure and automation practices.

It showcases how to design, provision, secure, and operate cloud-native applications using **Terraform, Amazon EKS, Docker, Helm, and GitHub Actions**.

---

## 🏗 Architecture

```
Client → Ingress → Frontend → Backend → RDS (PostgreSQL)
```

* **Frontend**: React app served via NGINX
* **Backend**: API service (Node.js / Java)
* **Database**: AWS RDS (PostgreSQL) in private subnet
* **Infrastructure**: Terraform-managed AWS resources
* **Deployment**: Kubernetes (EKS) using Helm

---

## 🧰 Tech Stack

### ☁️ Cloud & Infrastructure

* AWS (EKS, VPC, RDS, IAM, ECR)
* Terraform (Infrastructure as Code)

### 🚀 Application & Deployment

* Docker (containerization)
* Kubernetes (EKS)
* Helm (package management)

### 🔁 CI/CD & DevSecOps

* GitHub Actions (CI/CD pipeline)
* Trivy (container vulnerability scanning)
* GitHub OIDC (secure AWS authentication)

### 📊 Monitoring

* Prometheus (metrics collection)
* Grafana (visualization dashboards)

---

## ☁️ Infrastructure (Terraform)

* Modular Terraform architecture:

  * `vpc/` → networking (public/private subnets, NAT, IGW)
  * `eks/` → managed Kubernetes cluster with node groups
  * `rds/` → private PostgreSQL database
  * `iam/` → roles for EKS, IRSA, and GitHub OIDC
* Remote backend using **S3 + DynamoDB** for state management
* Secure network design:

  * Public subnets → Load Balancer
  * Private subnets → EKS nodes & RDS

---

## 🔁 CI/CD Pipeline

### Continuous Integration (CI)

* Triggered on code push
* Unit Test
* Builds Docker images for frontend & backend
* Scans images using **Trivy**
* Pushes images to AWS ECR

### Continuous Deployment (CD)

* Deploys application to EKS using Helm
* Updates image versions dynamically
* Verifies rollout status

---

## ☸️ Kubernetes Deployment

* Multi-service deployment:

  * Frontend (public via Ingress)
  * Backend (internal service)
* Helm-based deployment for scalability and reusability
* Service communication via Kubernetes DNS

---

## 🔐 Security (DevSecOps)

* No hardcoded AWS credentials (OIDC-based authentication)
* IAM roles with least privilege access
* IRSA (IAM Roles for Service Accounts) for pod-level security
* Private RDS instance (no public access)
* Container vulnerability scanning using Trivy

---

## 📊 Monitoring & Observability

* Prometheus for cluster and application metrics
* Grafana dashboards for visualization
* Real-time monitoring of:

  * CPU & memory usage
  * Pod health
  * Request metrics

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the repository

```bash
git clone https://github.com/harish4bvk/Devsecops-eks-3tire.git
cd Devsecops-eks-3tire
```

### 2️⃣ Provision infrastructure

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### 3️⃣ Configure kubectl

```bash
aws eks update-kubeconfig --region ap-south-1 --name devsecops-cluster
```

### 4️⃣ Deploy application using Helm

```bash
cd helm/3tier-app
helm upgrade --install app .
```

---

## 🌐 Application Access

* Frontend is exposed via Kubernetes Ingress
* Backend is accessible internally within the cluster
* Database is securely hosted in AWS RDS (private subnet)

---

## 📁 Repository Structure

```
├── app/                # Application code (frontend + backend)
├── docker/             # Dockerfiles
├── helm/               # Helm charts
├── terraform/          # Infrastructure as Code
├── .github/workflows/  # CI/CD pipelines
├── monitoring/         # Prometheus & Grafana setup
├── docs/               # Architecture diagrams
```

---

## 🚧 Future Improvements

* Implement Horizontal Pod Autoscaler (HPA)
* Add centralized logging (ELK / Loki)
* Improve IAM policies with least privilege
* Introduce blue-green or canary deployments

---

## 💡 Key Highlights

* End-to-end DevSecOps pipeline
* Production-style infrastructure design
* Secure, scalable, and automated deployment
* Real-world cloud architecture implementation

---

## 📬 Contact

Feel free to connect or reach out for collaboration or feedback.

---

⭐ If you found this project useful, consider giving it a star!
