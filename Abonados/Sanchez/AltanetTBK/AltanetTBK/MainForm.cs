using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Forms;
using Transbank.Exceptions.CommonExceptions;
using Transbank.POSIntegrado;

namespace AltanetTBK
{
    public partial class MainForm : Form
    {
        readonly List<string> ListPorts = POSIntegrado.Instance.ListPorts();
        bool PortCommIsConectado;
        string PortConectado;

        public MainForm()
        {
            InitializeComponent();
        }

        private void MainForm_Shown(object sender, EventArgs e)
        {
            Application.DoEvents();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            //if (rbCOMx.Checked || rbUSBx.Checked)
            //{
            ConectarPuertoCommTBKPOS();
            //}
            //else
            //{
            //    MessageBox.Show("Seleccione tipo de conección");
            //}
        }

        public void rbChangeState(object sender, EventArgs e)
        {
            textBox1.Clear();
        }
        public void Timer1_Tick(object sender, EventArgs e)
        {
            textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: " + PollTest(PortConectado) + Environment.NewLine;
        }

        private void BtnReconectar_Click(object sender, EventArgs e)
        {
            //if (!rbCOMx.Checked && !rbUSBx.Checked)
            //{
            //    MessageBox.Show("Debe seleccionar método de conección; Serial físico COM o Conector USB");
            //}
            //else
            //{
            textBox1.Clear();
            textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: Iniciando conección..." + Environment.NewLine;
            timer1.Stop();
            ConectarPuertoCommTBKPOS();
            //}
        }


        private void ConectarPuertoCommTBKPOS()
        {
            PortCommIsConectado = false;

            foreach (string SerialPortComm in ListPorts)
            {
                // if (rbUSBx.Checked && SerialPortComm != "COM1" && SerialPortComm != "COM2") textBox1.Text += PollTest(SerialPortComm);
                // if (rbCOMx.Checked && SerialPortComm != "COMx") textBox1.Text += PollTest(SerialPortComm);
                textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: Intentando puerto " + SerialPortComm + Environment.NewLine;
                textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: " + PollTest(SerialPortComm) + Environment.NewLine;

                if (PortCommIsConectado)
                {
                    PortConectado = SerialPortComm;
                    break;
                }
            }

            if (!PortCommIsConectado)
            {
                textBox1.Text += DateTime.Now.ToString("HH:mm:ss") + ":: POS/TBK no detectado" + Environment.NewLine;
            }
        }

        private string PollTest(string TBKSerialPort)
        {
            string response = "";

            try
            {
                POSIntegrado.Instance.OpenPort(TBKSerialPort, 115200);
                Task<bool> pollResult = Task.Run(async () => { return await POSIntegrado.Instance.Poll(); });
                pollResult.Wait(2000);

                bool bResult = pollResult.IsCompleted; //pollResult.Result;

                if (bResult)
                {
                    response = "Conectado en puerto: ";
                    PortCommIsConectado = true;
                    // timer1.Start();
                }
                else
                {
                    response = "Poll no responde puerto: ";
                    PortCommIsConectado = false;
                    timer1.Stop();
                    notifyIcon1_MouseDoubleClick(null, null);
                }
            }
            catch (TransbankException ex)
            {
                response = "Error: " + ex.Message;
                timer1.Stop();
                MessageBox.Show(response);
            }

            return response + TBKSerialPort;
        }
        private void MainForm_Resize(object sender, EventArgs e)
        {
            if (this.WindowState == FormWindowState.Minimized)
            {
                Hide();
                notifyIcon1.Visible = true;
            }
        }
        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (!PortCommIsConectado)
            {
                DialogResult dialogResult = MessageBox.Show("¿Seguro de salir Altanet TBK?" + Environment.NewLine + "No podrá realizar ventas", "Altanet TBK", MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes)
                {
                    Environment.Exit(0);
                }
                else if (dialogResult == DialogResult.No)
                {
                    Hide();
                    notifyIcon1.Visible = true;
                    e.Cancel = (e.CloseReason == CloseReason.UserClosing);
                }
            }
            else
            {
                Hide();
                notifyIcon1.Visible = true;
                e.Cancel = (e.CloseReason == CloseReason.UserClosing);
            }
        }

        private void notifyIcon1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            Show();
            this.WindowState = FormWindowState.Normal;
            notifyIcon1.Visible = false;
        }

    }
}
