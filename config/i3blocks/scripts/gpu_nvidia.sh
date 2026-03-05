#!/bin/bash

GPU=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)

if [ -z "$GPU" ]; then
  echo "GPU N/A"
  exit 0
fi

echo "󰢮 ${GPU}%"
