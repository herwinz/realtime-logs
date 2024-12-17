# Real-Time Azure Log Simulation

This repository contains a GitHub Actions workflow to simulate real-time Azure log generation and updates. Logs are automatically committed to the repository every minute using GitHub's built-in scheduler.

## Workflow Overview

The workflow is defined in `realtime_logs.yml` and uses the following triggers:
- **Manual Trigger**: Trigger the workflow manually from the GitHub Actions UI.
- **Push Trigger**: Trigger the workflow on any push to the `main` branch.
- **Scheduled Trigger**: Automatically runs the workflow every 1 minute.

## Features

- Automated log generation for Azure metrics (e.g., CPU usage, memory, latency).
- Scheduled execution using GitHub Actions `schedule` with cron syntax.
- Logs are committed and pushed to the repository automatically.

## File Structure

- `logs/azure_monitor_log.json`: The log file where simulated Azure metrics are stored.
- `scripts/auto_log_update.sh`: Script for generating and appending log entries.
- `.github/workflows/realtime_logs.yml`: The workflow configuration file.

## How It Works

1. **Log Generation**:
   - The script `auto_log_update.sh` generates 60 log entries (one per second) during each workflow execution.
   - Each log entry includes:
     - Timestamp (in WIB format, UTC+7).
     - Simulated metrics for CPU usage, memory, request count, and latency.

2. **Automatic Commit and Push**:
   - The log file is committed to the repository and pushed to the `main` branch every workflow execution.

3. **Scheduled Execution**:
   - The workflow is scheduled to run every 1 minute using the following cron expression:
     ```cron
     */1 * * * *
     ```

## Example Workflow Configuration

Here is the workflow definition in `realtime_logs.yml`:

```yaml
name: Real-Time Azure Log Simulation

on:
  workflow_dispatch:
  push:
    branches:
      - main
  schedule:
    - cron: '*/1 * * * *'

jobs:
  real-time-logger:
    runs-on: ubuntu-latest

    permissions:
      contents: write

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
        with:
          persist-credentials: true

      - name: Setup Git
        run: |
          git config --global user.name "Your Name"
          git config --global user.email "your.email@example.com"

      - name: Generate Log and Push Changes
        run: |
          chmod +x scripts/auto_log_update.sh
          ./scripts/auto_log_update.sh
          CURRENT_TIME=$(date -u +'%Y-%m-%dT%H:%M:%S UTC')
          git add logs/azure_monitor_log.json
          git commit -m "Automated Log Update: $CURRENT_TIME" || echo "No changes to commit"
          git push origin main || echo "Push failed, retrying next iteration"