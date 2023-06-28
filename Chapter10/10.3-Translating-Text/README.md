# Translating Text


### Getting the list of supported languages
```
endpoint="https://api.cognitive.microsofttranslator.com"

curl --request GET $endpoint"/languages?api-version=3.0"
```

### Detecting content language
```
{
detectionEndpoint=$endpoint"/detect?api-version=3.0"

curl -X POST $detectionEndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \
    -H "Ocp-Apim-Subscription-Region: $region" \
    -H 'Content-Type: application/json' \
    -d '[{ "Text": "Cognitive Services brings AI within reach of every developer." }]'
```

### Translating contect
```
translationEndpoint=$endpoint"/translate?api-version=3.0&from=en&to=es"

curl -X POST $translationEndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \
    -H "Ocp-Apim-Subscription-Region: $region" \
    -H 'Content-Type: application/json' \
    -d '[{ "Text": "Cognitive Services brings AI within reach of every developer." }]'
```