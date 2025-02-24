## Overview

This repository is a submodule for the **RaspberryOnCloud** project.

## Commands

> [!NOTE]  
> The `local-exec` provisioner commands are intended to run on Windows.

### SSH

- `ssh-keygen -t rsa -f .ssh/52pi-k3s-1`
- `ssh -i .ssh/52pi-k3s-1 52pi-k3s-1@52pi-k3s-1`

### Server

- `type .server\address`
- `type .server\config`
- `type .server\node-token`

### Terraform

- `terraform fmt -recursive`
- `terraform -chdir=terraform init`
- `terraform -chdir=terraform plan`
- `terraform -chdir=terraform apply`
- `terraform -chdir=terraform destroy`

## Hardware

### Main configuration

- [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5)
- [SanDisk Ultra UHS-I microSD](https://shop.sandisk.com/products/memory-cards/microsd-cards/sandisk-ultra-uhs-i-microsd-120-mbps)
- [Toshiba Canvio Basics HDD](https://storage.toshiba.com/consumer-hdd/external/canvio-basics)
- [52pi Rack Tower Ultimate](https://wiki.52pi.com/index.php?title=ZP-0108)

### Nice to have

- USB Charging Station
- USB Type-C to Type-A Cable
- USB Male to 5-Pin Dupont Cable
- USB Female to Dual Male Y-Cable
- Magnetic Cable Clips
- Silicone HDD Case
