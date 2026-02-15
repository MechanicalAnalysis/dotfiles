#!/bin/bash

set -e

echo "== Atualizando sistema =="
sudo apt update && sudo apt upgrade -y

echo "== Instalando pacotes base =="
sudo apt install -y \
i3 \
i3blocks \
nitrogen \
pcmanfm \
kitty \
blueman \
network-manager-gnome \
volumeicon-alsa \
fonts-font-awesome \
rofi \
git \
curl \
lxappearance

echo "== Criando pastas =="
mkdir -p ~/.config/i3
mkdir -p ~/.config/i3blocks
mkdir -p ~/.themes

echo "== Copiando configs =="
cp -r config/i3/config ~/.config/i3/
cp -r config/i3blocks/* ~/.config/i3blocks/
cp -r theme/* ~/.themes/

echo "== Permissões =="
chmod +x ~/.config/i3blocks/power.sh

echo "== Finalizado =="
echo "Reinicie sessão ou execute: i3-msg restart"
