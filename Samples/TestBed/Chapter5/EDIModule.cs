namespace EDI.Converter {
	using System;
	using System.Xml;
	using System.IO;
	using System.Text;

	/// <summary>
	///		EDI to XML Converter
	/// </summary>
	public class EdiToXml {
		string _ediPath;
		XmlTextWriter writer;
		public EdiToXml(string ediPath,string xmlPath) {
			_ediPath = ediPath;
			writer = new XmlTextWriter(xmlPath,Encoding.UTF8);
		}
		public bool Convert() {
			FileStream fs = null;
			StreamReader reader = null;
			string ediLine;
			try {
				writer.WriteStartDocument();
				writer.WriteStartElement("root");
				fs = new FileStream(_ediPath,FileMode.Open,FileAccess.Read);
				reader = new StreamReader(fs);
				while ((ediLine = reader.ReadLine()) != null) {
					string[] tokens = ediLine.Split(new char[]{'*'});
					GenerateXml(tokens);
				}
				writer.WriteEndElement(); //Close root element
				return true;
			}
			catch {
				return false;
			}
			finally {
				if (fs != null) {
					fs.Close();
				}
				if (reader != null) {
					reader.Close();
				}
				if (writer != null) {
					writer.Close();
				}
			}

		}
		private void GenerateXml(string[] tokens) {
			if (tokens[0] != null) {
				switch (tokens[0].ToString().ToUpper()) {
					case "BEG":
						writer.WriteStartElement("header");
						writer.WriteStartElement("poNumber");
						writer.WriteString(Clean(tokens[1]));
						writer.WriteEndElement();
						writer.WriteStartElement("poDate");
						writer.WriteString(Clean(tokens[2]));
						writer.WriteEndElement();
						break;
					case "DTM":
						writer.WriteStartElement("shipDate");
						writer.WriteString(Clean(tokens[2]));
						writer.WriteEndElement();
						writer.WriteEndElement(); //header
						break;
					case "PO1":
						writer.WriteStartElement("detail");
						writer.WriteStartElement("lineNum");
						writer.WriteString(Clean(tokens[1]));
						writer.WriteEndElement();
						writer.WriteStartElement("partNum");
						writer.WriteString(Clean(tokens[2]));
						writer.WriteEndElement();
						break;
					case "NTE":
						writer.WriteStartElement("desc");
						writer.WriteString(Clean(tokens[1]));
						writer.WriteEndElement();
						writer.WriteEndElement(); //detail
						break;
					case "CTT":
						writer.WriteStartElement("summary");
						writer.WriteStartElement("lineCount");
						writer.WriteString(Clean(tokens[1]));
						writer.WriteEndElement();
						writer.WriteStartElement("totalQuantity");
						writer.WriteString(Clean(tokens[2]));
						writer.WriteEndElement();	
						writer.WriteEndElement(); //summary
						break;
				}
			}

		}
		private string Clean(string token) {
			string newToken = token.Replace("~","");
			return newToken;
		}
	}
}
