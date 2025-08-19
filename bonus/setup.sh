#!/bin/bash

set -e

echo "🛠️ Mise à jour des paquets et installation de git, curl, wget, libnss3-tools..."
sudo apt update
sudo apt install -y git curl wget libnss3-tools

# Ajout de l'utilisateur au groupe sudo
echo "👤 Ajout de l'utilisateur $USER au groupe sudo..."
sudo usermod -aG sudo "$USER"

# Génération de la clé SSH
echo "🔑 Génération de la clé SSH RSA..."
ssh-keygen -t rsa -b 4096 -C "qroyo@student.42lyon.fr" -f ~/.ssh/id_rsa -N ""

echo "Voici votre clé publique SSH (copiez-la dans GitHub) :"
cat ~/.ssh/id_rsa.pub
echo ""

# Installation de Docker
echo "🐳 Installation de Docker..."
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"

# Installation de mkcert
echo "🔒 Installation de mkcert..."
wget -q https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-v1.4.4-linux-amd64
sudo mv mkcert-v1.4.4-linux-amd64 /usr/local/bin/mkcert
sudo chmod +x /usr/local/bin/mkcert
mkcert -install

# Installation de Helm
echo "⚙️ Installation de Helm..."
if ! command -v helm &> /dev/null; then
    if command -v snap &> /dev/null; then
        sudo snap install helm --classic
    else
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi
else
    echo "✅ Helm est déjà installé."
fi

echo ""
echo "✅ Environnement de base prêt. Déconnecte-toi puis reconnecte-toi pour activer les groupes sudo et docker."
