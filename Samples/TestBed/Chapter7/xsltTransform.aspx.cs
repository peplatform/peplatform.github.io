namespace TestBed.Chapter7
{
	using System;
	using System.Collections;
	using System.ComponentModel;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.SessionState;
	using System.Web.UI;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
    using XsltTransformation;
    using XsltTransformation.ExternalObjects;

	/// <summary>
	///		Summary description for xsltTransform.
	/// </summary>
	public class xsltTransform : System.Web.UI.Page
	{
		public xsltTransform()
		{
			Page.Init += new System.EventHandler(Page_Init);
		}

        public void Page_Load(object sender, System.EventArgs e) {
	        string xmlPath = Server.MapPath("Listing7.1.xml");
            string xslPath = Server.MapPath("xsltExtension.xsl");
            XsltDateTime xsltExtObj = new XsltDateTime();
            Hashtable xsltParams = new Hashtable();
            Hashtable xsltObjects = new Hashtable();

            xsltParams.Add("golferName","Heedy");
            xsltObjects.Add("urn:xsltExtension-DateTime",xsltExtObj);

            string xsl = XsltTransform.TransformXml(xmlPath,xslPath,
                                                    xsltParams,xsltObjects);
	        Response.Write(xsl);
        }

		protected void Page_Init(object sender, EventArgs e)
		{
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
        private void InitializeComponent() {    
            this.Load += new System.EventHandler(this.Page_Load);

        }
		#endregion
	}
}
