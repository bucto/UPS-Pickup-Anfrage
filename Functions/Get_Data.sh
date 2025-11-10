Get_Data() {

  echo "Starte Datenabruf für UID $x ..."

  # --- UTF-8 sicherstellen ---
  export LANG=de_DE.UTF-8
  export LC_ALL=de_DE.UTF-8

  # --- Variablen initialisieren ---
  COMPANY=''
  NAME=''
  GENDER=''
  ADDRESS=''
  ZIP=''
  CITY=''
  COUNTRY=''
  PHONE=''
  EMAIL=''
  CLOSETIME=''
  READYTIME=''
  PICKUPDATE=''
  TRACKINGNUMBER1=''
  TRACKINGNUMBER2=''
  TRACKINGNUMBER3=''
  TRACKINGNUMBER4=''
  ANSWER=''

  TEMP_XML_PICKUPRESULT="$WORK_FOLDER/PICKUPRESULT/$x.xml"
  TEMP_XML_PICKUPJOB_FINISH="$WORK_FOLDER/PICKUPJOB/$x.xml"

  echo "TEMP_XML_PICKUPRESULT: $TEMP_XML_PICKUPRESULT"
  echo "TEMP_XML_PICKUPJOB_FINISH: $TEMP_XML_PICKUPJOB_FINISH"

  # --- Hilfsfunktion zum MySQL-Abruf ---
  get_value() {
    local field="$1"
    echo "SELECT \`$field\` FROM \`tx_ups_retoure_job\` WHERE \`uid\` = $x" > "$TEMP_SQLJOB"
    mysql --default-character-set=utf8mb4 --skip-column-names \
      -u"$WEBSITE_DB_USERNAME" -p"$WEBSITE_DB_PASSWORD" -h"$WEBSITE_DB_HOSTNAME" "$WEBSITE_DB_DATABASE" \
      < "$TEMP_SQLJOB" > "$TEMP_VALUE"
    cat "$TEMP_VALUE"
  }

  # --- Daten laden ---
  COMPANY=$(get_value "company")
  NAME=$(get_value "lastname")
  GENDER=$(get_value "gender_Text")
  ADDRESS=$(get_value "address")
  ZIP=$(get_value "postcode")
  CITY=$(get_value "city")
  COUNTRY=$(get_value "country")
  PHONE=$(get_value "phone")
  EMAIL=$(get_value "email")
  CLOSETIME=$(get_value "close_time_ups")
  READYTIME=$(get_value "ready_time_ups")
  PICKUPDATE=$(get_value "pickup_date_ups")
  TRACKINGNUMBER1=$(get_value "tracking_number_1")
  TRACKINGNUMBER2=$(get_value "tracking_number_2")
  TRACKINGNUMBER3=$(get_value "tracking_number_3")
  TRACKINGNUMBER4=$(get_value "tracking_number_4")

  # --- Debug-Ausgabe ---
  echo "--------------------------------------"
  echo "Firma:             $COMPANY"
  echo "Name:              $GENDER $NAME"
  echo "Adresse:           $ADDRESS"
  echo "PLZ / Ort:         $ZIP $CITY"
  echo "Land:              $COUNTRY"
  echo "Telefon:           $PHONE"
  echo "E-Mail:            $EMAIL"
  echo "CloseTime:         $CLOSETIME"
  echo "ReadyTime:         $READYTIME"
  echo "PickupDate:        $PICKUPDATE"
  echo "Trackingnummern:   $TRACKINGNUMBER1 | $TRACKINGNUMBER2 | $TRACKINGNUMBER3 | $TRACKINGNUMBER4"
  echo "--------------------------------------"

}
