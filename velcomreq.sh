ACTION="/VPartnerGw/OpenAPIGetExtendedBalanceV1"
URL="https://my.a1.by/openapi"
request="<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAPENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchemainstance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
 <SOAP-ENV:Body><m:OpenAPIGetExtendedBalanceV1Request xmlns:m=\"http://eai.velcom.by/VPartnerGw\">
 <IssaLogin>375xxxxxxxx</IssaLogin>
 <IssaPassword>YOUR_PASSWORD</IssaPassword>
 <ApplicationCode>YOUR_ANY_GET_BALANCE_NAME</ApplicationCode>
 </m:OpenAPIGetExtendedBalanceV1Request></SOAP-ENV:Body></SOAP-ENV:Envelope>
"

if ping -c 1 a1.by &> /dev/null
then  
	wget --post-data="$request" --header="Content-Type: text/xml" --header="SOAPAction: "$ACTION $URL -O /tmp/SOAP.xml
	balance=$(grep -o 'BalanceValue xmlns=\"\">.*</Balance' /tmp/SOAP.xml | sed 's/\(BalanceValue xmlns="">\|<\/Balance\)//g')
	FreeMB=$(grep -o 'FreeMB xmlns=\"\">.*</FreeMB' /tmp/SOAP.xml | sed 's/\(FreeMB xmlns="">\|<\/FreeMB\)//g')
	ExtendedBalanceTimestamp=$(grep -o 'ExtendedBalanceTimestamp xmlns=\"\">.*</ExtendedBalanceTimestamp' /tmp/SOAP.xml | sed 's/\(ExtendedBalanceTimestamp xmlns="">\|<\/ExtendedBalanceTimestamp\)//g')
	echo $balance"р. ("$FreeMB" МБ) на "$ExtendedBalanceTimestamp > /tmp/balweb
	exit 1
else
# for pid in $(pgrep -f VelcomReq.sh); do
#    if [ $pid != $$ ]; then
#       logger VelcomReq "[$(date)] : VelcomReq.sh : Process is already running with PID $pid"
#        exit 1
#    else
#      logger VelcomReq "VelcomReq.sh Running with PID $pid"
#    fi  
	logger VelcomReq "Ping test returns error... ExitJob"
	exit 1
fi
