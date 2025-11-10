Get_Token () {
# === Token prüfen oder anfordern ===
echo "=== Token prüfen oder anfordern ==="
ACCESS_TOKEN=""
NOW=$(date +%s)

if [ -f "$TOKEN_FILE" ]; then
  # Prüfen, ob gespeicherter Token noch gültig ist
  EXPIRY=$(jq -r '.expires_at' "$TOKEN_FILE")
  if [ "$NOW" -lt "$EXPIRY" ]; then
    ACCESS_TOKEN=$(jq -r '.access_token' "$TOKEN_FILE")
    echo "ℹ️  Vorhandener Token noch gültig, wird verwendet."
  else
    echo "ℹ️  Token abgelaufen, erneuere..."
  fi
fi

if [ -z "$ACCESS_TOKEN" ]; then
  # Token anfordern
  RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
    -u "${CLIENT_ID}:${CLIENT_SECRET}" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=client_credentials")

  if [ -z "$RESPONSE" ]; then
    echo "❌ Fehler: Keine Antwort vom UPS Token-Endpoint!"
    exit 1
  fi

  ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token')
  EXPIRES_IN=$(echo "$RESPONSE" | jq -r '.expires_in')  # Sekunden

  if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
    echo "❌ Fehler: Kein Access Token erhalten!"
    echo "Antwort vom Server: $RESPONSE"
    exit 1
  fi

  # Ablaufzeit berechnen und Token speichern (60 Sekunden Puffer)
  EXPIRES_AT=$((NOW + EXPIRES_IN - 60))
  echo "{\"access_token\":\"$ACCESS_TOKEN\",\"expires_at\":$EXPIRES_AT}" > "$TOKEN_FILE"
  echo "✅ Neuer Token erhalten und gespeichert."
fi
}