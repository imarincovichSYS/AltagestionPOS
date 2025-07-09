using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AltanetTBK.Models
{
    public class TBKInfo
    {
        public int Monto { set; get; }
        public string Numero_Ticket_Boleta { set; get; }
        public string Codigo_de_Comercio { set; get; }
        public bool Enviar_Status { set; get; }
        public int Voucher_de_Venta { set; get; }
        public bool printOnPOS { set; get; }
    }
    public class Payload
    {
        public string Accion { set; get; }
        public TBKInfo TBKInfo { set; get; }
        public string KeySign { set; get; }
        public string TokenSign { set; get; }
    }
    public class ResponseToERP
    {
        public bool StatusIsOK { set; get; }
        public string Mensaje { set; get; }
        public string DatosResponse { set; get; }
    }

}
