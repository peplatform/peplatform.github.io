<?xml version="1.0"?>
<!--

  xsl-xslt-converter.xslt 1.1
  
  Style sheet for transforming Microsoft Internet Explorer 5 XSL
  to W3C-compliant XSLT for use in the Microsoft July 2000 MSXML
  Web Release.  See http://msdn.microsoft.com/xml.
  
  Author: Jonathan Marsh <jmarsh@microsoft.com>
  Copyright 2000 Microsoft Corp.

  Change history:
  
  1.0.1:
    - fixed infinite loop in splitSortDirection
  1.1:
    - updated to work with July 2000 MSXML Web Release, as follows:
    - replaced creation of xmlns attributes (non-conformant), now
      generates dummy attributes to force namespace creation (dummy
      attributes must be removed before running - they are rejected
      because of a conformance bug).
    - replaced <xsl:copy> for copying attributes (non-conformant)
    - replaced local:contains() with contains() (perf)
    - eliminated redundant string() casts (perf)
    - warning list - reduced complete tree walks from 44 to 1 (perf)
    - warning list - report errors in order-by attributes (completeness)
    - replaced local:xtlruntime_uniqueID() with generate-id() (perf)
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
                xmlns:oldxsl="http://www.w3.org/TR/WD-xsl"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:amsxsl="urn:schemas-microsoft-com:xsltAlias"
                xmlns:local="#local-functions"
                xmlns:xql="#xql-functions"
                exclude-result-prefixes="oldxsl">

<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>
<xsl:namespace-alias stylesheet-prefix="amsxsl" result-prefix="msxsl"/>

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:template match="processing-instruction('xml')"/>

<xsl:template match="/">
  <xsl:comment>
    [XSL-XSLT] This stylesheet automatically updated from an IE5-compatible XSL stylesheet to XSLT.
    The following problems which need manual attention may exist in this stylesheet:
    <xsl:for-each select=".//@match | .//@test | .//@select | .//@order-by"><xsl:if test="name()='match' and parent::oldxsl:if">- match attributes may not be used on xsl:if.  Update to "test".
    </xsl:if><xsl:if test="name()='match' and parent::oldxsl:when">- match attributes may not be used on xsl:when. Update to "test".
    </xsl:if><xsl:if test="contains(., 'ancestor(')">- ancestor() needs to be manually converted to the ancestor:: axis.
    </xsl:if><xsl:if test="contains(., ')!')">- Method notation, f1()!f2(), needs to be manually converted to functional notation, f2(f1()).
    </xsl:if><xsl:if test="contains(., 'value(')">- value() method not supported.  In most situations, this can just be removed.
    </xsl:if><xsl:if test="contains(., 'date(')">- date() method not supported.
    </xsl:if><xsl:if test="contains(., 'context(-2)')">- arguments to context() method not supported.  Rewrite using named variables.
    </xsl:if><xsl:if test="contains(., 'context(-3)')">- arguments to context() method not supported.  Rewrite using named variables.
    </xsl:if><xsl:if test="contains(., '$ieq$')">- Case insensitive operator $ieq$ is not supported.
    </xsl:if><xsl:if test="contains(., '$ine$')">- Case insensitive operator $ine$ is not supported.
    </xsl:if><xsl:if test="contains(., '$ilt$')">- Case insensitive operator $ilt$ is not supported.
    </xsl:if><xsl:if test="contains(., '$ile$')">- Case insensitive operator $ile$ is not supported.
    </xsl:if><xsl:if test="contains(., '$igt$')">- Case insensitive operator $igt$ is not supported.
    </xsl:if><xsl:if test="contains(., '$ige$')">- Case insensitive operator $ige$ is not supported.
    </xsl:if><xsl:if test="contains(., '$not$')">- $not$ need to be rewritten using functional syntax.
    </xsl:if><xsl:if test="contains(., '$all$')">- $all$ a=b needs to be rewritten as an "any" (the default), using not(a != b).
    </xsl:if></xsl:for-each>
    <xsl:if test="local:countNamespaceDecls(/oldxsl:stylesheet) &gt; 0">- dummy attributes '*:remove-this-dummy-attribute' must be removed.
    </xsl:if>
</xsl:comment>
  <xsl:text xml:space="preserve">

</xsl:text>
  <xsl:apply-templates select="@*|node()|oldxsl:stylesheet"/>
</xsl:template>
  
<xsl:template match="oldxsl:stylesheet">
  <xsl:text xml:space="preserve">

