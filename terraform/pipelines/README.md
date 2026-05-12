# Pipelines

This folder contains GitHub Actions workflows and pipeline examples for Terraform deployment.

The included workflow file `pipelines/github-actions.yml` currently does the following:

1. Runs `terraform fmt` and `terraform validate` for changes in `terraform/environments/dev`.
2. Runs `terraform plan` on pull requests.
3. Runs `terraform apply` when code is pushed to the `main` branch.

## Azure credentials

The workflow requires these GitHub Secrets:

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

Keep these secrets out of source control and configure them in your GitHub repository settings.

## Approval and production control

The `apply` job is configured with `environment: production` so you can add GitHub environment approvals if you want tighter control before deployment.

## Manual runs

The workflow also supports `workflow_dispatch` for manual execution from the GitHub Actions UI.
