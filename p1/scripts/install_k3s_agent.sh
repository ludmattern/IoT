#!/bin/bash
set -e
# Install K3s in agent mode
K3S_URL=$1
K3S_TOKEN=$2
curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -
# Add vagrant user to k3s group for kubectl access
sudo usermod -aG k3s vagrant
