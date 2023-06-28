# Detecting Objects in Images


### Detecting objects in a sample image
```
endpoint="https://"$region".api.cognitive.microsoft.com/"
imageDetectionEndpoint=$endpoint"/vision/v3.1/detect"

curl -X POST $imageDetectionEndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \
    -F 'image=@city.jpg'
```

### Sample response
```
{
    "objects": [
        {
            "rectangle": {
                "x": 139,
                "y": 42,
                "w": 179,
                "h": 509
            },
            "object": "tower",
            "confidence": 0.515,
            "parent": {
                "object": "building",
                "confidence": 0.849
            }
        },
        {
            "rectangle": {
                "x": 743,
                "y": 345,
                "w": 189,
                "h": 182
            },
            "object": "building",
            "confidence": 0.717
        },
        {
            "rectangle": {
                "x": 374,
                "y": 250,
                "w": 360,
                "h": 293
            },
            "object": "building",
            "confidence": 0.612
        }
    ],
    "requestId": "4760d0f9-f507-4a70-9e9c-124df985d209",
    "metadata": {
        "height": 658,
        "width": 935,
        "format": "Jpeg"
    }
}
```