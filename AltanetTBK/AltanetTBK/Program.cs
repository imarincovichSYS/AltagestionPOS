using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using System;
using System.Diagnostics;
using System.Windows.Forms;

namespace AltanetTBK
{
    internal static class Program
    {
        /// <summary>
        ///  The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void Main(string[] args)
        {
            try
            {
                if (!IsApplicationAlreadyRunning())
                {
                    CreateWebHostBuilder(args).Build().RunAsync();

                    Application.EnableVisualStyles();
                    Application.SetCompatibleTextRenderingDefault(false);
                    Application.Run(new MainForm());
                }
                else
                {
                    MessageBox.Show("Ya esta en ejecucion, revise área de notificaciones ...");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error en ejecucion ..." + ex.ToString());
            }


        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
            .UseUrls("http://localhost:40443") // <-----
            .UseStartup<Startup>();

        static bool IsApplicationAlreadyRunning()
        {
            string proc = Process.GetCurrentProcess().ProcessName;
            Process[] processes = Process.GetProcessesByName(proc);
            return processes.Length > 1;
        }


    }
}
