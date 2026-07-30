# Kanboard GitOps

This repository stores the desired Kubernetes state for the Kanboard application.

## Responsibilities

- Package Kanboard and PostgreSQL using Helm
- Configure persistent storage
- Configure Gateway API resources
- Define Argo CD Applications
- Track immutable Kanboard image tags

## Repository structure

```text
kanboard-gitops/
├── argocd/
│   └── applications/
├── charts/
│   └── kanboard/
└── infrastructure/
    └── storage/
{ _ble_edit_exec_gexec__save_lastarg "$@"; } 4>&1 5>&2 &>/dev/null
