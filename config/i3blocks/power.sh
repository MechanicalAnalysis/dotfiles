#!/bin/bash

# Se foi clicado (i3blocks envia BUTTON=1/2/3...), abre menu
if [ -n "$BLOCK_BUTTON" ]; then
    # Menu com rofi
    OPTIONS="Bloquear\nSuspender\nReiniciar\nDesligar\nSair"
    CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Power" -lines 5 -width 20)
    case "$CHOICE" in
        "Bloquear")
            # use i3lock (instale i3lock ou i3lock-fancy) ou loginctl lock-session
            i3lock
            ;;
        "Suspender")
            systemctl suspend
            ;;
        "Reiniciar")
            systemctl reboot
            ;;
        "Desligar")
            systemctl poweroff
            ;;
        "Sair")
            i3-msg exit
            ;;
        *)
            # nada
            ;;
    esac
    exit 0
fi

# Caso não tenha clique, exibe ícone/label no i3blocks
echo " ⏻ "   # ou "Power", ou ícone unicode que preferir
echo "Power"
echo "#f38ba8"   # cor (opcional)
