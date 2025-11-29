#!/bin/bash

sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
HOST_ENTRY="127.0.0.1 gitlab.qroyo.com"
HOSTS_FILE="/etc/hosts"

echo "$HOST_ENTRY" | sudo tee -a "$HOSTS_FILE"
