#!/bin/bash
# ==============================================================================
# Function: Get_Token
# Description: Retrieves and caches the UPS OAuth access token.
# ==============================================================================

Get_Token() {
  echo "Requesting UPS access token..."

  local TOKEN_FILE="$PROJECT_FOLDER/temp/token.json"

  curl -s -X POST "https://onlinetools.ups.com/security/v1/oauth/token" \
    -u "$UPS_CLIENT_ID:$UPS_CLIENT_SECRET" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=client_credentials" \
    > "$TOKEN_FILE"

  ACCESS_TOKEN=$(jq -r '.access_token' "$TOKEN_FILE")

  if [[ -z "$ACCESS_TOKEN" || "$ACCESS_TOKEN" == "null" ]]; then
    echo "ERROR: Unable to retrieve UPS access token!"
    exit 1
  fi

  echo "Access token retrieved successfully."
}
