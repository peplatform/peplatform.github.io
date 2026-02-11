namespace TestBed.Chapter7
{
	using System;
	using System.Collections;
	using System.ComponentModel;
	using System.Drawing;
	using System.Web;
	using System.Web.UI;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.Xml;
	using System.Xml.XPath;
	using System.Xml.Xsl;
	using System.IO;
	using System.Text;
    using XsltTransformation.ExternalObjects;

	/// <summary>
	///		Summary description for test.
	/// </summary>
	public class XsltExtension : System.Web.UI.Page	
	{
		protected System.Web.UI.WebControls.Button btnSubmit;
		protected System.Web.UI.WebControls.Panel pnlSelectGolfer;
		protected System.Web.UI.WebControls.Panel pnlTransformation;
		protected System.Web.UI.WebControls.DropDownList ddGolferName;
		protected System.Web.UI.WebControls.LinkButton lnkBack;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divTransformation;
		private string xmlPath;
	
		public XsltExtension() 
		{
			Page.Init += new System.EventHandler(Page_Init);
		}

		protected void Page_Init(object sender, EventArgs e) 
		{
			xmlPath = Server.MapPath("listing7.1.xml");
			InitializeComponent();
		}

		#region Web Form Designer generated code
		/// <summary>
		///	Required method for Designer support - do not modify
		///	the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.lnkBack.Click += new System.EventHandler(this.lnkBack_Click);
			this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

protected void btnSubmit_Click(object sender, System.EventArgs e) {
    
	string xslPath = Server.MapPath("xsltExtension.xsl"); 
    XsltDateTime xsltExtObj = new XsltDateTime();
	XmlTextReader xmlReader = null;
	StringBuilder sb = new StringBuilder();
	StringWriter sw = new StringWriter(sb);
    
	try {
		xmlReader = new XmlTextReader(xmlPath);
    
		//Instantiate the XPathDocument Class
		XPathDocument doc = new XPathDocument(xmlReader);
    
		//Instantiate the XslTransform Classes
		XslTransform transform = new XslTransform();
		transform.Load(xslPath);
		//Add Parameters
		XsltArgumentList args = new XsltArgumentList();
		args.AddParam("golferName","",this.ddGolferName.SelectedItem.Value);
        args.AddExtensionObject("urn:xsltExtension-DateTime",xsltExtObj);
		//Call Transform() method
		transform.Transform(doc, args, sw);
		//Hide Panels
		this.pnlSelectGolfer.Visible = false;
		this.pnlTransformation.Visible = true;
		this.divTransformation.InnerHtml = sb.ToString();
	}
	catch (Exception excp) {
		Response.Write(excp.ToString());
	}
	finally {
		xmlReader.Close();
		sw.Close();
	}
}

        private void Page_Load(object sender, System.EventArgs e) {
	        if (!Page.IsPostBack) {
		        FillDropDown("firstName");
	        }
        }

		        protected void lnkBack_Click(object sender, System.EventArgs e)
		        {
			        this.pnlSelectGolfer.Visible = true;
			        this.pnlTransformation.Visible = false;
			        FillDropDown("firstName");
		        }
        private void FillDropDown(string element) 
        {
	        string name = "";
	        this.ddGolferName.Items.Clear();
	        System.Xml.XmlTextReader reader = new XmlTextReader(xmlPath);
	        object firstNameObj = reader.NameTable.Add("firstName");
	        while (reader.Read()) 
	        {
		        if (reader.Name.Equals(firstNameObj)) 
		        {
			        name = reader.ReadString();
			        ListItem item = new ListItem(name,name);
			        this.ddGolferName.Items.Add(item);
		        }
	        }
	        reader.Close();
        }
	}
}
