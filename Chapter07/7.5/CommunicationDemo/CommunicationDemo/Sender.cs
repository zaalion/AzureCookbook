using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace CommunicationDemo
{
    public static class Sender
    {
        [FunctionName("Sender")]
        [return: ServiceBus("ordersqueue", Connection = "ServiceBusConnection")]
        public static string Run(
            [HttpTrigger(AuthorizationLevel.Function, 
            "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var output = new
            {
                Kind=req.Query["kind"],
                Count = req.Query["count"]
            }; 

            string queueMessage = JsonConvert.SerializeObject(output);
            return queueMessage;
        }
    }
}
