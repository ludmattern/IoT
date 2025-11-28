#!/bin/bash

echo "link to gitlab : http://127.0.0.1:8080"
echo "USER: root"
echo -n "PASSWORD : "
  sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
echo

sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 8080:8181 > /dev/null 2>&1 &
