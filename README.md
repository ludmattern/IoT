# Inception-of-Things (IoT) - Setup Guide

Setup guide for IoT project using Vagrant, VirtualBox and K3s.

## System Requirements

- **OS**: Ubuntu 22.04 LTS or newer
- **RAM**: Minimum 4 GB (recommended 8 GB+)
- **CPU**: Virtualization support enabled
- **Disk**: Minimum 20 GB free space

## Installation

### 1. System update

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install VirtualBox

```bash
# Add Oracle VirtualBox GPG key
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

# Add Oracle VirtualBox repository
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian jammy contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

# Update and install VirtualBox
sudo apt update
sudo apt install -y virtualbox-7.0
```

### 3. Install Vagrant

```bash
# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Vagrant
sudo apt update
sudo apt install -y vagrant
```

### 4. Configure permissions

```bash
sudo usermod -aG vboxusers $USER
# Restart terminal or logout/login
```

## Verification

```bash
vagrant --version
vboxmanage --version
groups $USER
```
