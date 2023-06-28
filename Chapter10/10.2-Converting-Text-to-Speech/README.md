# Converting Text to Speech


### Finding the correct endpoint
```
endpoint="https://"$region".tts.speech.microsoft.com/cognitiveservices/v1"
```

### Calling the text-to-speech API using cURL
```
text="You successfully converted a sample \
    text to speech using Azure Cognitive Services."

outputPath="<file-path>/speech.wav"

curl -X POST $endpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \
    -H 'X-Microsoft-OutputFormat: riff-24khz-16bit-mono-pcm' \
    -H 'Content-Type: application/ssml+xml' \
    -d "<speak version='1.0' xml:lang='en-US'><voice xml:lang='en-US' \
    xml:gender='Male' name='en-CA-LiamNeural'>$text</voice></speak>" \
    >> $outputPath
```