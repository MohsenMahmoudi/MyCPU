using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MyCPUAssembler
{
    public partial class Form1 : Form
    {
        Dictionary<string, int> addressDic;
        Dictionary<int, int> variablesValue;
        

        public Form1()
        {
            InitializeComponent();

        }



        private void button1_Click(object sender, EventArgs e)
        {
            openFileDialog.ShowDialog();
            try
            {
                AsmCodeRTB.LoadFile(openFileDialog.FileName, RichTextBoxStreamType.PlainText);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error!\n" + ex.Message);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            int lastAssignedAddress = 255;

            string[] instructions = AsmCodeRTB.Text.Split('\n');
            int memBlockIndex = 0;
            string output = "WIDTH=8;\nDEPTH = 256;\nADDRESS_RADIX = UNS;\nDATA_RADIX = UNS;\nCONTENT BEGIN\n";

            addressDic = new Dictionary<string, int>();
            variablesValue = new Dictionary<int, int>();

            foreach (string inst in instructions)
            {
                if (inst == "")
                    continue;

                string[] parts = inst.Split(' ');
                string opCode = parts[0];
                string binCode = "";
                string address = "";
                switch (opCode.ToLower())
                {
                    case "define":
                        addressDic.Add(parts[1], lastAssignedAddress);
                        variablesValue.Add(lastAssignedAddress--, Convert.ToInt32(parts[2]));
                        continue;
                    case "ld_input":
                        binCode += "0000";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "00";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "01";
                        else if (parts[1].TrimEnd('\t').ToLower() == "c")
                            binCode += "10";
                        else if (parts[1].TrimEnd('\t').ToLower() == "d")
                            binCode += "11";
                        binCode += "00";
                        break;
                    case "ld_sram":
                        binCode += "0001";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "00";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "01";
                        else if (parts[1].TrimEnd('\t').ToLower() == "c")
                            binCode += "10";
                        else if (parts[1].TrimEnd('\t').ToLower() == "d")
                            binCode += "11";
                        binCode += "00";
                        address = addressDic[parts[2]].ToString();
                        break;
                    case "ldoutput":
                        binCode += "00100000";
                        break;
                    case "add":
                        binCode += "01" + "000";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "sub":
                        binCode += "01" + "001";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "in1":
                        binCode += "01" + "010";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "in2":
                        binCode += "01" + "011";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "and":
                        binCode += "01" + "100";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "or":
                        binCode += "01" + "101";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "xor":
                        binCode += "01" + "110";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "shl":
                        binCode += "01" + "111";
                        if (parts[1].TrimEnd('\t').ToLower() == "a")
                            binCode += "0";
                        else if (parts[1].TrimEnd('\t').ToLower() == "b")
                            binCode += "1";

                        if (parts[2].TrimEnd('\t').ToLower() == "c")
                            binCode += "0";
                        else if (parts[2].TrimEnd('\t').ToLower() == "d")
                            binCode += "1";

                        if (parts.Count() == 4 && parts[3].TrimEnd('\t').ToLower() == "shl")
                            binCode += "1";
                        else
                            binCode += "0";
                        break;
                    case "jmp":
                        binCode += "100";
                        if (parts[1].TrimEnd('\t').ToLower() == "dir")
                            binCode += "1";
                        else if (parts[1].TrimEnd('\t').ToLower() == "ind")
                            binCode += "0";

                        address = parts[2];
                        binCode += "0000";
                        break;
                    case "jz":
                        binCode += "101";
                        if (parts[1].TrimEnd('\t').ToLower() == "dir")
                            binCode += "1";
                        else if (parts[1].TrimEnd('\t').ToLower() == "ind")
                            binCode += "0";
                        binCode += "0000";
                        address = parts[2];
                        break;
                }
                output += "\t" + memBlockIndex++ + "\t:\t" + FromBinaryString(binCode) + ";\n";
                if (address != "")
                {
                    output += "\t" + memBlockIndex++ + "\t:\t" + address.Trim() + ";\n";
                    address = "";
                }
            }

            if (memBlockIndex < lastAssignedAddress)
                output += "\t[" + memBlockIndex + ".." + lastAssignedAddress + "]\t:\t0;\n";


            foreach (int tmp in variablesValue.Keys.Reverse())
            {
                output += "\t" + tmp + "\t:\t" + variablesValue[tmp] + ";\n";
            }

            output += "END;";
            AsmCodeRTB.Text = output;
        }


        public static int FromBinaryString(string binary)
        {
            if (binary == null)
                throw new ArgumentNullException();
            if (!binary.All(c => c == '0' || c == '1'))
                throw new InvalidOperationException();

            int result = 0;
            foreach (var c in binary)
            {
                result <<= 1;
                result += (c - '0');
            }
            return result;
        }
    }
}
