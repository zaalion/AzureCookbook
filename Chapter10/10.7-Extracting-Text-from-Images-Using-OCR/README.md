# Extracting Text from Images Using OCR


### Performing OCR
```
location="<location>"
endpoint="https://"$location".api.cognitive.microsoft.com/"
imageOCREndpoint=$endpoint"/vision/v3.1/ocr?detectOrientation=true"

curl -X POST $imageOCREndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \
    -F 'image=@Yosemite.jpg'
```

### Sample response
```
{
"language": "en",
"textAngle": 0.0,
"orientation": "Up",
"regions": [
    {
        "boundingBox": "80,165,407,117",
        "lines": [
            {
                "boundingBox": "80,165,53,11",
                "words": [
                    {
                        "boundingBox": "80,165,53,11",
                        "text": "*UNITED."
                    }
                ]
            },
            {
                "boundingBox": "90,181,79,11",
                "words": [
                    {
                        "boundingBox": "90,181,79,11",
                        "text": "DEPARTMENT"
                    }
                ]
            },
            {
                "boundingBox": "86,196,152,13",
                "words": [
                    {
                        "boundingBox": "86,197,65,10",
                        "text": "NATIONAL."
                    },
                    {
                        "boundingBox": "153,198,31,9",
                        "text": "PARK"
                    },
                    {
                        "boundingBox": "189,196,49,13",
                        "text": "SÉQVice"
                    }
                ]
            },
            {
                "boundingBox": "88,235,399,47",
                "words": [
                    {
                        "boundingBox": "88,235,399,47",
                        "text": "YOSEMITE"
                    }
                ]
            }
        ]
    },
    {
        "boundingBox": "509,236,152,43",
        "lines": [
            {
                "boundingBox": "512,236,149,17",
                "words": [
                    {
                        "boundingBox": "512,236,149,17",
                        "text": "NATIONAL"
                    }
                ]
            },
            {
                "boundingBox": "509,262,74,17",
                "words": [
                    {
                        "boundingBox": "509,262,74,17",
                        "text": "PARK"
                    }
                ]
            }
        ]
    }
]}
```