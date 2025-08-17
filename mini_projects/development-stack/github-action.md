# GitHub Actions Roadmap for Senior DevOps

## Basic Features
- **YAML-based workflows** stored in `.github/workflows` (Workflows → Jobs → Steps model)
- **Event-driven triggers**: `push`, `pull_request`, `workflow_dispatch`, `schedule (cron)`
- **GitHub-hosted and self-hosted runners** for executing jobs
- **CI/CD integration**: seamless workflow within GitHub repositories
- **Marketplace Actions**: pre-built actions available for integration

## Intermediate Features
- **Secrets & environment variables**: securely store and inject at runtime
- **Matrix builds**: parallelize jobs across OSs, language versions, etc.
- **Scheduled workflows**: use cron jobs and manual `workflow_dispatch` with inputs
- **Reusable workflows & templates**: DRY up common pipelines
- **Artifact storage & caching**: persist build outputs and dependencies
- **Context objects** (`github`, `env`, `matrix`, `strategy`) to parameterize jobs

## Advanced Features
- **Custom Actions**: author JavaScript, Docker, or composite actions
- **Conditional execution** (`if:`, `continue-on-error`) and job dependencies (`needs`)
- **Concurrency controls**: concurrency groups, auto-cancellation of stale runs
- **Environments & deployment protection**: gated approvals, required reviewers, wait timers
- **Security hardening**: OIDC token authentication, artifact attestations, least-privilege `GITHUB_TOKEN`
- **Self-hosted runner orchestration**: auto-scale with Actions Runner Controller, custom hardware
- **Infrastructure-as-Code integration**: Terraform, CloudFormation, Kubernetes deploys
- **Advanced deployment strategies**: canary/blue-green rollouts, manual approvals per environment
- **REST API & webhooks**: trigger, monitor, and manage workflows programmatically
- **Marketplace actions publishing**: versioning and sharing across organizations
