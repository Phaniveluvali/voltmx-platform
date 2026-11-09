# VoltMX Platform GitOps Umbrella

This repository manages the deployment of **VoltMX Foundry 9.5** and its dedicated **MySQL 8.4** database under an ArgoCD GitOps umbrella model.

## Architecture

- `argocd/voltmx-root-app.yaml`: Root ArgoCD umbrella application.
- `argocd/apps/01-mysql-database.yaml`: Manages the database tier in namespace `mysql`.
- `argocd/apps/02-voltmx-foundry.yaml`: Manages the 5 VoltMX Foundry microservices in namespace `voltmx`.
- `charts/mysql/`: Declarative Helm chart for MySQL StatefulSet matching existing persistent volume claims.
- `charts/voltmx-foundry/`: Official HCL Volt Foundry Helm chart configured with institutional ingress and safe-mode resource settings.
