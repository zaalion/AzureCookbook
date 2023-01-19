# Extracting Text from Images Using OCR


### Flagging PII in text content
```
location="<location>"
endpoint="https://"$location".api.cognitive.microsoft.com/"
textModerationEndpoint=\
    $endpoint"contentmoderator/moderate/v1.0/ProcessText/Screen?PII=true"

curl -X POST $textModerationEndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \
    -H "Content-Type: text/plain" \
    -d "My email address is reza@abcd.com, \
    phone: 9957789887, IP: 255.255.255.255, \
    1005 Gravenstein Highway North Sebastopol, CA 95472"
```

### Sample response
```
{
    "OriginalText": "My email is reza@abcd.com, phone: 9957789887,\
         IP: 255.255.255.255, 1005 Gravenstein Highway North Sebastopol, CA 95472",
    "NormalizedText": " email  reza@abcd.com, phone: 9957789887,\
         IP: 255.255.255.255, 1005 Gravenstein Highway North Sebastopol, CA 95472",
    "Misrepresentation": null,
    "PII": {
        "Email": [
            {
                "Detected": "reza@abcd.com",
                "SubType": "Regular",
                "Text": "reza@abcd.com",
                "Index": 12
            }
        ],
        "IPA": [
            {
                "SubType": "IPV4",
                "Text": "255.255.255.255",
                "Index": 50
            }
        ],
        "Phone": [
            {
                "CountryCode": "US",
                "Text": "9957789887",
                "Index": 34
            }
        ],
        "Address": [
            {
                "Text": "1005 Gravenstein Highway North Sebastopol, CA 95472",
                "Index": 67
            }
        ],
        "SSN": []
    },
    "Language": "eng",
    "Terms": null,
    "Status": {
        "Code": 3000,
        "Description": "OK",
        "Exception": null
    },
    "TrackingId": "33e82de8-aa5d-453e-bedf-46997abf37f9"
}
```