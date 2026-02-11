namespace XmlParsers.Validation
{
	using System;
	using System.Xml;
	using System.Xml.Schema;
	using System.IO;
	using System.Text;
	using System.Net;

	/// <summary>
	///		The Validator class encapsulates various XML validation functionality
	/// </summary>
	public class Validator {
		bool _valid;
		bool _logError;
		string _logFile;
		string _xmlFilePath;
		XmlTextReader xmlReader = null;
		XmlValidatingReader vReader = null;

		public bool Validate(string xmlFilePath,XmlSchemaCollection schemaCol,
			                 bool logError,string logFile) {
			_logError = logError;
			_logFile = logFile;
			_xmlFilePath = xmlFilePath;
			_valid = true;
			try {
				
				xmlReader = new XmlTextReader(_xmlFilePath);
				vReader = new XmlValidatingReader(xmlReader);
				if (schemaCol != null) {
					vReader.Schemas.Add(schemaCol);
				}
				vReader.ValidationType = ValidationType.Auto;

				/* Provide your own resolver if implementing a custom
				 * caching mechnism
				 * XmlUrlResolver resolver = new XmlUrlResolver();
				 * vReader.XmlResolver = resolver;
				*/				

				vReader.ValidationEventHandler  += 
					new ValidationEventHandler(this.ValidationCallBack);
				// Parse through XML
				while (vReader.Read()){}
			} catch {
				_valid = false;
			} finally {  //Close our readers
				if (xmlReader.ReadState != ReadState.Closed) {
					xmlReader.Close();
				}
				if (vReader.ReadState != ReadState.Closed) {
					vReader.Close();
				}
			}
			return _valid;
		}

		private void ValidationCallBack(object sender, ValidationEventArgs args)	{
			_valid = false;  //hit callback so document has a problem
			DateTime today = DateTime.Now;
			StreamWriter writer = null;
			try {			
				if (_logError) {
					writer = new StreamWriter(_logFile,true,Encoding.ASCII);
					writer.WriteLine("Validation error in: " + _xmlFilePath);
					writer.WriteLine();
					writer.WriteLine(args.Message + " " + today.ToString());
					writer.WriteLine();
					if (xmlReader.LineNumber > 0) {
						writer.WriteLine("Line: "+ xmlReader.LineNumber + 
                                         " Position: " + xmlReader.LinePosition);
					}
					writer.WriteLine();
				}
				writer.Flush();
			}
			catch {}
			finally {
				if (writer != null) {
					writer.Close();
				}
			}
		}
	} 
}
