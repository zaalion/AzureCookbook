# Creating Captions for Images


### Describing an image (caption creation)
```
location="<location>"
endpoint="https://"$location".api.cognitive.microsoft.com/"
imageDescribeEndpoint=$endpoint"/vision/v3.1/describe"

curl -X POST $imageDescribeEndpoint \
    -H "Ocp-Apim-Subscription-Key: $key1" \
    -F 'image=@trees.jpg'
```

### Sample response
```
{
    "description": {
        "tags": [
            "tree",
            "outdoor",
            "way",
            "stone",
            "old",
            "sidewalk",
            "surrounded"
        ],
        "captions": [
            {
                "text": "a sidewalk with trees and buildings",
                "confidence": 0.2869868874549866
            }
        ]
    },
    "requestId": "6404c4d2-3874-4cb3-bcfe-f4b73d7790c1",
    "metadata": {
        "height": 998,
        "width": 1331,
        "format": "Jpeg"
    }
}
```