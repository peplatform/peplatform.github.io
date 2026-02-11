namespace XmlHierMenu {

	using System;
	using System.Xml;
	using System.Collections;
	using System.IO;
	using System.Text;

	public class XmlMenu {
	
		ArrayList _arrayHolderArray	= new ArrayList();
		ArrayList _arrayNamesArray	= new ArrayList();
		string _strImage		= "<img align=\"right\" vspace=\"2\" height=\"10\" width=\"10\" border=\"0\" src=\"tri.gif\">";
		string _strCurrentMenu;
		int	_intLevel;
		bool _blnStaticMenus;
		string _strSaveToFile;
		
		public XmlMenu() {
			init();
		}
		
		public XmlMenu(string imageStr) {
			_strImage = imageStr;
			init();
		}
		
		public XmlMenu(bool bStaticMenu,string sFileToSaveTo) {
			_blnStaticMenus = bStaticMenu;
			_strSaveToFile = sFileToSaveTo;
			init();
		}
		
		private void init() {
			_strCurrentMenu	= "";
			_intLevel = 1;		
		}
		
            public string CreateMenu(string startMenu,string file) {
                StringBuilder strOutput = new StringBuilder();
                int i = 0;
                ArrayList startArray = new ArrayList();
                string strVariable = "";
                string strTemp = "";
			
                XmlDocument XMLDoc = new XmlDocument();
                try {
                    XMLDoc.Load(file);
                }
                catch (Exception e) {
                    strOutput.Append(e.GetBaseException().ToString());
                    return strOutput.ToString();
                }
				
                XmlNodeList nodeList = XMLDoc.DocumentElement.ChildNodes;
                			
                foreach (XmlNode node in nodeList) {

                    XmlNode currentNode = node;
                        if (currentNode.HasChildNodes == true && currentNode.ChildNodes.Count>1) {
                            _strCurrentMenu = startMenu + "_" + (i+1);
                            string thisMenu = startMenu;	
                            if (currentNode.ChildNodes.Count>2) {
                                strVariable = "<span id=\"" + thisMenu + "_span" + (i+1) + "\" class='cellOff' onMouseOver=\"stateChange('" + _strCurrentMenu +  "',this," + _intLevel + ")\" onMouseOut=\"stateChange('',this,'')\">" + _strImage + currentNode.ChildNodes[1].InnerText + "</span><br>\n";
                                startArray.Add(strVariable);	
                                WalkTree(currentNode);
                            } else {
                                strVariable = "<span id=\"" + thisMenu + "_span" + (i+1) + "\" class='cellOff' onMouseOver=\"stateChange('',this,'');hideDiv(" + _intLevel + ")\" onMouseOut=\"stateChange('',this,'')\" onClick=\"location.href='" + currentNode.ChildNodes[0].InnerText + "'\">" + currentNode.ChildNodes[1].InnerText + "</span><br>\n";
                                startArray.Add(strVariable);	
                            }
                        }
                    i++;
                }
			
                startArray.TrimToSize();			
                _arrayNamesArray.Add(startMenu);
                for (i=0;i<startArray.Count;i++) {
                    strTemp += startArray[i];
                }
                _arrayHolderArray.Add(strTemp);
			
                //Reverse Array order so we don't have to worry about the ZIndex of each div layer
                _arrayHolderArray.Reverse();
                _arrayNamesArray.Reverse();

                //Loop through arrays and write out divs and their individual span content items
                for (i=0;i<_arrayNamesArray.Count;i++) {
                    strOutput.Append("<div id='" + _arrayNamesArray[i].ToString() + "' class='clsMenu'>");
                    strOutput.Append(_arrayHolderArray[i].ToString());
                    strOutput.Append("</div>\n");
                }			
                _arrayHolderArray.Clear();
                _arrayNamesArray.Clear();
			
                if (_blnStaticMenus) {
                    StreamWriter writer = new StreamWriter(File.Open(_strSaveToFile, FileMode.OpenOrCreate, FileAccess.Write));
                    writer.Write(strOutput.ToString());
                    writer.Flush();		
                    if (writer !=null) writer.Close();
                }
                return strOutput.ToString();
            } //CreateMenus
		
private void WalkTree(XmlNode node) {
	_intLevel += 1;
	string strVariable = "";
	string strTemp = "";
	ArrayList tempArray			= new ArrayList();
		
	for (int j=2;j<node.ChildNodes.Count;j++) {
		XmlNode newNode = node.ChildNodes[j];
			
		if (newNode.HasChildNodes == true && newNode.ChildNodes.Count>2) {	// Each node should have a 0=hyperlink and 1=text node so don't call the function again if there are just these children
			_strCurrentMenu += "_" + (j-1);
			string thisMenu = _strCurrentMenu.Substring(0,_strCurrentMenu.Length-2);
			strVariable = "<span id=\"" + thisMenu + "_span" + (j-1) + "\" class='cellOff' onMouseOver=\"stateChange('" + _strCurrentMenu + "',this," + _intLevel + ")\" onMouseOut=\"stateChange('',this,'')\">" + _strImage + newNode.ChildNodes[1].InnerText + "</span><br>\n";
			tempArray.Add(strVariable);
			WalkTree(newNode);
		} else {
			strVariable = "<span id=\"" + _strCurrentMenu + "_span" + (j-1) + "\" class='cellOff' onMouseOver=\"stateChange('',this,'');hideDiv(" + _intLevel + ")\" onMouseOut=\"stateChange('',this,'')\" onClick=\"location.href='" + newNode.ChildNodes[0].InnerText + "'\">" + newNode.ChildNodes[1].InnerText + "</span><br>\n";
			tempArray.Add(strVariable);
		}			
	}
	
	tempArray.TrimToSize();
	_arrayNamesArray.Add(_strCurrentMenu);
	for (int i=0;i<tempArray.Count;i++) {
		strTemp += tempArray[i];
	}
	_arrayHolderArray.Add(strTemp);
	_strCurrentMenu = _strCurrentMenu.Substring(0,_strCurrentMenu.Length-2); //Exiting function so go back to previous menu version
	_intLevel -= 1;
	tempArray.Clear();
} // WalkTree
	} //XMlMenu
} //XmlHierMenu