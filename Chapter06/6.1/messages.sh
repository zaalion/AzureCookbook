#!/bin/bash

endpoint=\
  "https://$eventHubNamespaceName.servicebus.windows.net/inputHub/messages"

messageCount=150

for (( i=1; i<=$messageCount; i++ ))
do

  randomTemp=$(($RANDOM/100)) # to get a temperature between 0 and 327 degrees
  event=\
    '{"DeviceID": "T-001","Temperature": $randomTemp}'

  curl -X POST \
    -H "Authorization: \
    SharedAccessSignature \
    sr=$eventHubNamespaceName.servicebus.windows.net\
    &sig=$nsKey01&se=1735693200\
    &skn=RootManageSharedAccessKey" \
    -d "$event" \
    $endpoint \
    --verbose

done