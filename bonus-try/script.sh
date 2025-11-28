#!/bin/bash

sudo kubectl create namespace gitlab

sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
HOST_ENTRY="127.0.0.1 gitlab.qroyo.com"
HOSTS_FILE="/etc/hosts"

echo "$HOST_ENTRY" | sudo tee -a "$HOSTS_FILE"

sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update 
sudo helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=qroyo.com \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.hosts.https=false \
  --timeout 600s

echo -n "USER: root GITLAB PASSWORD : "
  sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode

sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 &

echo -n "link to gitlab : http://127.0.0.1"
