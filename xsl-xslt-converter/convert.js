/*

  convert.js 1.1
  
  Windows Scripting Host file for running the xsl-xslt-converter.xslt
  style sheet.
  
  Parameters:  xsl-stylesheet-file [xslt-output-file]
  
  Author: Jonathan Marsh <jmarsh@microsoft.com>
  Copyright 2000 Microsoft Corp.
  
*/

var args = WScript.arguments;
if (args.length != 2 && args.length !=1)
  WScript.Echo("parameters are: xsl-stylesheet-file [xslt-output-file]");
else
{
  var ofs = WScript.CreateObject("Scripting.FileSystemObject");

  var stylesheet = ofs.GetAbsolutePathName(args.item(0));
  var converter = ofs.getAbsolutePathName("xsl-xslt-converter.xslt");
  if (args.length < 2)
    var dest = ofs.getAbsolutePathName(args.item(0)) + "t";
  else
    var dest = ofs.getAbsolutePathName(args.item(1));
  
  var oXML = new ActiveXObject("MSXML2.DOMDocument");
  oXML.validateOnParse = false;
  oXML.async = false;
  oXML.preserveWhiteSpace = true;
  oXML.load(stylesheet);

  var oXSL = new ActiveXObject("MSXML2.DOMDocument");
  oXSL.validateOnParse = false;
  oXSL.async = false;
  oXSL.load(converter);

  var oResult = new ActiveXObject("MSXML2.DOMDocument");
  oResult.async = false;
  oXML.transformNodeToObject(oXSL, oResult);
  oResult.save(dest);
}
