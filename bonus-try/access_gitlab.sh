#!/bin/bash

echo -n "USER: root GITLAB PASSWORD : "
  sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode

sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 &

echo -n "link to gitlab : http://127.0.0.1"
