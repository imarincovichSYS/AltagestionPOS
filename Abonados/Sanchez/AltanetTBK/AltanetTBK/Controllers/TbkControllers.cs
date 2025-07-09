using Microsoft.AspNetCore.Mvc;
using AltanetTBK.Models;

namespace AltanetTBK.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TbkController : ControllerBase
    {
        [HttpPost]
        public string Servicios([FromBody] Payload InfoCliente)
        {
            return Services.ExecuteAccion(InfoCliente);
        }
    }
}