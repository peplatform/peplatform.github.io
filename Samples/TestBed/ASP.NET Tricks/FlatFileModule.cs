namespace FlatFile.Converter 
{
	using System;
	using System.Xml;
	using System.IO;
	using System.Text;

	/// <summary>
	///		CSV to XML Converter
	/// </summary>
	public class PartsCSVToXmlVB 
	{
		string _csvPath;
		XmlTextWriter writer;
		int counter = 0;
		public PartsCSVToXmlVB(string csvPath,string xmlPath) 
		{
			_csvPath = csvPath;
			writer = new XmlTextWriter(xmlPath,Encoding.UTF8);
		}
		public bool Convert() 
		{
			FileStream fs = null;
			StreamReader reader = null;
			string csvLine;
			try 
			{
				writer.WriteStartDocument();
				writer.WriteStartElement("supplies");
				fs = new FileStream(_csvPath,FileMode.Open,
					FileAccess.Read);
				reader = new StreamReader(fs);
				while ((csvLine = reader.ReadLine()) != null) 
				{
					string[] tokens = csvLine.Split(new char[]{','});
					counter++;   
					GenerateXml(tokens);
				}
				writer.WriteEndElement(); //Close supplies element
				return true;
			}
			catch 
			{
				return false;
			}
			finally 
			{
				if (fs != null) 
				{
					fs.Close();
				}
				if (reader != null) 
				{
					reader.Close();
				}
				if (writer != null) 
				{
					writer.Close();
				}
			}
		}
		private void GenerateXml(string[] tokens) 
		{
			if (tokens[0] != null) 
			{
				writer.WriteStartElement("item");
				writer.WriteAttributeString("supplier",counter.ToString());
				writer.WriteStartElement("description");
				writer.WriteString(tokens[0].ToString());
				writer.WriteEndElement();
				writer.WriteStartElement("partID");
				writer.WriteString(tokens[1].ToString());
				writer.WriteEndElement();
				writer.WriteStartElement("numberInStock");
				writer.WriteString(tokens[2].ToString());
				writer.WriteEndElement();
				writer.WriteStartElement("numberOnOrder");
				writer.WriteString(tokens[3].ToString());
				writer.WriteEndElement();
				writer.WriteStartElement("deliveryDate");
				writer.WriteString(tokens[4].ToString());
				writer.WriteEndElement();
				writer.WriteStartElement("supplier");
				writer.WriteStartElement("street");
				writer.WriteString(tokens[5].ToString());
				writer.WriteEndElement();
				writer.WriteStartElement("company");
				writer.WriteString(tokens[6].ToString());
				writer.WriteEndElement();
				writer.WriteStartElement("phone");
				writer.WriteString(tokens[7].ToString());
				writer.WriteEndElement();
				writer.WriteEndElement(); //supplier
				writer.WriteStartElement("orderedBy");
				writer.WriteString(tokens[8].ToString());
				writer.WriteEndElement();
				writer.WriteEndElement(); //item
			}
		}
	}
}
