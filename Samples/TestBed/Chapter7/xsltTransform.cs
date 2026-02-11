namespace XsltTransformation {

	using System;
    using System.Xml;
    using System.Xml.XPath;
    using System.Xml.Xsl;
    using System.Collections;
    using System.IO;
    using System.Text;

	/// <summary>
	///		A generic XSL Transformation Class for use in ASP.NET pages
	/// </summary>
	public class XsltTransform {
 
		public static string TransformXml(string xmlPath,string xsltPath,
                             Hashtable xsltParams,Hashtable xsltObjects) {

            StringBuilder sb = new StringBuilder();
            StringWriter sw = new StringWriter(sb);
            try {
                XPathDocument doc = new XPathDocument(xmlPath);
                XsltArgumentList args = new XsltArgumentList();
                XslTransform xslDoc = new XslTransform();
                xslDoc.Load(xsltPath);
                
                //Fill XsltArgumentList if necessary
                if (xsltParams != null) {
                    IDictionaryEnumerator pEnumerator = xsltParams.GetEnumerator();
                    while (pEnumerator.MoveNext()) {
                        args.AddParam(pEnumerator.Key.ToString(),"",pEnumerator.Value);
                    }
                }
                if (xsltObjects != null) {
                    IDictionaryEnumerator pEnumerator = xsltObjects.GetEnumerator();
                    while (pEnumerator.MoveNext()) {
                        args.AddExtensionObject(pEnumerator.Key.ToString(),pEnumerator.Value);
                    }
                }
                xslDoc.Transform(doc,args,sw);
                return sb.ToString();
            } 
            catch (Exception exp) {
                return exp.ToString();
            } 
            finally {
                sw.Close();
            }
        }
	}
}
