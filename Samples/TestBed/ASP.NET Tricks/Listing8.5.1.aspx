<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Schema" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<script language="C#" runat="server">
     private void Page_Load(Object sender, EventArgs e) {
         bool status;
         string xmlFilePath = Server.MapPath("golfersNotValid(XSD).xml");
         string logFile = Server.MapPath("validationErrors.log");
         Validator objValidate = new Validator(xmlFilePath,logFile,true);
         status = objValidate.Validate();
         if (status) {
			Response.Write("Validation of golfersNotValid(XSD).xml was SUCCESSFUL!");
			//Call method to process XML document
		 } else {
			Response.Write("Validation of golfersNotValid(XSD).xml failed! Check the " +
					        "log file for information on the failure.");
		 }
     }
     public class Validator {
		bool _valid = true;
		bool _logError = true;
		string _logFile = "";
		string _xmlFilePath = "";
		XmlTextReader xmlReader = null;
		XmlValidatingReader vReader = null;
		
		public Validator(string xmlFilePath,string logFile,bool logError) {
			_xmlFilePath = xmlFilePath;
			_logFile = logFile;
			_logError = logError;
		}		
		
		public bool Validate() {
			try {
				xmlReader = new XmlTextReader(_xmlFilePath);
				vReader = new XmlValidatingReader(xmlReader);
				vReader.ValidationType = ValidationType.Schema;
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
		} //Validate()

		private void ValidationCallBack(object sender, ValidationEventArgs args) {
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
		} //ValidationCallBack()
	} //Validator
</script>
