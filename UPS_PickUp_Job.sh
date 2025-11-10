#!/bin/bash
# ==============================================================================
# UPS Pickup Request – Main Script
# Automates UPS returns using the UPS API
# Repository: https://github.com/bucto/UPS-Pickup-Anfrage/
# ==============================================================================

set -euo pipefail
IFS=$'\n\t'

# ========================= Configuration Parameters ==========================
# Global config variables (UPPERCASE)
PROJECT_FOLDER="ENTER_YOUR_FOLDER_NAME"
PROJECT_NAME="UPS-Pickup-Anfrage"
LOG_FILE="$PROJECT_FOLDER/logs/ups_pickup.log"

# ========================== Include Config Files =============================
CONFIG_DIR="$PROJECT_FOLDER/Config"

if [ -d "$CONFIG_DIR" ]; then
    for file in "$CONFIG_DIR"/*.sh; do
        [ -e "$file" ] || continue
        echo "Loading config from: $file"
        source "$file"
    done
else
    echo "ERROR -> Config directory '$CONFIG_DIR' not found!"
    exit 1
fi

# ========================= Include Function Files ============================
FUNCTIONS_DIR="$PROJECT_FOLDER/Functions"

if [ -d "$FUNCTIONS_DIR" ]; then
    for file in "$FUNCTIONS_DIR"/*.sh; do
        [ -e "$file" ] || continue
        echo "Loading functions from: $file"
        source "$file"
    done
else
    echo "ERROR -> Functions directory '$FUNCTIONS_DIR' not found!"
    exit 1
fi

# =============================== Main Job ===================================
echo "Starting UPS Pickup Job at $(date +%Y-%m-%d\ %H:%M:%S)" | tee -a "$LOG_FILE"

# Step 1: Optimize database
echo "Optimizing database..." | tee -a "$LOG_FILE"
mysql -u"$WEBSITE_DB_USERNAME" -p"$WEBSITE_DB_PASSWORD" -h"$WEBSITE_DB_HOSTNAME" "$WEBSITE_DB_DATABASE" < "$PROJECT_FOLDER/sql/00_Optimize.sql"

# Step 2: Load new jobs
echo "Loading new jobs..." | tee -a "$LOG_FILE"
JOB_LIST_FILE="$PROJECT_FOLDER/temp/job_list.txt"
mysql --skip-column-names -u"$WEBSITE_DB_USERNAME" -p"$WEBSITE_DB_PASSWORD" -h"$WEBSITE_DB_HOSTNAME" "$WEBSITE_DB_DATABASE" < "$PROJECT_FOLDER/sql/01_LoadNewJobs.sql" > "$JOB_LIST_FILE"

readarray -t jobs < "$JOB_LIST_FILE"

# Step 3: Process jobs
for job_id in "${jobs[@]}"; do
    echo "Processing job: $job_id" | tee -a "$LOG_FILE"

    # Load data from DB
    get_data "$job_id"

    # Create JSON for UPS API
    create_json "$job_id"

    # Get authentication token
    get_token

    # Post request to UPS API
    post_return_request_json

    # Optional delay to avoid rate limits
    sleep 2

    # Check response
    check_return_request_json
done

echo "UPS Pickup Job finished at $(date +%Y-%m-%d\ %H:%M:%S)" | tee -a "$LOG_FILE"

exit 0
