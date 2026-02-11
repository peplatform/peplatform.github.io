namespace TestBed {
	using System;
	using System.ComponentModel;
	using System.Drawing;
	using System.Web;
	using System.Web.UI;
	using System.Xml;
	using System.Xml.Schema;
	using XmlParsers.Validation;

	/// <summary>
	///		Summary description for ValidateSchema.
	/// </summary>
	public class ValidateSchema : System.Web.UI.Page
	{
		public ValidateSchema()	{
			Page.Init += new System.EventHandler(Page_Init);
		}

		protected void Page_Load(object sender, System.EventArgs e)	{
			string xmlFilePath = Server.MapPath("golfersNotValid(XSD).xml");
			string logFile = Server.MapPath("validationErrors.log");

			XmlSchemaCollection schemaCol = new XmlSchemaCollection();
			schemaCol.Add("http://www.golfExample.com",Server.MapPath("golfers.xsd"));
			Validator validator = new Validator();
			bool status = validator.Validate(xmlFilePath,schemaCol,true,logFile);
			if (status) {
				Response.Write("Validation of golfersNotValid(XSD).xml was SUCCESSFUL!");
				//Call method to process XML document
			} else {
				Response.Write("Validation of golfersNotValid(XSD).xml failed! Check the " +
					           "log file for information on the failure.");
			}
		}

		protected void Page_Init(object sender, EventArgs e){
			InitializeComponent();
		}
		private void InitializeComponent() {
			this.Load += new System.EventHandler(this.Page_Load);

		}
	}
}
