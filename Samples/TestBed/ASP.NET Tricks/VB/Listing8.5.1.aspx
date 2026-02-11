<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Schema" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<script language="VB" runat="server">
     private sub Page_Load(sender as Object, e as EventArgs) 
         Dim status as boolean
         Dim xmlFilePath as string = Server.MapPath("golfersNotValid(XSD).xml")
         Dim logFile as string = Server.MapPath("validationErrors.log")
         Dim objValidate as ValidatorVB = new ValidatorVB(xmlFilePath,logFile,true)
         status = objValidate.Validate()
         if (status) then
			Response.Write("Validation of golfersNotValid(XSD).xml was SUCCESSFUL!")
			'Call method to process XML document
		 else 
			Response.Write("Validation of golfersNotValid(XSD).xml failed! Check the " & _
					        "log file for information on the failure.")
		 end if
     end sub
     public class ValidatorVB 
		Dim _valid as boolean = true
		Dim _logError as boolean = true
		Dim _logFile as string = ""
		Dim _xmlFilePath as string = ""
		Dim xmlReader as XmlTextReader
		Dim vReader as XmlValidatingReader
		Dim validHandler as ValidationEventHandler 


		public sub New(xmlFilePath as string,logFile as string,logError as boolean) 
			_xmlFilePath = xmlFilePath
			_logFile = logFile
			_logError = logError
		end sub
		
		public function Validate() as boolean
			try 
				xmlReader = new XmlTextReader(_xmlFilePath)
				vReader = new XmlValidatingReader(xmlReader)
				vReader.ValidationType = ValidationType.Schema
				validHandler = new ValidationEventHandler(addressof ValidationCallBack)
				AddHandler vReader.ValidationEventHandler,validHandler
				'Parse through XML
				while (vReader.Read())
				end while
			catch 
				_valid = false
			finally   'Close our readers
				if (xmlReader.ReadState <> ReadState.Closed) then
					xmlReader.Close()
				end if
				if (vReader.ReadState <> ReadState.Closed) 
					vReader.Close()
				end if
			end try
			return _valid
		end function 'Validate()

		private sub ValidationCallBack(sender as object, args as ValidationEventArgs) 
			_valid = false  'hit callback so document has a problem

			Dim today as DateTime = DateTime.Now
			Dim writer as StreamWriter
			try 			
				if (_logError) then
					writer = new StreamWriter(_logFile,true,Encoding.ASCII)
					writer.WriteLine("Validation error in: " & _xmlFilePath)
					writer.WriteLine()
					writer.WriteLine(args.Message & " " & today.ToString())
					writer.WriteLine()
					if (xmlReader.LineNumber > 0) then
						writer.WriteLine("Line: " & xmlReader.LineNumber & _
                                         " Position: " & xmlReader.LinePosition)
					end if
					writer.WriteLine()
				end if
				writer.Flush()
			catch 
			finally 
				if (NOT writer Is Nothing) then
					writer.Close()
				end if
			end try
		end sub  'ValidationCallBack()
	end class  'ValidatorVB
</script>
