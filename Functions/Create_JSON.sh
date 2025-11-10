Create_JSON() {
  echo "Erstelle JSON für UPS Pickup..."

  # --- Alle Trackingnummern in ein Array packen ---
  TRACKING_NUMBERS=()
  [ -n "$TRACKINGNUMBER1" ] && TRACKING_NUMBERS+=("1Z07W90F91$TRACKINGNUMBER1")
  [ -n "$TRACKINGNUMBER2" ] && TRACKING_NUMBERS+=("1Z07W90F91$TRACKINGNUMBER2")
  [ -n "$TRACKINGNUMBER3" ] && TRACKING_NUMBERS+=("1Z07W90F91$TRACKINGNUMBER3")
  [ -n "$TRACKINGNUMBER4" ] && TRACKING_NUMBERS+=("1Z07W90F91$TRACKINGNUMBER4")

 Telefonnummer auf numerisches Format bringen
PHONE_CLEAN=$(echo "$PHONE" | tr -d ' +()-.')

# Falls leer, einen Dummy eintragen, sonst UPS meckert
[ -z "$PHONE_CLEAN" ] && PHONE_CLEAN="490000000000"



  # --- JSON mit jq erzeugen ---
  jq -n \
    --arg account "$ACCOUNT_NUMBER" \
    --arg country "$COUNTRY" \
    --arg closet "$CLOSETIME" \
    --arg ready "$READYTIME" \
    --arg date "$PICKUPDATE" \
    --arg company "$COMPANY" \
    --arg name "$NAME" \
    --arg address "$ADDRESS" \
    --arg city "$CITY" \
    --arg zip "$ZIP" \
    --arg phone "$PHONE_CLEAN" \
    --arg email "${EMAIL:-thomas.buecken@amada.de}" \
    --arg payment "01" \
    --arg serviceCategory "$([ "$COUNTRY" == "DE" ] && echo "01" || echo "03")" \
    --arg special "Create by AMADA Webserver" \
    --arg reference "Create by AMADA Webserver" \
    --arg weight "1" \
    --arg unit "LBS" \
    --arg overweight "N" \
    --argjson returnTracking "$(jq -nc '$ARGS.positional' --args "${TRACKING_NUMBERS[@]}")" \
    '{
      PickupCreationRequest: {
        RatePickupIndicator: "N",
        Shipper: { Account: { AccountNumber: $account, AccountCountryCode: $country } },
        PickupDateInfo: { CloseTime: $closet, ReadyTime: $ready, PickupDate: $date },
        PickupAddress: {
          CompanyName: $company,
          ContactName: $name,
          AddressLine: $address,
          City: $city,
          PostalCode: $zip,
          CountryCode: $country,
          ResidentialIndicator: "Y",
          Phone: { Number: $phone }
        },
        AlternateAddressIndicator: "N",
        PickupPiece: [
          { ServiceCode: "011", Quantity: "1", DestinationCountryCode: $country, ContainerCode: "01" }
        ],
        TotalWeight: { Weight: $weight, UnitOfMeasurement: $unit },
        OverweightIndicator: $overweight,
        ReturnTrackingNumber: $returnTracking,
        PaymentMethod: $payment,
        ServiceCategory: $serviceCategory,
        SpecialInstruction: $special,
        ReferenceNumber: $reference,
        Notification: { ConfirmationEmailAddress: $email, UndeliverableEmailAddress: $email }
      }
    }' > "$TEMP_JSON_PICKUPJOB_FINAL"

  echo "JSON erfolgreich erstellt: $TEMP_JSON_PICKUPJOB_FINAL"
  echo "------"
  #cat "$TEMP_JSON_PICKUPJOB_FINAL"
}
