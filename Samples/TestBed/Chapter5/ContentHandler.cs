namespace XmlParsers.Sax.Handlers {
	using System;
	using System.Web;
	using XmlParsers.Sax.Helpers;	

    public class ContentHandler:IContentHandler {
		HttpContext context = null;
		int counter = 0;
		string name;
		Locator locator;

		public void setDocumentLocator(Locator locator) {
			this.locator = locator;
		}

        public ContentHandler (HttpRequest aspxRequest, HttpResponse aspxResponse) {
			context = new HttpContext(aspxRequest,aspxResponse);
        }
        public void startDocument() {
            context.Response.Write("<b>Start of Document...</b><p />");
            context.Response.Write("<table bgcolor=\"#efefef\">");
            context.Response.Write("<tr><td style=\"font-family:arial\">");
        }

        public void endDocument() {
            context.Response.Write("</td></tr></table>");
            context.Response.Write("<p /><b>...End of Document</b>");
        }

        public void processingInstruction(string target, String data) {
            context.Response.Write(locator.getLineNumber() + ":" + "<b><font color=\"#02027a\">" +
				                   "&lt;?" + target + " " + data +
								   "?&gt;</font></b>");
        }

        public void startPrefixMapping(string prefix, String uri) {
            //context.Response.Write("Mapping starts for prefix " + prefix +
            //    " mapped to URI " + uri + "<br>");
        }

        public void endPrefixMapping(string prefix) {
            //context.Response.Write("Mapping ends for prefix " + prefix + "<br>");
        }

        public void startElement(string namespaceURI, string localName,
                                       string rawName, Attributes atts) {
            counter++;
            name = rawName;
            context.Response.Write("<br>" + locator.getLineNumber() + ":" + Indent(counter) + "&lt;<b><font color=\"#ff0000\">" +
                      rawName + "</font></b>");
            for (int i=0; i<atts.getLength(); i++) {
                context.Response.Write(" <i>" + atts.getQName(i) + "</i>" +
                    "=\"" + atts.getValue(i) + "\" ");
            }
            context.Response.Write("&gt;");

            //Access namespaceURI here if desired

			/*if (namespaceURI != "") {
                context.Response.Write(" in namespace " + namespaceURI +
                    " (" + rawName + ")<br>");
            } else {
                context.Response.Write("has no associated namespace<br>");
            }*/
        }

        public void endElement(string namespaceURI, string localName,string rawName) {
			if (name != rawName) context.Response.Write("<br>" + 
							     locator.getLineNumber() + ":" + Indent(counter));
            context.Response.Write("&lt;/<b><font color=\"#ff0000\">" + rawName +
                      "</font></b>&gt;");
            counter--;
        }

        public void characters(char[] ch, int start, int end) {
            string s = new string(ch, start, end);
            context.Response.Write(s);
        }

        public void ignorableWhitespace(char[] ch, int start, int end) {

            string s = new string(ch, start, end);
            //context.Response.Write("ignorableWhitespace: [" + s + "]<br>");
        }

        public void skippedEntity(string name)  {
            context.Response.Write("Skipping entity " + name + "<br>");
        }

        public string Indent(int num) {
            string indents = "";
            for (int i=0;i<num;i++) {
                indents += "&nbsp;&nbsp;&nbsp;&nbsp;";
            }
            return indents;
        }
		
		public void Write(string val) {
			context.Response.Write(val);
		}
    }
}
