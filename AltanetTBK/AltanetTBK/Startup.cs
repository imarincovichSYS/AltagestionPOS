using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Net.WebSockets;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Net;
using System.Text;
using Newtonsoft.Json;
using AltanetTBK.Models;

namespace AltanetTBK
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public IConfiguration Configuration { get; }
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
        }
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseMvc();
            app.UseWebSockets(new WebSocketOptions { KeepAliveInterval = TimeSpan.FromSeconds(120) });
            app.Run(async (context) =>
            {
                if (context.Request.Path == "/Servicios")
                {
                    if (context.WebSockets.IsWebSocketRequest)
                    {
                        using (WebSocket webSocket = await context.WebSockets.AcceptWebSocketAsync())
                        {
                            await WebSocketService(context, webSocket);
                        }
                    }
                    else
                    {
                        context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                    }
                }
            });
        }
        private async Task WebSocketService(HttpContext context, System.Net.WebSockets.WebSocket websocket)
        {
            var buffer = new byte[1024 * 8];

            WebSocketReceiveResult result = await websocket.ReceiveAsync(new ArraySegment<byte>(buffer), System.Threading.CancellationToken.None);

            if (result != null)
            {
                while (!result.CloseStatus.HasValue)
                {
                    Payload InfoCliente = JsonConvert.DeserializeObject<Payload>(Encoding.UTF8.GetString(buffer, 0, result.Count));

                    // response a cliente....
                    await websocket.SendAsync(
                        new ArraySegment<byte>(Encoding.UTF8.GetBytes(Services.ExecuteAccion(InfoCliente)))
                        , result.MessageType
                        , result.EndOfMessage
                        , System.Threading.CancellationToken.None);

                    await websocket.ReceiveAsync(new ArraySegment<byte>(buffer), System.Threading.CancellationToken.None);
                }
                await websocket.CloseAsync(result.CloseStatus.Value, result.CloseStatusDescription, System.Threading.CancellationToken.None);
            }

        }
    }
}
