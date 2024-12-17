#!/bin/bash

# File log
LOG_FILE="logs/azure_monitor_log.json"

# Loop untuk menambahkan 60 log entry dalam 1 menitnya
for i in {1..60}; do
  # Simulasi waktu WIB (UTC+7)
  CURRENT_TIME=$(date -u -d "+7 hours" +"%Y-%m-%dT%H:%M:%S WIB")

  # Simulasi data metrik Azure App Service
  CPU_PERCENT=$(awk -v min=10 -v max=95 'BEGIN{srand(); print min+rand()*(max-min)}')
  MEMORY_BYTES=$((RANDOM % 5000000000 + 1000000000))
  REQUEST_COUNT=$((RANDOM % 2000 + 500))
  LATENCY_MS=$(awk -v min=50 -v max=500 'BEGIN{srand(); print min+rand()*(max-min)}')

  # Format data sebagai JSON
  JSON_LOG_ENTRY=$(cat <<EOF
{
  "timestamp": "$CURRENT_TIME",
  "metrics": {
    "CPU_Percent": $CPU_PERCENT,
    "Memory_Bytes": $MEMORY_BYTES,
    "Request_Count": $REQUEST_COUNT,
    "Latency_ms": $LATENCY_MS
  }
}
EOF
)

  # Tambahkan log ke file
  echo "$JSON_LOG_ENTRY" >> $LOG_FILE
  echo "Log entry $i added at $CURRENT_TIME"

  # Tunggu 1 detik sebelum iterasi berikutnya
  sleep 1
done