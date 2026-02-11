namespace TestBed
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
	using XmlParsers.Sax;
	using XmlParsers.Sax.Handlers;

    /// <summary>
    ///    Summary description for SAXTest.
    /// </summary>
    public class SAXTest : System.Web.UI.Page
    {
	public SAXTest()
	{
	    Page.Init += new System.EventHandler(Page_Init);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               StartSAX();
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP+ Windows Form Designer.
            //
            InitializeComponent();
        }

        private void InitializeComponent() {
			this.Load += new System.EventHandler (this.Page_Load);
        }
	public void StartSAX() {
		Response.Write("<b>Starting SAX Parsing....</b><p />");
		SaxParser parser = new SaxParser();
		ContentHandler handler = new ContentHandler(Request,Response);
		ErrorHandler errorHandler = new ErrorHandler(Request,Response);
		parser.setContentHandler(handler);
		parser.setErrorHandler(errorHandler);
		try {
			parser.parse(Server.MapPath("SAXTest.xml"));
		}
		catch (Exception exp) {
			Response.Write(exp.ToString());
		}
	}
    }
}
