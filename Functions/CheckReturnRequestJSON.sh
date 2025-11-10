CheckReturnRequestJSON() {
    echo "Prüfe UPS JSON-Antwort …"

    # Prüfen ob Datei existiert
    if [ ! -f "$TEMP_JSON_PICKUPRESULT" ]; then
        echo "Datei $TEMP_JSON_PICKUPRESULT existiert nicht!"
        return 1
    fi

    # JSON auslesen
    RESPONSE_CODE=$(jq -r '.PickupCreationResponse.Response.ResponseStatus.Code' "$TEMP_JSON_PICKUPRESULT")
    RESPONSE_DESC=$(jq -r '.PickupCreationResponse.Response.ResponseStatus.Description' "$TEMP_JSON_PICKUPRESULT")
    PRN=$(jq -r '.PickupCreationResponse.PRN' "$TEMP_JSON_PICKUPRESULT")

    if [ "$RESPONSE_CODE" = "1" ]; then
        echo "Übertragung war erfolgreich: $RESPONSE_DESC"
        echo "PRN: $PRN"

        # MySQL-Update
        PRN_ESCAPED=$(printf '%s\n' "$PRN" | sed "s/'/''/g")
        SQL="UPDATE \`tx_ups_retoure_job\`
             SET \`transfered\`='1',
                 \`response_status\`='TRANSMIT',
                 \`response_information\`='$PRN_ESCAPED',
                 \`error\`='0',
                 \`error_description\`=''
             WHERE \`uid\`=$x;"
        echo "$SQL" | mysql -u"$WEBSITE_DB_USERNAME" -p"$WEBSITE_DB_PASSWORD" -h"$WEBSITE_DB_HOSTNAME" "$WEBSITE_DB_DATABASE"

    else
        echo "Übertragung hat einen Fehler: $RESPONSE_DESC"

        # Optional: Error Code aus Alert auslesen
        ERROR_CODE=$(jq -r '.PickupCreationResponse.Response.Alert.Code // empty' "$TEMP_JSON_PICKUPRESULT")
        ERROR_DESC=$(jq -r '.PickupCreationResponse.Response.Alert.Description // empty' "$TEMP_JSON_PICKUPRESULT")
        ERROR_INFO="${ERROR_CODE:-UNKNOWN} - ${ERROR_DESC:-No description}"

        ERROR_ESCAPED=$(printf '%s\n' "$ERROR_INFO" | sed "s/'/''/g")
        SQL="UPDATE \`tx_ups_retoure_job\`
             SET \`transfered\`='1',
                 \`response_status\`='ERROR',
                 \`error\`='1',
                 \`response_information\`='$ERROR_ESCAPED'
             WHERE \`uid\`=$x;"
        echo "$SQL" | mysql -u"$WEBSITE_DB_USERNAME" -p"$WEBSITE_DB_PASSWORD" -h"$WEBSITE_DB_HOSTNAME" "$WEBSITE_DB_DATABASE"
    fi

    # Auswertung und Backup
    mysql -u"$WEBSITE_DB_USERNAME" -p"$WEBSITE_DB_PASSWORD" -h"$WEBSITE_DB_HOSTNAME" "$WEBSITE_DB_DATABASE" < "$WORK_FOLDER/sql/02_Auswertung.sql"
    mysqldump --default-character-set=utf8 -u"$WEBSITE_DB_USERNAME" -p"$WEBSITE_DB_PASSWORD" -h"$WEBSITE_DB_HOSTNAME" "$WEBSITE_DB_DATABASE" tx_ups_retoure_job > /usr/home/wwwrau/for_intranet/AMADA_Return_Service.sql
}
