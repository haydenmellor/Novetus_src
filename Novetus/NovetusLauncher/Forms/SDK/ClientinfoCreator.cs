﻿#region Usings
using System;
using System.Windows.Forms;
using System.IO;
using System.Globalization;
#endregion

namespace NovetusLauncher
{
    #region Client SDK
    public partial class ClientinfoEditor : Form
	{
        #region Private Variables
        private FileFormat.ClientInfo SelectedClientInfo = new FileFormat.ClientInfo();
		private string SelectedClientInfoPath = "";
		private bool Locked = false;
        #endregion

        #region Constructor
        public ClientinfoEditor()
		{
			InitializeComponent();
		}
        #endregion

        #region Form Events
        void CheckBox1CheckedChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.UsesPlayerName = checkBox1.Checked;
		}
		
		void CheckBox2CheckedChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.UsesID = checkBox2.Checked;
		}
		
		void TextBox1TextChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.Description = textBox1.Text;
		}
		
		void ClientinfoCreatorLoad(object sender, EventArgs e)
		{
			checkBox4.Visible = GlobalVars.AdminMode;
		}
		
		void CheckBox3CheckedChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.LegacyMode = checkBox3.Checked;
		}
		
		void TextBox2TextChanged(object sender, EventArgs e)
		{
			textBox2.Text = textBox2.Text.ToUpper(CultureInfo.InvariantCulture);
			SelectedClientInfo.ClientMD5 = textBox2.Text.ToUpper(CultureInfo.InvariantCulture);
		}
		
		void TextBox3TextChanged(object sender, EventArgs e)
		{
			textBox3.Text = textBox3.Text.ToUpper(CultureInfo.InvariantCulture);
			SelectedClientInfo.ScriptMD5 = textBox3.Text.ToUpper(CultureInfo.InvariantCulture);
		}
		
		void Button4Click(object sender, EventArgs e)
		{
			if (string.IsNullOrWhiteSpace(SelectedClientInfoPath))
			{
				FolderBrowserDialog folderBrowserDialog1 = new FolderBrowserDialog();
				if (folderBrowserDialog1.ShowDialog() == DialogResult.OK) 
				{
    				SelectedClientInfoPath = folderBrowserDialog1.SelectedPath;
				}
			}
			
			string ClientName = "";
        			
    		if (!SelectedClientInfo.LegacyMode)
        	{
        		ClientName = "\\RobloxApp_Client.exe";
        	}
        	else
        	{
        		ClientName = "\\RobloxApp.exe";
        	}
    				
    		string ClientMD5 = File.Exists(SelectedClientInfoPath + ClientName) ? SecurityFuncs.GenerateMD5(SelectedClientInfoPath + ClientName) : "";
        			
        	if (!string.IsNullOrWhiteSpace(ClientMD5))
        	{
        		textBox2.Text = ClientMD5.ToUpper(CultureInfo.InvariantCulture);
				textBox2.BackColor = System.Drawing.Color.Lime;
				SelectedClientInfo.ClientMD5 = textBox2.Text.ToUpper(CultureInfo.InvariantCulture);
        	}
        	else
        	{
        		MessageBox.Show("Cannot load '" + ClientName.Trim('/') + "'. Please make sure you selected the directory","Novetus Launcher - Error while generating MD5 for client", MessageBoxButtons.OK, MessageBoxIcon.Error);
        	}
					
        	string ClientScriptMD5 = File.Exists(SelectedClientInfoPath + "\\content\\scripts\\" + GlobalPaths.ScriptName + ".lua") ? SecurityFuncs.GenerateMD5(SelectedClientInfoPath + "\\content\\scripts\\" + GlobalPaths.ScriptName + ".lua") : "";
        			
			if (!string.IsNullOrWhiteSpace(ClientScriptMD5))
        	{
        		textBox3.Text = ClientScriptMD5.ToUpper(CultureInfo.InvariantCulture);
				textBox3.BackColor = System.Drawing.Color.Lime;
				SelectedClientInfo.ScriptMD5 = textBox3.Text.ToUpper(CultureInfo.InvariantCulture);
			}
			else
        	{
        		MessageBox.Show("Cannot load '" + GlobalPaths.ScriptName + ".lua'. Please make sure you selected the directory","Novetus Launcher - Error while generating MD5 for script", MessageBoxButtons.OK, MessageBoxIcon.Error);
        	}
			
			MessageBox.Show("MD5s generated.","Novetus Launcher - Novetus Client SDK", MessageBoxButtons.OK, MessageBoxIcon.Information);
		}
		
		void CheckBox4CheckedChanged(object sender, EventArgs e)
		{
			if (checkBox4.Checked == true)
			{
				Locked = true;
			}
			else if (checkBox4.Checked == false && Locked == true)
			{
				Locked = true;
			}
		}
		
		void CheckBox6CheckedChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.Fix2007 = checkBox6.Checked;	
		}
		
		void CheckBox7CheckedChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.AlreadyHasSecurity = checkBox7.Checked;
		}

		void checkBox5_CheckedChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.NoGraphicsOptions = checkBox5.Checked;
		}

		void NewToolStripMenuItemClick(object sender, EventArgs e)
		{
			label9.Text = "Not Loaded";
			SelectedClientInfo.UsesPlayerName = false;
			SelectedClientInfo.UsesID = false;
			SelectedClientInfo.Warning = "";
			SelectedClientInfo.LegacyMode = false;
			SelectedClientInfo.Fix2007 = false;
			SelectedClientInfo.AlreadyHasSecurity = false;
			SelectedClientInfo.NoGraphicsOptions = false;
			SelectedClientInfo.Description = "";
			SelectedClientInfo.ClientMD5 = "";
			SelectedClientInfo.ScriptMD5 = "";
			SelectedClientInfo.CommandLineArgs = "";
			Locked = false;
			SelectedClientInfoPath = "";
			checkBox1.Checked = SelectedClientInfo.UsesPlayerName;
			checkBox2.Checked = SelectedClientInfo.UsesID;
			checkBox3.Checked = SelectedClientInfo.LegacyMode;
			checkBox4.Checked = Locked;
			checkBox6.Checked = SelectedClientInfo.Fix2007;
			checkBox7.Checked = SelectedClientInfo.AlreadyHasSecurity;
			checkBox5.Checked = SelectedClientInfo.NoGraphicsOptions;
			textBox3.Text = SelectedClientInfo.ScriptMD5.ToUpper(CultureInfo.InvariantCulture);
			textBox2.Text = SelectedClientInfo.ClientMD5.ToUpper(CultureInfo.InvariantCulture);
			textBox1.Text = SelectedClientInfo.Description;
			textBox4.Text = SelectedClientInfo.CommandLineArgs;
			textBox5.Text = SelectedClientInfo.Warning;
			textBox2.BackColor = System.Drawing.SystemColors.Control;
			textBox3.BackColor = System.Drawing.SystemColors.Control;
		}
		
		void LoadToolStripMenuItemClick(object sender, EventArgs e)
		{
			bool IsVersion2 = false;

			using (var ofd = new OpenFileDialog())
			{
				ofd.Filter = "Novetus Clientinfo files (*.nov)|*.nov";
				ofd.FilterIndex = 1;
				ofd.FileName = "clientinfo.nov";
				ofd.Title = "Load clientinfo.nov";
				if (ofd.ShowDialog() == DialogResult.OK)
				{
					string file, usesplayername, usesid, warning, legacymode, clientmd5,
						scriptmd5, desc, locked, fix2007, alreadyhassecurity,
						cmdargsornogfxoptions, commandargsver2;

					using (StreamReader reader = new StreamReader(ofd.FileName))
					{
						file = reader.ReadLine();
					}

					string ConvertedLine = "";

					try
					{
						IsVersion2 = true;
						label9.Text = "v2";
						ConvertedLine = SecurityFuncs.Base64DecodeNew(file);
					}
					catch (Exception)
					{
						label9.Text = "v1";
						ConvertedLine = SecurityFuncs.Base64DecodeOld(file);
					}

					string[] result = ConvertedLine.Split('|');
					usesplayername = SecurityFuncs.Base64Decode(result[0]);
					usesid = SecurityFuncs.Base64Decode(result[1]);
					warning = SecurityFuncs.Base64Decode(result[2]);
					legacymode = SecurityFuncs.Base64Decode(result[3]);
					clientmd5 = SecurityFuncs.Base64Decode(result[4]);
					scriptmd5 = SecurityFuncs.Base64Decode(result[5]);
					desc = SecurityFuncs.Base64Decode(result[6]);
					locked = SecurityFuncs.Base64Decode(result[7]);
					fix2007 = SecurityFuncs.Base64Decode(result[8]);
					alreadyhassecurity = SecurityFuncs.Base64Decode(result[9]);
					cmdargsornogfxoptions = SecurityFuncs.Base64Decode(result[10]);
					commandargsver2 = "";
					try
					{
						if (IsVersion2)
						{
							commandargsver2 = SecurityFuncs.Base64Decode(result[11]);
						}
					}
					catch (Exception)
					{
						label9.Text = "v2 (DEV)";
						IsVersion2 = false;
					}

					if (!GlobalVars.AdminMode)
					{
						bool lockcheck = Convert.ToBoolean(locked);
						if (lockcheck)
						{
							MessageBox.Show("This client is locked and therefore it cannot be loaded.", "Novetus Launcher - Error when loading client", MessageBoxButtons.OK, MessageBoxIcon.Error);
							return;
						}
						else
						{
							Locked = lockcheck;
							checkBox4.Checked = Locked;
						}
					}
					else
					{
						Locked = Convert.ToBoolean(locked);
						checkBox4.Checked = Locked;
					}

					SelectedClientInfo.UsesPlayerName = Convert.ToBoolean(usesplayername);
					SelectedClientInfo.UsesID = Convert.ToBoolean(usesid);
					SelectedClientInfo.Warning = warning;
					SelectedClientInfo.LegacyMode = Convert.ToBoolean(legacymode);
					SelectedClientInfo.ClientMD5 = clientmd5;
					SelectedClientInfo.ScriptMD5 = scriptmd5;
					SelectedClientInfo.Description = desc;
					SelectedClientInfo.Fix2007 = Convert.ToBoolean(fix2007);
					SelectedClientInfo.AlreadyHasSecurity = Convert.ToBoolean(alreadyhassecurity);

					if (IsVersion2)
					{
						SelectedClientInfo.NoGraphicsOptions = Convert.ToBoolean(cmdargsornogfxoptions);
						SelectedClientInfo.CommandLineArgs = commandargsver2;
					}
					else
					{
						//Again, fake it.
						SelectedClientInfo.NoGraphicsOptions = false;
						SelectedClientInfo.CommandLineArgs = cmdargsornogfxoptions;
					}
				}

				SelectedClientInfoPath = Path.GetDirectoryName(ofd.FileName);
			}

			checkBox1.Checked = SelectedClientInfo.UsesPlayerName;
			checkBox2.Checked = SelectedClientInfo.UsesID;
			checkBox3.Checked = SelectedClientInfo.LegacyMode;
			checkBox6.Checked = SelectedClientInfo.Fix2007;
			checkBox7.Checked = SelectedClientInfo.AlreadyHasSecurity;
			checkBox5.Checked = SelectedClientInfo.NoGraphicsOptions;
			textBox3.Text = SelectedClientInfo.ScriptMD5.ToUpper(CultureInfo.InvariantCulture);
			textBox2.Text = SelectedClientInfo.ClientMD5.ToUpper(CultureInfo.InvariantCulture);
			textBox1.Text = SelectedClientInfo.Description;
			textBox4.Text = SelectedClientInfo.CommandLineArgs;
			textBox5.Text = SelectedClientInfo.Warning;

			textBox2.BackColor = System.Drawing.SystemColors.Control;
			textBox3.BackColor = System.Drawing.SystemColors.Control;
		}
		
		void SaveToolStripMenuItemClick(object sender, EventArgs e)
		{
			using (var sfd = new SaveFileDialog())
			{
				sfd.Filter = "Novetus Clientinfo files (*.nov)|*.nov";
				sfd.FilterIndex = 1;
				string filename = "clientinfo.nov";
				sfd.FileName = filename;
				sfd.Title = "Save " + filename;

				if (sfd.ShowDialog() == DialogResult.OK)
				{
					string[] lines = {
						SecurityFuncs.Base64Encode(SelectedClientInfo.UsesPlayerName.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.UsesID.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.Warning.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.LegacyMode.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.ClientMD5.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.ScriptMD5.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.Description.ToString()),
						SecurityFuncs.Base64Encode(Locked.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.Fix2007.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.AlreadyHasSecurity.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.NoGraphicsOptions.ToString()),
						SecurityFuncs.Base64Encode(SelectedClientInfo.CommandLineArgs.ToString())
					};
					File.WriteAllText(sfd.FileName, SecurityFuncs.Base64Encode(string.Join("|", lines)));
					SelectedClientInfoPath = Path.GetDirectoryName(sfd.FileName);
				}
			}

			label9.Text = "v2";
			textBox2.BackColor = System.Drawing.SystemColors.Control;
			textBox3.BackColor = System.Drawing.SystemColors.Control;
		}

		private void saveAsTextFileToolStripMenuItem_Click(object sender, EventArgs e)
		{
			using (var sfd = new SaveFileDialog())
			{
				sfd.Filter = "Text file (*.txt)|*.txt";
				sfd.FilterIndex = 1;
				string filename = "clientinfo.txt";
				sfd.FileName = filename;
				sfd.Title = "Save " + filename;

				if (sfd.ShowDialog() == DialogResult.OK)
				{
					string[] lines = {
						SelectedClientInfo.UsesPlayerName.ToString(),
						SelectedClientInfo.UsesID.ToString(),
						SelectedClientInfo.Warning.ToString(),
						SelectedClientInfo.LegacyMode.ToString(),
						SelectedClientInfo.ClientMD5.ToString(),
						SelectedClientInfo.ScriptMD5.ToString(),
						SelectedClientInfo.Description.ToString(),
						Locked.ToString(),
						SelectedClientInfo.Fix2007.ToString(),
						SelectedClientInfo.AlreadyHasSecurity.ToString(),
						SelectedClientInfo.NoGraphicsOptions.ToString(),
						SelectedClientInfo.CommandLineArgs.ToString()
					};
					File.WriteAllLines(sfd.FileName, lines);
					SelectedClientInfoPath = Path.GetDirectoryName(sfd.FileName);
				}
			}
		}

		void TextBox4TextChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.CommandLineArgs = textBox4.Text;		
		}
		
		void TextBox5TextChanged(object sender, EventArgs e)
		{
			SelectedClientInfo.Warning = textBox5.Text;			
		}

        private void documentationToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ClientScriptDocumentation csd = new ClientScriptDocumentation();
            csd.Show();
        }

        //tags
        private void clientToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AddClientinfoText("<client></client>");
        }

        private void serverToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AddClientinfoText("<server></server>");
        }

        private void soloToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AddClientinfoText("<solo></solo>");
        }

        private void studioToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AddClientinfoText("<studio></studio>");
        }

        private void no3dToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AddClientinfoText("<no3d></no3d>");
        }

        private void variableToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ToolStripMenuItem senderitem = (ToolStripMenuItem)sender;
            AddClientinfoText(senderitem.Text);
        }
		#endregion

		#region Functions
		private void AddClientinfoText(string text)
		{
			textBox4.Paste(text);
		}
		#endregion
	}
    #endregion
}
