#!/usr/bin/env bash

# Get utilization and temperature from nvidia-smi
info=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits)
IFS=',' read -r util temp mem_used mem_total <<< "$info"

echo "{\"text\": \"󰬎󰬗󰬜 [${util}${temp}${mem_used}/${mem_total}MB ]\", \"tooltip\": \"NVIDIA GPU Stats\"}"
