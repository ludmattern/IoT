#!/bin/bash
set -e
# Install K3s in server mode
curl -sfL https://get.k3s.io | sh -
# kubectl is already included with K3s
# Add vagrant user to k3s group for kubectl access
sudo usermod -aG k3s vagrant
