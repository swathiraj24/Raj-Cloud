# Azure Hub-and-Spoke Terraform Scaffold

This project is a starter scaffold for an Azure landing zone with a hub-and-spoke network design, private-only subnets, private endpoints, centralized policy and monitoring, and GitHub Actions pipeline support.

## Architecture

- Shared Network Hub
  - Optional centralized firewall and monitoring
  - Hub VNet with private subnets
- Spoke VNets
  - Application / AKS / VM workloads
  - Private endpoints into hub services
- Private endpoints / service endpoints for Azure PaaS
- Site-to-site VPN gateway support for on-premises connectivity
- Centralized policy enforcement with management groups

## Folder structure

- `modules/`
  - `vnet/` - hub and spoke network module
  - `vpn/` - optional VPN gateway and site-to-site connectivity module
  - `firewall/` - optional firewall module
  - `keyvault/` - optional Key Vault module
  - `private-endpoint/` - optional private endpoint module
  - `monitoring/` - optional monitoring module
- `environments/`
  - `dev/` - sample dev environment
  - `prod/` - sample prod environment
- `policies/` - Azure Policy definitions and assignments
- `pipelines/` - GitHub Actions pipeline examples

## Student account cost guidance

- Azure Student subscriptions typically include a credit allowance and free services.
- Virtual network and subnet resources are generally low-cost or free.
- Private endpoints, VPN Gateways, and Azure Firewall can incur charges, so use them only when needed.
- Use the dev environment for small proof of concept workloads and delete resources when not in use.
- For laptop-to-Azure connectivity, use Azure VPN Gateway with Point-to-Site VPN for secure access from a Windows laptop.

## GitHub Actions deployment

This repository includes an Azure-ready workflow in `pipelines/github-actions.yml`.

### Workflow behavior

- Pull requests to `main` run `terraform fmt`, `terraform validate`, and `terraform plan` for `environments/dev`.
- Pushes to `main` run `terraform fmt`, `terraform validate`, and `terraform apply` against `environments/dev`.
- `workflow_dispatch` allows manual workflow runs.
- The `apply` job uses `environment: production` so you can enable GitHub environment approval if desired.

### Required GitHub Secrets

Set these repository secrets in GitHub before the workflow can deploy to Azure:

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

### Create an Azure service principal

Use Azure CLI to create a service principal and assign Contributor access:

```powershell
az login
az account set --subscription <SUBSCRIPTION_ID>
az ad sp create-for-rbac --name "github-actions-terraform" --role Contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
```

Then copy the returned `appId`, `password`, `tenant`, and the subscription ID into the GitHub secrets above.

### Notes

- This workflow currently deploys the `dev` environment. If you want to deploy `prod`, duplicate or extend the pipeline for `terraform/environments/prod`.
- The current repo does not configure a remote Terraform backend. For long-lived deployments, add Azure Storage backend configuration to keep state outside the workflow runner.

## Next steps

1. Customize `environments/dev/main.tf` and `modules/vnet` to match your address space.
2. Add any additional Azure resources you need for your landing zone.
3. Use the GitHub Actions workflow in `pipelines/github-actions.yml` to deploy changes after secrets are configured.

az login
az account set --subscription 75f93a8f-87ec-4030-ad7a-c151ed887ea4

az ad sp create-for-rbac `
  --name "github-actions-terraform" `
  --role Contributor `
  --scopes /subscriptions/75f93a8f-87ec-4030-ad7a-c151ed887ea4