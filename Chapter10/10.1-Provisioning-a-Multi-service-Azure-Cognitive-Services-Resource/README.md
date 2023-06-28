# Provisioning a Multi-service Azure Cognitive Services Resource


### Listing Cognitive Services service kinds
```
az cognitiveservices account list-kinds
```

### Cognitive Services kinds
```
[
  "AnomalyDetector",
  "CognitiveServices",
  "ComputerVision",
  "ContentModerator",
  "ConversationalLanguageUnderstanding",
  "CustomVision.Prediction",
  "CustomVision.Training",
  "Face",
  "FormRecognizer",
  "ImmersiveReader",
  "Internal.AllInOne",
  "LUIS",
  "LUIS.Authoring",
  "LanguageAuthoring",
  "MetricsAdvisor",
  "Personalizer",
  "QnAMaker.v2",
  "SpeechServices",
  "TextAnalytics",
  "TextTranslation"
]
```

### Provisioning a multi-service Cognitive Services resource
```
serviceName="<cog-service-name>"

az cognitiveservices account create \
  --name $serviceName \
  --resource-group $rgName \
  --sku S0 \
  --kind CognitiveServices \
  --location $region
```

### Grabbing the service key
```
key1=$(key1=$(az cognitiveservices account keys list \
  --name $serviceName \
  --resource-group $rgName \
  --query key1 \
  --output tsv))

echo $key1
```