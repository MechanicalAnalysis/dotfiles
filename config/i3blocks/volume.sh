#!/bin/bash
sink=@DEFAULT_SINK@

# ações de mouse (BLOCK_BUTTON vem do i3blocks)
case "$BLOCK_BUTTON" in
  4) pactl set-sink-volume $sink +5% ;;    # scroll up
  5) pactl set-sink-volume $sink -5% ;;    # scroll down
  1) pactl set-sink-mute $sink toggle ;;  # clique esquerdo
esac

# mostra volume e estado
vol=$(pactl get-sink-volume $sink | awk '/Volume/ {print $5; exit}')
mute=$(pactl get-sink-mute $sink | awk '/Mute/ {print $2}')
if [ "$mute" = "yes" ]; then
  echo "🔇 $vol"
else
  echo "🔊 $vol"
fi
