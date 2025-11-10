PostReturnRequestJSON () {
	echo "PostReturnRequestJSON"
	# === Pickup SOAP-Request senden ===
	curl -s -X POST \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $ACCESS_TOKEN" \
	-H "transId: $(uuidgen)" \
	-H "transactionSrc: testing" \
	--data @"$TEMP_JSON_PICKUPJOB_FINAL" \
	"$PICKUP_URL" > "$TEMP_JSON_PICKUPRESULT"
	
	
	# Prüfen, ob Ergebnis existiert und ausgeben
if [ -s "$TEMP_JSON_PICKUPRESULT" ]; then
  echo "📄 Pickup-Request erfolgreich gesendet. Ergebnis gespeichert in $TEMP_JSON_PICKUPRESULT"
else
  echo "❌ Fehler: Keine Antwort vom Pickup-Service!"
fi
}
