namespace XmlParsers.Sax.Handlers {
	using XmlParsers.Sax.Helpers;	
	using System.Web;
	public class ErrorHandler:IErrorHandler {
		HttpContext context = null;
		public ErrorHandler (HttpRequest aspxRequest, HttpResponse aspxResponse) {
			context = new HttpContext(aspxRequest,aspxResponse);
		}
		public void warning(SAXParseException exception){
			context.Response.Write("<p><b>Warning: " + exception.getMessage() + "</b></p>");
			context.Response.Write("<p>Line Number:" + exception.getLineNumber() + "</p>");
		}	
		public void error(SAXParseException exception){
			context.Response.Write("<p><b>Error: " + exception.getMessage() + "</b></p>");
			context.Response.Write("<p>Line Number:" + exception.getLineNumber() + "</p>");
		}
		public void fatalError(SAXParseException exception){
			context.Response.Write("<p><b>Fatal Error: " + exception.getMessage() + "</b></p>");
			context.Response.Write("<p>Line Number:" + exception.getLineNumber() + "</p>");
		}
	}
}
