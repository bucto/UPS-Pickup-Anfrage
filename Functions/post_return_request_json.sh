#!/bin/bash
# ==============================================================================
# Function: Post_ReturnRequestJSON
# Description: Sends the pickup request JSON to the UPS API.
# ==============================================================================

Post_ReturnRequestJSON() {
  echo "Sending pickup request for job $x..."

  TEMP_JSON_PICKUPRESULT="$WORK_FOLDER/JSON_RESPONSE/$x.json"

  curl -s -X POST "https://onlinetools.ups.com/api/pickupcreation/v1/pickups" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -d @"$TEMP_JSON_PICKUPREQUEST" \
    > "$TEMP_JSON_PICKUPRESULT"

  echo "UPS response saved: $TEMP_JSON_PICKUPRESULT"
}
