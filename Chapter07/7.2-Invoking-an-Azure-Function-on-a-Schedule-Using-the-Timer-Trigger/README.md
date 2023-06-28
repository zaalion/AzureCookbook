# Invoking an Azure Function on a Schedule Using the Timer Trigger


### Timer-triggered function body
```
using System;

public static void Run(TimerInfo myTimer, ILogger log)
{
    log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
}
```

### function.json
```
{
  "bindings": [
    {
      "name": "myTimer",
      "type": "timerTrigger",
      "direction": "in",
      "schedule": "*/10 * * * * *"
    }
  ]
}
```

### Clean up
```
az group delete --name $rgName
```