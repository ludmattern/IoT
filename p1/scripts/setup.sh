#!/bin/bash

sudo apt-get update -qq && sudo apt-get install -y -qq curl

set -a; source /vagrant/config.env; set +a

if [ "$1" = "controller" ]; then
	export INSTALL_K3S_EXEC="--bind-address=${CONTROLLER_IP} --node-external-ip=${CONTROLLER_IP} --flannel-iface=${FLANNEL_IFACE}"
	curl -sfL https://get.k3s.io | sh -
	install -D -m 644 /etc/rancher/k3s/k3s.yaml /vagrant/k3s.yaml
	install -D -m 644 /var/lib/rancher/k3s/server/node-token /vagrant/token
else
	while [ ! -f "/vagrant/token" ]; do sleep 2; done
	export INSTALL_K3S_EXEC="--flannel-iface=${FLANNEL_IFACE}"
	curl -sfL https://get.k3s.io | sh -
fi
