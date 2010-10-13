namespace UI
{
    partial class Product
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.textBoxUpdateID = new System.Windows.Forms.TextBox();
            this.buttonSave = new System.Windows.Forms.Button();
            this.textBoxUpdateDesc = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.textBoxUpdateName = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.textBoxDeleteId = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.buttonDelete = new System.Windows.Forms.Button();
            this.panel3 = new System.Windows.Forms.Panel();
            this.textBoxInsertID = new System.Windows.Forms.TextBox();
            this.textBoxInsertName = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.buttonInsert = new System.Windows.Forms.Button();
            this.textBoxInsertDesc = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(15, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(58, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Product ID";
            // 
            // textBoxUpdateID
            // 
            this.textBoxUpdateID.Location = new System.Drawing.Point(18, 30);
            this.textBoxUpdateID.Name = "textBoxUpdateID";
            this.textBoxUpdateID.Size = new System.Drawing.Size(100, 20);
            this.textBoxUpdateID.TabIndex = 5;
            // 
            // buttonSave
            // 
            this.buttonSave.Location = new System.Drawing.Point(394, 79);
            this.buttonSave.Name = "buttonSave";
            this.buttonSave.Size = new System.Drawing.Size(75, 23);
            this.buttonSave.TabIndex = 8;
            this.buttonSave.Text = "&Update";
            this.buttonSave.UseVisualStyleBackColor = true;
            this.buttonSave.Click += new System.EventHandler(this.buttonSave_Click);
            // 
            // textBoxUpdateDesc
            // 
            this.textBoxUpdateDesc.Location = new System.Drawing.Point(18, 81);
            this.textBoxUpdateDesc.Name = "textBoxUpdateDesc";
            this.textBoxUpdateDesc.Size = new System.Drawing.Size(364, 20);
            this.textBoxUpdateDesc.TabIndex = 7;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(15, 65);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(60, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Description";
            // 
            // textBoxUpdateName
            // 
            this.textBoxUpdateName.Location = new System.Drawing.Point(143, 30);
            this.textBoxUpdateName.Name = "textBoxUpdateName";
            this.textBoxUpdateName.Size = new System.Drawing.Size(239, 20);
            this.textBoxUpdateName.TabIndex = 6;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(140, 14);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(75, 13);
            this.label3.TabIndex = 5;
            this.label3.Text = "Product Name";
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.textBoxUpdateID);
            this.panel1.Controls.Add(this.textBoxUpdateName);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.label3);
            this.panel1.Controls.Add(this.buttonSave);
            this.panel1.Controls.Add(this.textBoxUpdateDesc);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Location = new System.Drawing.Point(12, 144);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(483, 115);
            this.panel1.TabIndex = 7;
            // 
            // panel2
            // 
            this.panel2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel2.Controls.Add(this.textBoxDeleteId);
            this.panel2.Controls.Add(this.label4);
            this.panel2.Controls.Add(this.buttonDelete);
            this.panel2.Location = new System.Drawing.Point(12, 277);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(483, 67);
            this.panel2.TabIndex = 8;
            // 
            // textBoxDeleteId
            // 
            this.textBoxDeleteId.Location = new System.Drawing.Point(18, 29);
            this.textBoxDeleteId.Name = "textBoxDeleteId";
            this.textBoxDeleteId.Size = new System.Drawing.Size(100, 20);
            this.textBoxDeleteId.TabIndex = 9;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(15, 14);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(58, 13);
            this.label4.TabIndex = 0;
            this.label4.Text = "Product ID";
            // 
            // buttonDelete
            // 
            this.buttonDelete.Location = new System.Drawing.Point(394, 27);
            this.buttonDelete.Name = "buttonDelete";
            this.buttonDelete.Size = new System.Drawing.Size(75, 23);
            this.buttonDelete.TabIndex = 10;
            this.buttonDelete.Text = "&Delete";
            this.buttonDelete.UseVisualStyleBackColor = true;
            this.buttonDelete.Click += new System.EventHandler(this.buttonDelete_Click);
            // 
            // panel3
            // 
            this.panel3.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel3.Controls.Add(this.textBoxInsertID);
            this.panel3.Controls.Add(this.textBoxInsertName);
            this.panel3.Controls.Add(this.label5);
            this.panel3.Controls.Add(this.label6);
            this.panel3.Controls.Add(this.buttonInsert);
            this.panel3.Controls.Add(this.textBoxInsertDesc);
            this.panel3.Controls.Add(this.label7);
            this.panel3.Location = new System.Drawing.Point(12, 12);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(483, 115);
            this.panel3.TabIndex = 9;
            // 
            // textBoxInsertID
            // 
            this.textBoxInsertID.Location = new System.Drawing.Point(18, 30);
            this.textBoxInsertID.Name = "textBoxInsertID";
            this.textBoxInsertID.Size = new System.Drawing.Size(100, 20);
            this.textBoxInsertID.TabIndex = 1;
            // 
            // textBoxInsertName
            // 
            this.textBoxInsertName.Location = new System.Drawing.Point(143, 30);
            this.textBoxInsertName.Name = "textBoxInsertName";
            this.textBoxInsertName.Size = new System.Drawing.Size(239, 20);
            this.textBoxInsertName.TabIndex = 2;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(15, 14);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(58, 13);
            this.label5.TabIndex = 0;
            this.label5.Text = "Product ID";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(140, 14);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(75, 13);
            this.label6.TabIndex = 5;
            this.label6.Text = "Product Name";
            // 
            // buttonInsert
            // 
            this.buttonInsert.Location = new System.Drawing.Point(394, 79);
            this.buttonInsert.Name = "buttonInsert";
            this.buttonInsert.Size = new System.Drawing.Size(75, 23);
            this.buttonInsert.TabIndex = 4;
            this.buttonInsert.Text = "&Insert";
            this.buttonInsert.UseVisualStyleBackColor = true;
            this.buttonInsert.Click += new System.EventHandler(this.buttonInsert_Click);
            // 
            // textBoxInsertDesc
            // 
            this.textBoxInsertDesc.Location = new System.Drawing.Point(18, 81);
            this.textBoxInsertDesc.Name = "textBoxInsertDesc";
            this.textBoxInsertDesc.Size = new System.Drawing.Size(364, 20);
            this.textBoxInsertDesc.TabIndex = 3;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(15, 65);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(60, 13);
            this.label7.TabIndex = 3;
            this.label7.Text = "Description";
            // 
            // Product
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(509, 368);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.Name = "Product";
            this.Text = "Products";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxUpdateID;
        private System.Windows.Forms.Button buttonSave;
        private System.Windows.Forms.TextBox textBoxUpdateDesc;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBoxUpdateName;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.TextBox textBoxDeleteId;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button buttonDelete;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.TextBox textBoxInsertID;
        private System.Windows.Forms.TextBox textBoxInsertName;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Button buttonInsert;
        private System.Windows.Forms.TextBox textBoxInsertDesc;
        private System.Windows.Forms.Label label7;
    }
}