</xsl:text>
  <axsl:stylesheet version="1.0"      exclude-result-prefixes="msxsl local xql">
    <xsl:apply-templates select="@*"/>
    <xsl:for-each select="(//*)[position() &lt;= local:countNamespaceDecls(/oldxsl:stylesheet)]">
      <xsl:attribute name="{local:namespaceDeclsPrefix(/oldxsl:stylesheet, position())}:remove-this-dummy-attribute"
                     namespace="{local:namespaceDeclsURI(/oldxsl:stylesheet, position())}">added by xsl-xslt-converter</xsl:attribute>
          
    </xsl:for-each>

    <!--xsl:copy-of select="namespace::*"/-->
    
    <xsl:comment> [XSL-XSLT] Updated namespace, added the required version attribute, and added namespaces necessary for script extensions. </xsl:comment>
    <xsl:text xml:space="preserve">
  
  </xsl:text>
    <xsl:comment> [XSL-XSLT] Explicitly apply the default (and only) indent-result behavior </xsl:comment>
    <xsl:text xml:space="preserve">
  </xsl:text>

    <axsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <xsl:text xml:space="preserve">
  
  </xsl:text>
    <xsl:comment> [XSL-XSLT] Simulate lack of built-in templates </xsl:comment>
    <xsl:text xml:space="preserve">
  </xsl:text>
    <axsl:template match="@*|/|node()"/>
    <xsl:text xml:space="preserve">
  </xsl:text>
    <xsl:apply-templates select="node()"/>
    
    <xsl:text xml:space="preserve">
  </xsl:text>

  <xsl:if test="local:needsXQL()">
  <amsxsl:script implements-prefix="xql">
  <xsl:text disable-output-escaping="yes"><![CDATA[<![CDATA[
      // ******************************************************* //
    // **  Boilerplate functions implementing deprecated XQL   //
    // **  methods                                             //
    // **                                                      //
    // ******************************************************* //
        function nodeType(pNodeList)    {      return pNodeList.item(0).nodeType;    }    function element(pNodeList)    {      return pNodeList.item(0).nodeType == 1;    }    function attribute(pNodeList)    {      return pNodeList.item(0).nodeType == 2;    }    
    function cdata(pNodeList)    {      return pNodeList.item(0).nodeType == 4;    }
    
    function textNode(pNodeList)    {      return pNodeList.item(0).nodeType == 3;    }

  ]]>]]&gt;</xsl:text></amsxsl:script>
    <xsl:text xml:space="preserve">
  </xsl:text>
  </xsl:if>
  
  <xsl:if test="oldxsl:script | .//oldxsl:eval | .//oldxsl:if[@expr] | .//oldxsl:when[@expr]">
  <amsxsl:script implements-prefix="local">
  <xsl:text disable-output-escaping="yes"><![CDATA[<![CDATA[
      // ******************************************************* //
    // **  xsl:script                                          //
    // **                                                      //
    // **  functions converted from xsl:script blocks          //
    // ******************************************************* //    
  ]]></xsl:text>
    <xsl:for-each select="oldxsl:script"><xsl:value-of select="." disable-output-escaping="yes"/></xsl:for-each>      <xsl:text disable-output-escaping="yes"><![CDATA[    
    // ******************************************************* //
    // **  xsl:eval                                            //
    // **                                                      //
    // **  functions representing xsl:eval statements          //
    // ******************************************************* //    // !! Warning - "this" changed to "__this" throughout, possible undesireable consequences !!  
  ]]></xsl:text>
    <xsl:for-each select="//oldxsl:eval">    function eval_<xsl:value-of select="generate-id(.)"/>(_contextNodeList)    {      var __this = _contextNodeList.item(0);
      return <xsl:value-of select="local:replaceToken(string(.),'this','__this')" disable-output-escaping="yes"/>    }
    
    </xsl:for-each>      <xsl:text disable-output-escaping="yes"><![CDATA[    
    // ******************************************************* //
    // **  expr functions                                      //
    // **                                                      //
    // **  functions representing xsl:if expr="" or            //    // **  xsl:when expr="" statements                         //
    // ******************************************************* //    // !! Warning - "this" changed to "__this" throughout, possible undesireable consequences !!  
  ]]></xsl:text>
    <xsl:for-each select="//@expr">    function expr_<xsl:value-of select="generate-id(..)"/>(_contextNodeList)    {      var __this = _contextNodeList.item(0);
      return <xsl:value-of select="local:replaceToken(string(.),'this','__this')" disable-output-escaping="yes"/>    }
    
    </xsl:for-each>      <xsl:text disable-output-escaping="yes"><![CDATA[
    
      // ******************************************************* //
    // **  Boilerplate follows                                 //
    // **                                                      //
    // **  implementations of XTLRuntime functions             //
    // ******************************************************* //        function absoluteChildNumber(pNode)
    {
      var n = 1;      while (pNode = pNode.previousSibling)
        n++;      return n;
    }
    function xtlruntime_absoluteChildNumber(pNodeList)    {      if (pNodeList)
        return absoluteChildNumber(pNodeList.item(0));
      else
        return "";    }  
    
    function ancestorChildNumber(bstrNodeName, pNode)
    {
      // BUGBUG - needs XPath syntax      var a = pNode.selectSingleNode("ancestor(" + bstrNodeName + ")");
      if (a)
        return childNumber(a);
      else
        return null;
    }
    function xtlruntime_ancestorChildNumber(bstrNodeName, pNodeList)    {      if (pNodeList)
      {        var n = ancestorChildNumber(bstrNodeName, pNodeList.item(0));        if (n)          return n;
      }      return "";    }          function childNumber(pNode)
    {
      var n = 1;      var name = pNode.nodeName;      while (pNode = pNode.previousSibling)
        if (pNode.nodeName == name)
          n++;      return n;
    }
    function xtlruntime_childNumber(pNodeList)    {      if (pNodeList)
        return childNumber(pNodeList.item(0));
      else
        return "";    }    function depth(pNode)
    {
      var n = 0;      while (pNode = pNode.parentNode)
        n++;      return n;
    }
    function xtlruntime_depth(pNodeList)    {      if (pNodeList)
        return depth(pNodeList.item(0));
      else
        return 0;    }    
    function formatDate(varDate, bstrFormat, varDestLocale)
    {      // BUGBUG ignores locale      var date = varDate;  // BUGBUG need conversion from varDate
      
      var result = "";
      for (var i=0; i<bstrFormat.length; i++)
      {
        switch (bstrFormat.charAt(i)) {
        case "d":
          if (bstrFormat.charAt(i+1) == "d") {
            i++;
            if (bstrFormat.charAt(i+1) == "d") {
              i++;
              if (bstrFormat.charAt(i+1) == "d") {
                //dddd
                i++;
                var longMonthName = new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
                result += longMonthName[date.getDay()];
              }
              else { //ddd
                var shortMonthName = new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
                result += shortMonthName[date.getDay()];
              }
            }
            else //dd
               result += (date.getDate()<10 ? "0" : "") + (date.getDate());
          }
          else //dd
            result += date.getDate();
          break;
        case "M":
          if (bstrFormat.charAt(i+1) == "M") {
            i++;
            if (bstrFormat.charAt(i+1) == "M") {
              i++;
              if (bstrFormat.charAt(i+1) == "M") {
                //MMMM
                i++;
                var longMonthName = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
                result += longMonthName[date.getMonth()];
              }
              else { //MMM
                var shortMonthName = new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
                result += shortMonthName[date.getMonth()];
              }
            }
            else //MM
              result += (date.getMonth()<9 ? "0" : "") + (date.getMonth() + 1);
          }
          else //M
            result += date.getMonth() + 1;
          break;
        case "y":
          if (bstrFormat.charAt(i+1) == "y") {
            i++;
            if (bstrFormat.charAt(i+1) == "y" && bstrFormat.charAt(i+2) == "y") {
              // yyyy
              i += 2;
              result += date.getFullYear();
            }
            else //yy
              result += (date.getFullYear() + "").substr(2,2);
          }
          else //y
            result += date.getFullYear() % 100;
          break;
        case "'":
          i++;
          while (bstrFormat.charAt(i) != "'" && i < bstrFormat.length)
            result += bstrFormat.charAt(i++);
          // Handle quoted quotes ('') in the literal
          if (bstrFormat.charAt(i+1) == "'")
            result += "'";
          break;
        default:
          result += bstrFormat.charAt(i);
        }
      }
      
      return result;
    }
        function formatIndex(lIndex, bstrFormat)
    {
      var flag = false;
      switch (bstrFormat) {
      case "1":
        return lIndex.toString();
        break;
      case "A":
      case "a":
        var n = (lIndex - 1) % 26;        var r = Math.floor((lIndex - 1) / 26);        var digit = String.fromCharCode(bstrFormat.charCodeAt(0) + n);
        var result = "";        for (var i=0; i<=r; i++)
          result += digit;
        return result;        break;
      case "i":
        flag = true;
      case "I":
        if (lIndex < 1) return null;
        switch (lIndex % 10) {        case 0: var ones = ""; break;
        case 1: var ones = "I"; break;
        case 2: var ones = "II"; break;
        case 3: var ones = "III"; break;
        case 4: var ones = "IV"; break;
        case 5: var ones = "V"; break;
        case 6: var ones = "VI"; break;
        case 7: var ones = "VII"; break;
        case 8: var ones = "VIII"; break;
        case 9: var ones = "IX"; break;
        }        switch (Math.floor(lIndex/10) % 10) {        case 0: var tens = ""; break;
        case 1: var tens = "X"; break;
        case 2: var tens = "XX"; break;
        case 3: var tens = "XXX"; break;
        case 4: var tens = "XL"; break;
        case 5: var tens = "L"; break;
        case 6: var tens = "LX"; break;
        case 7: var tens = "LXX"; break;
        case 8: var tens = "LXXX"; break;
        case 9: var tens = "XC"; break;
        }        switch (Math.floor(lIndex/100) % 10) {        case 0: var hundreds = ""; break;
        case 1: var hundreds = "C"; break;
        case 2: var hundreds = "CC"; break;
        case 3: var hundreds = "CCC"; break;
        case 4: var hundreds = "CD"; break;
        case 5: var hundreds = "D"; break;
        case 6: var hundreds = "DC"; break;
        case 7: var hundreds = "DCC"; break;
        case 8: var hundreds = "DCCC"; break;
        case 9: var hundreds = "CM"; break;
        }        var thousands = "MMMMMMMMM".substring(0,Math.floor(lIndex/1000) % 10);
        var digits = thousands + hundreds + tens + ones;        if (flag)
          return digits.toLowerCase();
        else          return digits;
        break;
      default: // 01, 001, etc.
        // No error checking done.  formatStrings like ".....1" produce some interesting results
        var n = lIndex.toString();
        var leadingZeroes = bstrFormat.substring(0, bstrFormat.length - n.length);
        return leadingZeroes + n;
        break;
      }
    }        function tenToTheNth(n)
    {      if (n == 0)        return 1;
      else        return 10 * tenToTheNth(n-1);
    }
    function formatNumber(number, bstrFormat)    {      var afterDecimal = false;
      var afterDecimalPrecision = 0;
      
      // parse the format string, building a template determining precision required for
      //  rounding, whether there is a thousands separator, and performing scaling.
      var thousandsSeparator = false;
      var afterDecimalMinPrecision = 0;
      var afterDecimalMaxPrecision = 0;
      var beforeDecimalMinPrecision = 0;
      var template = "";
      for (var i=0; i<bstrFormat.length; i++)
      {
        switch (bstrFormat.charAt(i)) {
        case "0":
          if (afterDecimal)
          {
            afterDecimalPrecision++;
            afterDecimalMinPrecision = afterDecimalPrecision;
            afterDecimalMaxPrecision = afterDecimalPrecision;
          }
          else
          {
            beforeDecimalMinPrecision++;
          }
          template += "0";
          break;
        case "#":
          if (afterDecimal)
          {
            afterDecimalPrecision++;
            afterDecimalMaxPrecision = afterDecimalPrecision;
          }
          else
          {
            if (beforeDecimalMinPrecision > 0)
              beforeDecimalMinPrecision++;
          }
          template += "#";
          break;
        case ".":
          afterDecimal = true;
          template += ".";
          break;
        case ",":
          if (afterDecimal)
            template += ",";
          else
          {
            if (bstrFormat.charAt(i+1) == "0" || bstrFormat.charAt(i+1) == "#")
              thousandsSeparator = true;
            else
              number /= 1000;
          }
          break;
        case "%":
          number *= 100;
          template += "%";
          break;          
       case '"':
          i++;
          while (bstrFormat.charAt(i) != '"' && i < bstrFormat.length)
            template += '"' + bstrFormat.charAt(i++);
          break;
        default:
          template += bstrFormat.charAt(i);
        }
      }      // Round the number to the correct number of digits and convert it to to a string;      number = (Math.round(number*tenToTheNth(afterDecimalMaxPrecision)))/tenToTheNth(afterDecimalMaxPrecision);
      var numberString = number + "";      if (number < 1)        numberString = numberString.substring(1);

      // Where is the decimal point?
      quotedTemplate = template.replace(/"\./g,'""');
      var decimalPosition = quotedTemplate.indexOf(".");
      if (decimalPosition < 0)
        decimalPosition = template.length;      // Fill in the template starting at the decimal point and working left
      var j = numberString.indexOf(".");
      if (j < 0)
        j = numberString.length;      var insertionPoint = 0;      var thousands = 0;      for (var i=decimalPosition; i >=0; i--)
      {
        if (template.charAt(i-1) != '"')        {          if ((template.charAt(i) == "0" || template.charAt(i) == "#") && j > 0)
          {            template = template.substring(0,i) + numberString.charAt(--j) + template.substring(i+1);            if (thousandsSeparator && j > 0)            {              thousands++;
              if (thousands > 2) {
                thousands = 0;                template = template.substring(0,i) + "," + template.substring(i);              }            }            insertionPoint = i;
          }          if (template.charAt(i) == "#" && j <= 0)
            template = template.substring(0,i) + template.substring(i+1);        }      }
      
      // Insert remaining left digits, with thousands separators as necessary
      if (j > 0)      {
        for (j; j>0; j--)        {          template = template.substring(0,insertionPoint) + numberString.substring(j-1,j) + template.substring(insertionPoint);          if (thousandsSeparator)          {            if (thousands > 2) {
              thousands = 0;              template = template.substring(0,insertionPoint+1) + "," + template.substring(insertionPoint+1);            }            thousands++;
          }
        }
      }
            // Where is the decimal point now?
      quotedTemplate = template.replace(/"\./g,'""');
      var decimalPosition = quotedTemplate.indexOf(".");
      if (decimalPosition < 0)
        decimalPosition = template.length;      // Fill in the template starting at the decimal point and working right
      var j = numberString.indexOf(".");      if (j < 0)        j = numberString.length;
            for (var i=decimalPosition + 1; i < template.length; i++)
      {
        if (template.charAt(i) == "0" && j < numberString.length)        {          j++          template = template.substring(0,i) + numberString.charAt(j) + template.substring(i+1);
        }        if (template.charAt(i) == "#")
        {          if (j < numberString.length)
          {
            j++            template = template.substring(0,i) + numberString.charAt(j) + template.substring(i+1);
          }
          else
          {
            template = template.substring(0,i) + template.substring(i+1);
            i--;
          }        }
        if (template.charAt(i) == '"')
          i++;      }
      template = template.replace(/"/g,"");
      return template;          }    function formatTime(varDate, bstrFormat)
    {      var time = varDate;  // BUGBUG need conversion from varDate
      
      var result = "";
      for (var i=0; i<bstrFormat.length; i++)
      {
        switch (bstrFormat.charAt(i)) {
        case "H":
          if (bstrFormat.charAt(i+1) == "H") {
            // HH
            i++;
            result += (time.getHours()<10 ? "0" : "") + (time.getHours());
          }
          else // H
            result += time.getHours();
          break;
        case "h":
          var hours = time.getHours() % 12;
          if (hours == 0) hours = 12;
          if (bstrFormat.charAt(i+1) == "h") {
            // hh
            i++;
            result += (hours<10 ? "0" : "") + hours;
          }
          else // h
            result += hours;
          break;
        case "m":
          if (bstrFormat.charAt(i+1) == "m") {
            // mm
            i++;
            result += (time.getMinutes()<10 ? "0" : "") + (time.getMinutes());
          }
          else // m
            result += time.getMinutes();
          break;
       case "s":
          if (bstrFormat.charAt(i+1) == "s") {
            // ss
            i++;
            result += (time.getSeconds()<10 ? "0" : "") + (time.getSeconds());
          }
          else // s
            result += time.getSeconds();
          break;
       case "t":
          if (bstrFormat.charAt(i+1) == "t") {
            // tt
            i++;
            result += time.getHours() < 12 ? "AM" : "PM";
          }
          else // t
            result += time.getHours() < 12 ? "A" : "P";
          break;
       case "'":
          i++;
          while (bstrFormat.charAt(i) != "'" && i < bstrFormat.length)
            result += bstrFormat.charAt(i++);
          // Handle quoted quotes ('') in the literal
          if (bstrFormat.charAt(i+1) == "'")
            result += "'";
          break;
        default:
          result += bstrFormat.charAt(i);
        }
      }
      
      return result;
    }


    // Note that this now returns a string instead of a number    function uniqueID(pNode)
    {
      if (pNode)
      {
        if (pNode.nodeType == 2)          return uniqueID(pNode.selectSingleNode("..")) + "_" + pNode.nodeName;
        else if (pNode.parentNode)          return uniqueID(pNode.parentNode) + "_" + absoluteChildNumber(pNode);        else          return absoluteChildNumber(pNode);
      }
      return "";    }
    function xtlruntime_uniqueID(pNodeList)    {      if (pNodeList)
        return uniqueID(pNodeList.item(0));
      else
        return "";    }  ]]>]]&gt;</xsl:text></amsxsl:script>
    <xsl:text xml:space="preserve">
  </xsl:text>
  </xsl:if>
</axsl:stylesheet>
</xsl:template>

<xsl:template match="node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@*">
  <xsl:attribute name="{name()}">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="xsl:stylesheet/@indent-result"/>
<xsl:template match="oldxsl:script"/>

<xsl:template match="oldxsl:eval">
  <xsl:comment> [XSL-XSLT] Converted xsl:eval to xsl:value-of </xsl:comment>
  <axsl:value-of>
    <xsl:if test="@no-entities">
      <xsl:attribute name="disable-output-escaping">yes</xsl:attribute>
    </xsl:if>
    <xsl:attribute name="select">local:eval_<xsl:value-of select="generate-id(.)"/>(.)</xsl:attribute>
  </axsl:value-of>
</xsl:template>

<xsl:template match="oldxsl:template">
  <axsl:template>
    <xsl:if test="not(@match)"><xsl:attribute name="match">@*|/|node()</xsl:attribute></xsl:if>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:template>
  <xsl:apply-templates select=".//oldxsl:template" mode="nested"/>
</xsl:template>
<xsl:template match="oldxsl:template" mode="nested">
    <xsl:text xml:space="preserve">
  </xsl:text>
  <xsl:comment> [XSL-XSLT] Converted nested template to a mode </xsl:comment>
  <axsl:template>
    <xsl:if test="not(@match)"><xsl:attribute name="match">@*|/|node()</xsl:attribute></xsl:if>
    <xsl:attribute name="mode">mode_<xsl:value-of select="generate-id(..)"/></xsl:attribute>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:template>
</xsl:template>

<xsl:template match="oldxsl:for-each">
  <axsl:for-each>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="@order-by">
      <xsl:variable name="orderByString" select="@order-by"/>
      <xsl:for-each select="(//*)[position()&lt;local:countSortCriteria(string($orderByString))]">
        <axsl:sort>
          <xsl:attribute name="select"><xsl:value-of select="local:splitSortCriteria(string($orderByString), position())"/></xsl:attribute>
          <xsl:variable name="direction" select="local:splitSortDirection(string($orderByString), position())"/>
          <xsl:if test="$direction">
            <xsl:attribute name="order"><xsl:value-of select="$direction"/></xsl:attribute>
          </xsl:if>
        </axsl:sort>
      </xsl:for-each>
    </xsl:if>
    <xsl:apply-templates select="node()"/>
  </axsl:for-each>
</xsl:template>
<xsl:template match="@order-by"/>

<xsl:template match="oldxsl:value-of">
  <axsl:value-of>
    <xsl:if test="not(@select)"><xsl:attribute name="select">.</xsl:attribute></xsl:if>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:value-of>
</xsl:template>

<xsl:template match="oldxsl:apply-templates">
  <axsl:apply-templates>
    <xsl:if test="ancestor::oldxsl:apply-templates">
      <xsl:attribute name="mode">mode_<xsl:value-of select="generate-id(ancestor::oldxsl:apply-templates[1])"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="oldxsl:template">
      <xsl:attribute name="mode">mode_<xsl:value-of select="generate-id(.)"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="@order-by">
      <xsl:variable name="orderByString" select="@order-by"/>
      <xsl:for-each select="(//*)[position()&lt;local:countSortCriteria(string($orderByString))]">
        <axsl:sort>
          <xsl:attribute name="select"><xsl:value-of select="local:splitSortCriteria(string($orderByString), position())"/></xsl:attribute>
          <xsl:variable name="direction" select="local:splitSortDirection(string($orderByString), position())"/>
          <xsl:if test="$direction">
            <xsl:attribute name="order"><xsl:value-of select="$direction"/></xsl:attribute>
          </xsl:if>
        </axsl:sort>
      </xsl:for-each>
    </xsl:if>
  </axsl:apply-templates>
</xsl:template>

<xsl:template match="oldxsl:if">
  <axsl:if>
    <xsl:choose>
      <xsl:when test="@expr and @test">
        <xsl:attribute name="test"><xsl:value-of select="@test"/> and local:expr_<xsl:value-of select="generate-id(.)"/>(.)</xsl:attribute>    
      </xsl:when>
      <xsl:when test="@expr">
        <xsl:attribute name="test">local:expr_<xsl:value-of select="generate-id(.)"/>(.)</xsl:attribute>    
      </xsl:when>
      <xsl:when test="@test">
        <xsl:attribute name="test"><xsl:value-of select="@test"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="test">node()|@*</xsl:attribute>    
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:if>
</xsl:template>

<xsl:template match="oldxsl:choose">
  <axsl:choose>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:choose>
</xsl:template>

<xsl:template match="oldxsl:when">
  <axsl:when>
    <xsl:choose>
      <xsl:when test="@expr and @test">
        <xsl:attribute name="test"><xsl:value-of select="@test"/> and local:expr_<xsl:value-of select="generate-id(.)"/>(.)</xsl:attribute>    
      </xsl:when>
      <xsl:when test="@expr">
        <xsl:attribute name="test">local:expr_<xsl:value-of select="generate-id(.)"/>(.)</xsl:attribute>    
      </xsl:when>
      <xsl:when test="@test">
        <xsl:attribute name="test"><xsl:value-of select="@test"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="test">node()|@*</xsl:attribute>    
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:when>
</xsl:template>
<xsl:template match="@test"/>
<xsl:template match="@expr"/>

<xsl:template match="oldxsl:otherwise">
  <axsl:otherwise>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:otherwise>
</xsl:template>

<xsl:template match="oldxsl:copy">
  <axsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:copy>
</xsl:template>

<xsl:template match="oldxsl:element">
  <axsl:element>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:element>
</xsl:template>

<xsl:template match="oldxsl:attribute">
  <axsl:attribute>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:attribute>
</xsl:template>

<xsl:template match="oldxsl:pi">
  <axsl:processing-instruction>
    <xsl:apply-templates select="@*"/>
    <xsl:comment> [XSL-XSLT] Renamed xsl:pi to xsl:processing-instruction </xsl:comment>
    <xsl:apply-templates select="node()"/>
  </axsl:processing-instruction>
</xsl:template>

<xsl:template match="oldxsl:pi[@name='xml']">
  <xsl:comment> [XSL-XSLT] Cannot create the XML declaration using xsl:processing-instruction.  Use xsl:output instead. </xsl:comment>
</xsl:template>

<xsl:template match="oldxsl:comment">
  <axsl:comment>
    <xsl:apply-templates select="@*|node()"/>
  </axsl:comment>
</xsl:template>

<xsl:template match="oldxsl:node-name">
  <xsl:comment> [XSL-XSLT] Converted xsl:node-name to xsl:value-of </xsl:comment>
  <axsl:value-of select="name()"/>
</xsl:template>

<xsl:template match="oldxsl:entity-ref">
  <xsl:comment> [XSL-XSLT] Converted xsl:entity-ref to xsl:text </xsl:comment>
  <axsl:text disable-output-escaping="yes">
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@name|text()"/>
    <xsl:text>;</xsl:text>
  </axsl:text>
</xsl:template>

<xsl:template match="@match | @select | @test">
  <xsl:attribute name="{name()}">    <xsl:apply-templates select="." mode="content-only">      <xsl:with-param name="XPath" select="string(.)"/>
    </xsl:apply-templates>  </xsl:attribute>
</xsl:template><xsl:template match="@match | @select | @test" mode="content-only">
  <xsl:param name="XPath"/>  <xsl:choose>
    <!-- BUGBUG contains seems broken -->    <xsl:when test="contains($XPath,'nodeName()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'nodeName()'), 'name()', substring-after($XPath,'nodeName()'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'index()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'index()'), 'position()', substring-after($XPath,'index()'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'not(end())')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'not(end())'), 'position()!=last()', substring-after($XPath,'not(end())'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'end()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'end()'), 'position()=last()', substring-after($XPath,'end()'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$gt$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$gt$'), '&gt;', substring-after($XPath,'$gt$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$lt$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$lt$'), '&lt;', substring-after($XPath,'$lt$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$ge$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$ge$'), '&gt;=', substring-after($XPath,'$ge$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$le$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$le$'), '&lt;=', substring-after($XPath,'$le$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$eq$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$eq$'), '=', substring-after($XPath,'$eq$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$ne$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$ne$'), '!=', substring-after($XPath,'$ne$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$and$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$and$'), ' and ', substring-after($XPath,'$and$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$or$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$or$'), ' or ', substring-after($XPath,'$or$'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'$any$')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'$any$'), '', substring-after($XPath,'$any$'))"/>      </xsl:apply-templates>
    </xsl:when>    <xsl:when test="contains($XPath,'&amp;&amp;')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'&amp;&amp;'), ' and ', substring-after($XPath,'&amp;&amp;'))"/>      </xsl:apply-templates>
    </xsl:when>    <xsl:when test="contains($XPath,'||')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'||'), ' or ', substring-after($XPath,'||'))"/>      </xsl:apply-templates>
    </xsl:when>    <xsl:when test="contains($XPath,'context()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'context()'), 'current()', substring-after($XPath,'context()'))"/>      </xsl:apply-templates>
    </xsl:when>    <xsl:when test="contains($XPath,'context(-1)')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'context(-1)'), 'current()', substring-after($XPath,'context(-1)'))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'pi(')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'pi('), 'processing-instruction(', substring-after($XPath,'pi('))"/>      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="contains($XPath,'textnode()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'textnode()'), 'node()[xql:textNode(.)]', substring-after($XPath,'textnode()'))"/>      </xsl:apply-templates>  
      <xsl:value-of select="local:usedXQL()"/>
    </xsl:when>
    <xsl:when test="contains($XPath,'textNode()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'textNode()'), 'node()[xql:textNode(.)]', substring-after($XPath,'textNode()'))"/>      </xsl:apply-templates>
      <xsl:value-of select="local:usedXQL()"/>
    </xsl:when>
    <xsl:when test="contains($XPath,'cdata()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'cdata()'), 'node()[xql:cdata(.)]', substring-after($XPath,'cdata()'))"/>      </xsl:apply-templates>      <xsl:value-of select="local:usedXQL()"/>
    </xsl:when>
    <xsl:when test="contains($XPath,'nodeType()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'nodeType()'), 'xql:nodeType(.)', substring-after($XPath,'nodeType()'))"/>      </xsl:apply-templates>
      <xsl:value-of select="local:usedXQL()"/>
    </xsl:when>
    <xsl:when test="contains($XPath,'element()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'element()'), 'xql:element(.)', substring-after($XPath,'element()'))"/>      </xsl:apply-templates>
      <xsl:value-of select="local:usedXQL()"/>
    </xsl:when>
    <xsl:when test="contains($XPath,'attribute()')">
      <xsl:apply-templates select="." mode="content-only">        <xsl:with-param name="XPath" select="concat(substring-before($XPath,'attribute()'), 'xql:attribute(.)', substring-after($XPath,'attribute()'))"/>      </xsl:apply-templates>      <xsl:value-of select="local:usedXQL()"/>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="local:updateIndexes(string($XPath))"/></xsl:otherwise>
  </xsl:choose></xsl:template>
  <msxsl:script implements-prefix="local"><![CDATA[
    var usesXQLlibrary = false;        function usedXQL()    {      usesXQLlibrary = true;
      return "";    }    function needsXQL()    {      return usesXQLlibrary;    }
    function countNamespaceDecls(pNodeList)
    {
      atts = pNodeList.item(0).attributes;      s = 0;      for (i=0; i < atts.length; i++)
      {        a = atts.item(i);        if (a.nodeName.indexOf("xmlns:") == 0)          if (a.nodeValue != "http://www.w3.org/TR/WD-xsl")            s++;
      }      return s;
    }
    
    function namespaceDeclsPrefix(pNodeList, position)    {
      atts = pNodeList.item(0).attributes;      s = 0;      for (i=0; i < atts.length; i++)
      {        a = atts.item(i);        if (a.nodeName.indexOf("xmlns:") == 0)          if (a.nodeValue != "http://www.w3.org/TR/WD-xsl") {            s++;            if (s == position)              return a.baseName;
          }
      }    }        function namespaceDeclsURI(pNodeList, position)    {
      atts = pNodeList.item(0).attributes;      s = 0;      for (i=0; i < atts.length; i++)
      {        a = atts.item(i);        if (a.nodeName.indexOf("xmlns:") == 0)          if (a.nodeValue != "http://www.w3.org/TR/WD-xsl") {            s++;            if (s == position)              return a.nodeValue;
          }
      }    }        function countSortCriteria(sortString)    {      return sortString.split(";").length + 1;    }
        function splitSortCriteria(sortString, position)    {      var criteriaN = sortString.split(";")[position - 1];      while (criteriaN.charAt(0) == '+' || criteriaN.charAt(0) == '-' || criteriaN.charAt(0) == ' ')      {        criteriaN = criteriaN.substring(1);      }
      return criteriaN;    }
        function splitSortDirection(sortString, position)    {      var criteriaN = sortString.split(";")[position - 1];      while (criteriaN.charAt(0) == '+' || criteriaN.charAt(0) == '-' || criteriaN.charAt(0) == ' ')      {        if (criteriaN.charAt(0) == '+') return "ascending";
        if (criteriaN.charAt(0) == '-') return "descending";        criteriaN = criteriaN.substring(1);
      }
      return "";    }    
    function replaceToken(s, token, newToken)    {
      var re = new RegExp(token, "g");
      return s.replace(re,newToken);    }    
    function updateIndexes(s)
    {      var s = s.replace(/(\[9\])/g, "[10]");
      var s = s.replace(/(\[8\])/g, "[9]");
      var s = s.replace(/(\[7\])/g, "[8]");
      var s = s.replace(/(\[6\])/g, "[7]");
      var s = s.replace(/(\[5\])/g, "[6]");
      var s = s.replace(/(\[4\])/g, "[5]");
      var s = s.replace(/(\[3\])/g, "[4]");
      var s = s.replace(/(\[2\])/g, "[3]");
      var s = s.replace(/(\[1\])/g, "[2]");
      var s = s.replace(/(\[0\])/g, "[1]");
      
      return s;
    }        function absoluteChildNumber(pNode)
    {
      var n = 1;      while (pNode = pNode.previousSibling)
        n++;      return n;
    }
    function xtlruntime_absoluteChildNumber(pNodeList)    {      if (pNodeList)
        return absoluteChildNumber(pNodeList.item(0));
      else
        return "";    }  ]]></msxsl:script>

</xsl:stylesheet>