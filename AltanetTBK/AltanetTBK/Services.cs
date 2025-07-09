using AltanetTBK.Libs;
using AltanetTBK.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Transbank.Exceptions.CommonExceptions;
using Transbank.POSIntegrado;
using Transbank.Responses.CommonResponses;
using Transbank.Responses.IntegradoResponses;

namespace AltanetTBK
{
    public class Services
    {
        public static string ExecuteAccion(Payload InfoCliente)
        {
            ResponseToERP ResponseToERP = new ResponseToERP();
            MainForm MyForm = new MainForm();

            if (Funciones.GetSignCliente(InfoCliente) != Funciones.GetSignCliente(InfoCliente) /*InfoCliente.TokenSign*/)
            {
                ResponseToERP.StatusIsOK = false;
                ResponseToERP.Mensaje = "Acceso no autorizado a Transbank.";
            }
            else
            {
                // ================================================================================
                // Transacción de Venta
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "VENTA")
                {
                    MyForm.timer1.Stop();
                    MyForm.textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: STOP POLL TIMER" + Environment.NewLine;
                    MyForm.textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: START VENTA" + Environment.NewLine;

                    try
                    {
                        //POSIntegrado.Instance.IntermediateResponseChange += NewIntermadiateMessageRecived; //EventHandler para los mensajes intermedios.
                        Task<SaleResponse> SaleResponse = POSIntegrado.Instance.Sale(InfoCliente.TBKInfo.Monto, InfoCliente.TBKInfo.Numero_Ticket_Boleta, true);
                        if (SaleResponse.IsFaulted)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = JsonConvert.SerializeObject(SaleResponse.Exception.InnerException.Message);
                            //ResponseToERP.DatosResponse = JsonConvert.SerializeObject(Response.Exception);
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(SaleResponse);
                        }
                        MyForm.textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: FIN VENTA (Status: " + ResponseToERP.StatusIsOK.ToString() + ")" + Environment.NewLine;
                        MyForm.textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: START POLL TIMER" + Environment.NewLine;
                        // MyForm.timer1.Start();
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);

                        MyForm.textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: EXCEPTION VENTA" + Environment.NewLine;
                        MyForm.textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: START POLL TIMER" + Environment.NewLine;
                        // MyForm.timer1.Start();
                    }
                }

                // ================================================================================
                // Transacción de Venta Multicodigo
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "VENTA_MULTICODIGO") { }

                // ================================================================================
                // Transacción de última venta
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "ULTIMA_VENTA")
                {
                    try
                    {
                        Task<LastSaleResponse> LastSaleResponse = POSIntegrado.Instance.LastSale();
                        if (LastSaleResponse.IsFaulted)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = JsonConvert.SerializeObject(LastSaleResponse.Exception.InnerException.Message);
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(LastSaleResponse);
                        }
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);
                    }
                }

                // ================================================================================
                // Transacción de última venta multicodigo
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "ULTIMA_VENTA_MULTICODIGO") { }

                // ================================================================================
                // Transacción de Cierre
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "CIERRE")
                {
                    try
                    {
                        Task<CloseResponse> CloseResponse = POSIntegrado.Instance.Close();
                        if (CloseResponse.IsFaulted)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = JsonConvert.SerializeObject(CloseResponse.Exception.InnerException.Message);
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(CloseResponse);
                        }
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);
                    }
                }

                // ================================================================================
                // Transacción Totales
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "TOTALES")
                {
                    try
                    {
                        Task<TotalsResponse> TotalsResponse = POSIntegrado.Instance.Totals();
                        if (TotalsResponse.IsFaulted)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = JsonConvert.SerializeObject(TotalsResponse.Exception.InnerException.Message);
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(TotalsResponse);
                        }
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);
                    }
                }

                // ================================================================================
                // Transacción de Detalle de Ventas
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "DETALLE_DE_VENTAS")
                {
                    try
                    {
                        // OJO bool printOnPOS = false; 
                        Task<List<DetailResponse>> DetailResponse = POSIntegrado.Instance.Details(InfoCliente.TBKInfo.printOnPOS);
                        if (DetailResponse.IsFaulted)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = JsonConvert.SerializeObject(DetailResponse.Exception.InnerException.Message);
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(DetailResponse);
                        }
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);
                    }
                }

                // ================================================================================
                // Transacción de Detalle de Ventas Multicodigo
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "DETALLE_DE_VENTAS_MULTICODIGO") { }

                // ================================================================================
                // Transacción de Carga de Llaves
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "CARGA_DE_LLAVES") { }

                // ================================================================================
                // Transacción de Poll
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "POLL")
                {
                    try
                    {
                        Task<bool> connected = Task.Run(async () => { return await POSIntegrado.Instance.Poll(); });
                        connected.Wait(200);

                        bool bResult = connected.IsCompleted; // connected.Result

                        if (!bResult)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = "Problema en POS, verifique conección";
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(connected);
                        }
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);
                    }
                }

                // ================================================================================
                // Transacción de Cambio a POS Normal
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "CAMBIO_A_POS_NORMAL")
                {
                    try
                    {
                        Task<bool> connected = POSIntegrado.Instance.SetNormalMode();
                        if (connected.IsFaulted)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = JsonConvert.SerializeObject(connected.Exception.InnerException.Message);
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(connected);
                        }
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);
                    }
                }

                // ================================================================================
                // Transacción de Anulacion
                // ================================================================================
                if (InfoCliente.Accion.ToUpper() == "ANULACION")
                {
                    try
                    {
                        Task<RefundResponse> connected = POSIntegrado.Instance.Refund(InfoCliente.TBKInfo.Voucher_de_Venta);
                        if (connected.IsFaulted)
                        {
                            ResponseToERP.StatusIsOK = false;
                            ResponseToERP.Mensaje = JsonConvert.SerializeObject(connected.Exception.InnerException.Message);
                        }
                        else
                        {
                            ResponseToERP.StatusIsOK = true;
                            ResponseToERP.DatosResponse = JsonConvert.SerializeObject(connected);
                        }
                    }
                    catch (TransbankException ex)
                    {
                        ResponseToERP.StatusIsOK = false;
                        ResponseToERP.DatosResponse = JsonConvert.SerializeObject(ex.Message);
                    }
                }
            }

            return JsonConvert.SerializeObject(ResponseToERP);

        }

        private void NewIntermadiateMessageRecived(object sender, IntermediateResponse e)
        {
            //...
        }
    }
}