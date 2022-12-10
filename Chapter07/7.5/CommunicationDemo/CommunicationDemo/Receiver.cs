using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace CommunicationDemo
{
    public class Receiver
    {
        [FunctionName("Receiver")]
        public void Run([ServiceBusTrigger
            ("ordersqueue", Connection = "ServiceBusConnection")]
            string myQueueItem, ILogger log)
        {
            log.LogInformation
                ($"Recieved from queue >>>> " +
                $"{myQueueItem}");
        }
    }
}
