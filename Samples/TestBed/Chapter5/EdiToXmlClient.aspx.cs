namespace EDI.Client {
	using System;
	using System.ComponentModel;
	using System.Drawing;
	using System.Web;
	using System.Web.UI;
	using System.Xml;
	using EDI.Converter;

	/// <summary>
	///		Summary description for EdiToXml.
	/// </summary>
	public class EdiToXmlClient : System.Web.UI.Page
	{
		public EdiToXmlClient() {
			Page.Init += new System.EventHandler(Page_Init);
		}

		protected void Page_Load(object sender, System.EventArgs e) {
			string ediPath = Server.MapPath("ediModule.edi");
			string xmlPath = Server.MapPath("/testbed/chapter5") + "\\" + "EDI.xml";

			EdiToXml converter = new EdiToXml(ediPath,xmlPath);
			if (converter.Convert()) {
				Response.ContentType = "text/xml";
				XmlDocument doc = new XmlDocument();
				doc.Load(xmlPath);
				doc.Save(Response.Output);
			} else {
				Response.Write("Creation of the XML document failed.");
			}
		}

		protected void Page_Init(object sender, EventArgs e) {
			//
			// CODEGEN: This call is required by the ASP.NET Windows Form Designer.
			//
			InitializeComponent();
		}

		#region Web Form Designer generated code
		/// <summary>
		///	Required method for Designer support - do not modify
		///	the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion
	}
}
