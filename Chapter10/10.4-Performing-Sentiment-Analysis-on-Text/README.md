# Performing Sentiment Analysis on Text


### Getting content sentiment
```
location="<location>"
endpoint="https://"$location".api.cognitive.microsoft.com/"
sentimentEndpoint=$endpoint"/text/analytics/v3.0/sentiment"

curl -X POST $sentimentEndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \    
    -H 'Content-Type: application/json' \
    -d '{"documents":[{"language":"en","id":"1","text":"I love sunny days!"}]}'
```

### Getting a negative sentiment
```
curl -X POST $sentimentEndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \    
    -H 'Content-Type: application/json' \
    -d '{"documents":[{"language":"en","id":"1","text":"I am not feeling too well!"}]}'
```