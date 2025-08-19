#!/bin/bash

set -e

echo "🔐 Ajout de l'utilisateur au groupe sudo..."
sudo usermod -aG sudo qroyo

echo "💿 Mise à jour de /etc/apt/sources.list avec les dépôts Trixie..."
sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb http://deb.debian.org/debian/ trixie main contrib non-free
deb-src http://deb.debian.org/debian/ trixie main contrib non-free

deb http://security.debian.org/debian-security trixie-security main contrib non-free
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free

# trixie-updates, to get updates before a point release is made;
deb http://deb.debian.org/debian/ trixie-updates main contrib non-free
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free
EOF

echo "🛠️ Mise à jour des paquets et installation de git, curl, wget, libnss3-tools..."
sudo apt update
sudo apt install -y git curl wget libnss3-tools build-essential

# Installation de Docker
echo "🐳 Installation de Docker..."
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker qroyo

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

echo "🧾 Ajout de gitlab.qroyo.com dans /etc/hosts..."
if ! grep -q "gitlab.qroyo.com" /etc/hosts; then
    echo "127.0.0.1 gitlab.qroyo.com" | sudo tee -a /etc/hosts
else
    echo "✅ gitlab.qroyo.com est déjà dans /etc/hosts"
fi

echo "🔑 Génération de la clé SSH RSA..."
su - qroyo -c 'ssh-keygen -t rsa -b 4096 -C "qroyo@student.42lyon.fr"'

echo "Voici votre clé publique SSH (copiez-la dans GitHub) :"
su - qroyo -c 'cat ~/.ssh/id_rsa.pub'
echo ""
echo "✅ Environnement de base prêt. Déconnecte-toi puis reconnecte-toi pour activer les groupes sudo et docker."
