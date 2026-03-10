#!/bin/bash
set -e

echo "== Atualizando sistema =="
sudo apt update && sudo apt upgrade -y

echo "== Instalando pacotes via APT =="
# Instala tudo o que estiver no seu arquivo de lista
sudo xargs -a packages/lista_pacotes.txt apt install -y

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

echo "== Instalando Flatpaks =="
# O comando flatpak não aceita bem listas vazias, verifique se o arquivo existe
if [ -f "packages/meus_flatpaks.txt" ]; then
    xargs -a packages/meus_flatpaks.txt flatpak install -y flathub
fi

echo "== Finalizado =="
echo "Reinicie sessão ou execute: i3-msg restart"
