using XmlParsers.Sax.Helpers;
interface IErrorHandler {
	void warning(SAXParseException exception);
	
	void error(SAXParseException exception);

	void fatalError(SAXParseException exception);
}
