## Overview

This repository is a submodule for the **RaspberryOnCloud** project.

## Commands

> [!NOTE]  
> The `local-exec` provisioner commands are intended to run on Windows.

### SSH

- `ssh-keygen -t rsa -f .ssh/52pi-k3s-1`
- `ssh -i .ssh/52pi-k3s-1 52pi-k3s-1@52pi-k3s-1`

### Terraform

- `terraform fmt -recursive`
- `terraform -chdir=terraform init`
- `terraform -chdir=terraform plan`
- `terraform -chdir=terraform apply`
- `terraform -chdir=terraform destroy`
