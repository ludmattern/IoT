#!/bin/bash

set -e

# Clonage du dépôt
echo "📥 Clonage du dépôt IoT..."
mkdir -p ~/Documents
cd ~/Documents
if [ ! -d "IoT" ]; then
    git clone git@github.com:ludmattern/IoT.git
else
    echo "📁 Le dépôt IoT existe déjà, on continue."
fi

git config --global user.email qroyo@student.42lyon.fr
git config --global user.name qroyo

echo "⚙️ Compilation du projet dans ~/Documents/IoT/p3..."
cd ~/Documents/IoT/p3 || { echo "❌ Dossier ~/Documents/IoT/p3 introuvable."; exit 1; }

make

echo "⚙️ Deplacement dans ~/Documents/IoT/bonus..."
cd ~/Documents/IoT/bonus || { echo "❌ Dossier ~/Documents/IoT/bonus introuvable."; exit 1; }

# Création du certificat local GitLab
echo "🔐 Génération du certificat local pour gitlab.qroyo.com avec mkcert..."
mkcert gitlab.qroyo.com

# Ajout des dépôts Helm
echo "➕ Ajout des dépôts Helm gitlab et jetstack..."
helm repo add gitlab https://charts.gitlab.io/
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Installation de cert-manager
echo "📦 Installation de cert-manager via Helm..."
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.11.0 \
  --set installCRDs=true

# Compilation du projet
echo "⚙️ Compilation du projet dans ~/Documents/IoT/bonus..."
cd ~/Documents/IoT/bonus || { echo "❌ Dossier ~/Documents/IoT/bonus introuvable."; exit 1; }

make all
make describe

echo "✅ Déploiement terminé."
