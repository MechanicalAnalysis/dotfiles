#!/bin/bash

echo ""

case $BLOCK_BUTTON in
    1) i3-msg exit ;;                     # clique esquerdo
    2) reboot ;;                          # clique do meio
    3) shutdown now ;;                    # clique direito
esac
