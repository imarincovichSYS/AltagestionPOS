namespace AltanetTBK
{
    partial class MainForm
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.notifyIcon1 = new System.Windows.Forms.NotifyIcon(this.components);
            this.BtnReconectar = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.rbUSBx = new System.Windows.Forms.RadioButton();
            this.rbCOMx = new System.Windows.Forms.RadioButton();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // timer1
            // 
            this.timer1.Interval = 300000;
            // 
            // notifyIcon1
            // 
            this.notifyIcon1.BalloonTipText = "Altanet TBK";
            this.notifyIcon1.BalloonTipTitle = "Altanet TBK";
            this.notifyIcon1.Icon = ((System.Drawing.Icon)(resources.GetObject("notifyIcon1.Icon")));
            this.notifyIcon1.Text = "Altanet TBK";
            this.notifyIcon1.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.notifyIcon1_MouseDoubleClick);
            // 
            // BtnReconectar
            // 
            this.BtnReconectar.Location = new System.Drawing.Point(12, 217);
            this.BtnReconectar.Name = "BtnReconectar";
            this.BtnReconectar.Size = new System.Drawing.Size(361, 57);
            this.BtnReconectar.TabIndex = 0;
            this.BtnReconectar.Text = "Reconectar...";
            this.BtnReconectar.UseVisualStyleBackColor = true;
            this.BtnReconectar.Click += new System.EventHandler(this.BtnReconectar_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(12, 12);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(361, 199);
            this.textBox1.TabIndex = 1;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbUSBx);
            this.groupBox1.Controls.Add(this.rbCOMx);
            this.groupBox1.Location = new System.Drawing.Point(11, 7);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(362, 66);
            this.groupBox1.TabIndex = 2;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "[ Modo conección serial ]";
            // 
            // rbUSBx
            // 
            this.rbUSBx.AutoSize = true;
            this.rbUSBx.Location = new System.Drawing.Point(191, 29);
            this.rbUSBx.Name = "rbUSBx";
            this.rbUSBx.Size = new System.Drawing.Size(145, 19);
            this.rbUSBx.TabIndex = 1;
            this.rbUSBx.TabStop = true;
            this.rbUSBx.Text = "USB de COM3 a COMx";
            this.rbUSBx.UseVisualStyleBackColor = true;
            this.rbUSBx.CheckedChanged += new System.EventHandler(this.rbChangeState);
            // 
            // rbCOMx
            // 
            this.rbCOMx.AutoSize = true;
            this.rbCOMx.Location = new System.Drawing.Point(9, 29);
            this.rbCOMx.Name = "rbCOMx";
            this.rbCOMx.Size = new System.Drawing.Size(142, 19);
            this.rbCOMx.TabIndex = 0;
            this.rbCOMx.TabStop = true;
            this.rbCOMx.Text = "Físicos COM1 / COM2";
            this.rbCOMx.UseVisualStyleBackColor = true;
            this.rbCOMx.CheckedChanged += new System.EventHandler(this.rbChangeState);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(389, 286);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.BtnReconectar);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Altanet TBK";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.Shown += new System.EventHandler(this.MainForm_Shown);
            this.Resize += new System.EventHandler(this.MainForm_Resize);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.NotifyIcon notifyIcon1;
        private System.Windows.Forms.Button BtnReconectar;
        public System.Windows.Forms.Timer timer1;
        public System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton rbUSBx;
        private System.Windows.Forms.RadioButton rbCOMx;
    }
}
