using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace MyHTTPFunctionProj
{
    public static class HTTPAdd
    {
        [FunctionName("HTTPAdd")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            int num01 = int.Parse(req.Query["num01"]);
            int num02 = int.Parse(req.Query["num02"]);

            int addition = num01 + num02;

            return new OkObjectResult(addition);
        }
    }
}
