Create_XML () {
 echo "XML Datei erzeugen"

 cat MASTER/MASTER_OAuth.xml > $TEMP_XML_PICKUPJOB
 		
 echo "			<Shipper>" >> $TEMP_XML_PICKUPJOB
 echo "				<Account>" >> $TEMP_XML_PICKUPJOB
 echo "					<AccountNumber>07W90F</AccountNumber>" >> $TEMP_XML_PICKUPJOB
 echo "					<AccountCountryCode>DE</AccountCountryCode>" >> $TEMP_XML_PICKUPJOB
 echo "				</Account>" >> $TEMP_XML_PICKUPJOB
 echo "			</Shipper>" >> $TEMP_XML_PICKUPJOB			
 echo "			<PickupDateInfo>" >> $TEMP_XML_PICKUPJOB
 echo "				<CloseTime>$CLOSETIME</CloseTime>" >> $TEMP_XML_PICKUPJOB
 echo "				<ReadyTime>$READYTIME</ReadyTime>" >> $TEMP_XML_PICKUPJOB
 echo "				<PickupDate>$PICKUPDATE</PickupDate>" >> $TEMP_XML_PICKUPJOB
 echo "			</PickupDateInfo>" >> $TEMP_XML_PICKUPJOB			
 echo "			<PickupAddress>" >> $TEMP_XML_PICKUPJOB
 echo "				<CompanyName>$COMPANY</CompanyName>" >> $TEMP_XML_PICKUPJOB
# echo "				<ContactName>$GENDER $NAME</ContactName>" >> $TEMP_XML_PICKUPJOB 
 echo "				<ContactName>$NAME</ContactName>" >> $TEMP_XML_PICKUPJOB
 echo "				<AddressLine>$ADRESS</AddressLine>" >> $TEMP_XML_PICKUPJOB
 echo "				<Room></Room>" >> $TEMP_XML_PICKUPJOB
 echo "				<Floor></Floor>" >> $TEMP_XML_PICKUPJOB
 echo "				<City>$CITY</City>" >> $TEMP_XML_PICKUPJOB
 echo "				<StateProvince></StateProvince>" >> $TEMP_XML_PICKUPJOB
 echo "				<Urbanization/>" >> $TEMP_XML_PICKUPJOB
 echo "				<PostalCode>$ZIP</PostalCode>" >> $TEMP_XML_PICKUPJOB
 echo "				<CountryCode>$COUNTRY</CountryCode>" >> $TEMP_XML_PICKUPJOB
 echo "				<ResidentialIndicator>Y</ResidentialIndicator>" >> $TEMP_XML_PICKUPJOB
 echo "				<PickupPoint></PickupPoint>" >> $TEMP_XML_PICKUPJOB
 echo "				<Phone>" >> $TEMP_XML_PICKUPJOB

# echo "				<Number>0049 2104 2126</Number>" >> $TEMP_XML_PICKUPJOB
if [ -n "$PHONE" ];then
  echo "      <Number>$PHONE</Number>" >> $TEMP_XML_PICKUPJOB
 else
  echo "      <Number>0049 2104 2126</Number>" >> $TEMP_XML_PICKUPJOB
fi 



 echo "					<Extension></Extension>" >> $TEMP_XML_PICKUPJOB
 echo "				</Phone>" >> $TEMP_XML_PICKUPJOB
 echo "			</PickupAddress>" >> $TEMP_XML_PICKUPJOB
 echo "			<AlternateAddressIndicator>N</AlternateAddressIndicator>" >> $TEMP_XML_PICKUPJOB
 echo "			<PickupPiece>" >> $TEMP_XML_PICKUPJOB
 echo "				<ServiceCode>011</ServiceCode>" >> $TEMP_XML_PICKUPJOB
 echo "				<Quantity>1</Quantity>" >> $TEMP_XML_PICKUPJOB
 echo "				<DestinationCountryCode>DE</DestinationCountryCode>" >> $TEMP_XML_PICKUPJOB
 echo "				<ContainerCode>01</ContainerCode>" >> $TEMP_XML_PICKUPJOB
 echo "			</PickupPiece>" >> $TEMP_XML_PICKUPJOB
 echo "			<TotalWeight>" >> $TEMP_XML_PICKUPJOB
 echo "				<Weight>1</Weight>" >> $TEMP_XML_PICKUPJOB
 echo "				<UnitOfMeasurement>LBS</UnitOfMeasurement>" >> $TEMP_XML_PICKUPJOB
 echo "			</TotalWeight>" >> $TEMP_XML_PICKUPJOB
 echo "			<OverweightIndicator>N</OverweightIndicator>" >> $TEMP_XML_PICKUPJOB
# echo "      <ReturnTrackingNumber>1Z07W90F91$TRACKINGNUMBER1</ReturnTrackingNumber>" >> $TEMP_XML_PICKUPJOB
if [ -n "$TRACKINGNUMBER1" ];then
 echo "      <ReturnTrackingNumber>1Z07W90F91$TRACKINGNUMBER1</ReturnTrackingNumber>" >> $TEMP_XML_PICKUPJOB
fi

if [ -n "$TRACKINGNUMBER2" ];then
 echo "      <ReturnTrackingNumber>1Z07W90F91$TRACKINGNUMBER2</ReturnTrackingNumber>" >> $TEMP_XML_PICKUPJOB
fi

if [ -n "$TRACKINGNUMBER3" ];then
 echo "      <ReturnTrackingNumber>1Z07W90F91$TRACKINGNUMBER3</ReturnTrackingNumber>" >> $TEMP_XML_PICKUPJOB
fi

if [ -n "$TRACKINGNUMBER4" ];then
 echo "      <ReturnTrackingNumber>1Z07W90F91$TRACKINGNUMBER4</ReturnTrackingNumber>" >> $TEMP_XML_PICKUPJOB
fi 

 echo "			<PaymentMethod>01</PaymentMethod>" >> $TEMP_XML_PICKUPJOB


echo $COUNTRY
if [ "$COUNTRY" == "DE" ];then
 ##echo "Es ist Deutschland"
 echo "      <ServiceCategory>01</ServiceCategory>" >> $TEMP_XML_PICKUPJOB
 else
  ## echo "Es ist Ausland"
  echo "      <ServiceCategory>03</ServiceCategory>" >> $TEMP_XML_PICKUPJOB
fi





 echo "			<SpecialInstruction>Create by AMADA Webserver</SpecialInstruction>" >> $TEMP_XML_PICKUPJOB
 echo "			<ReferenceNumber>Create by AMADA Webserver</ReferenceNumber>" >> $TEMP_XML_PICKUPJOB
 echo "			<Notification>" >> $TEMP_XML_PICKUPJOB
# echo "      <ConfirmationEmailAddress>thomas.buecken@amada.de</ConfirmationEmailAddress>" >> $TEMP_XML_PICKUPJOB

if [ -n "$EMAIL" ];then
  echo "      <ConfirmationEmailAddress>$EMAIL</ConfirmationEmailAddress>" >> $TEMP_XML_PICKUPJOB
 else
  echo "      <ConfirmationEmailAddress>thomas.buecken@amada.de</ConfirmationEmailAddress>" >> $TEMP_XML_PICKUPJOB
fi 

 echo "				<UndeliverableEmailAddress>thomas.buecken@amada.de</UndeliverableEmailAddress>" >> $TEMP_XML_PICKUPJOB
 echo "			</Notification>" >> $TEMP_XML_PICKUPJOB
 echo "		</PickupCreationRequest>" >> $TEMP_XML_PICKUPJOB
 echo "	</envr:Body>" >> $TEMP_XML_PICKUPJOB
 echo "</envr:Envelope>" >> $TEMP_XML_PICKUPJOB
 
  
 iconv --from-code=ISO-8859-1 --to-code=UTF-8 $TEMP_XML_PICKUPJOB > $TEMP_XML_PICKUPJOB_FINISH
}