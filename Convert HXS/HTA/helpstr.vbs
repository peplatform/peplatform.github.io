
'--1- BooGetTitle '2 - BooCreateCHI '3 - Delete temp files? 4 - Clean script '5 - verbose '6 - back color 7 - font color 8 - dest. folder 9 - compiler path 10 - 7-zip path '11 - optional style

Function GetHelpString(iHelp)

Select Case iHelp
  Case 1
    GetHelpString = "Check this box if you would like the Converter to retrieve a descriptive name for the CHM help file by getting the TITLE value from the HXC file [when possible]."
    GetHelpString = GetHelpString & " Example: sr.hxs is about System Restore. The CHM file will normally be named the same as the HXS file -- sr.chm. But if you check this box the CHM will probably be named something like System Restore.chm."
    GetHelpString = GetHelpString & " Note that this option will not always function. In many cases there simply is no title propety in the HXC file, or there may be no HXC file at all."
  Case 2
    GetHelpString = "If you don't have a plan to use a CHI then you probably don't need it, but check this box if you plan to integrate the CHM with MSDN."
  Case 3
    GetHelpString = "Check this box to auto-delete all temporary files created by the Converter when the process is finished. Uncheck it to leave the files. The temporary files comprise a complete CHM project. Anyone familiar with creating CHM files can, if desired, use these files to compile another CHM directly in the Help Workshop."
    GetHelpString = GetHelpString & " One could edit the project file (.HHP), change image files, edit HTML files, etc., and then recompile. Example: Microsoft often inserts distracting and pointless animated GIFs of things like the"
    GetHelpString = GetHelpString & " Internet Explorer logo. In such a case, if one has access to the graphics then it's a simple matter to just alter or swap out annoying cartoons, GIFs, etc. for blank images."
  Case 4
    GetHelpString = "This is an optional step. If the box is checked, the Converter will clean script and " & Chr(34) & "display:none" & Chr(34) & " CSS from the topic files during conversion." 
    GetHelpString = GetHelpString & " The reason for that: Microsoft has a tendency to overdo things. Script in help files is a good example. In some help files Microsoft creates expandable, scrolling DIVs. For instance, with the IE document object there is a menu "
    GetHelpString = GetHelpString & "for events, properties, etc. Select Properties and the members are displayed in a small, scrolling DIV at right. Click the down-arrow button to expand the DIV. To then see the "
    GetHelpString = GetHelpString & "Methods or Events you have to click those buttons, which hides the properties and collapses the viewport. So you then have to click the down arrow button again. ... And so on... In other words, where there used to be a simple list of links for all document methods/properties, "
    GetHelpString = GetHelpString & "now one has to continually click buttons to view members, while others get hidden. The script functions make the documentation harder to read, while adding no advantage."
    GetHelpString = GetHelpString & " The problematic script works by toggling visibility of text blocks, so the Converter fixes the problem by removing all script and all inline " & Chr(34) & "display:none" & Chr(34) & " style code."
  Case 5
    GetHelpString = "** This is only for debugging purposes. **" & vbCrLf & "If this box is checked the Converter will display several message boxes that detail the progress of HXS conversion. Normally the box should be unchecked."
  Case 6
    GetHelpString = "Optional background color For CHM help file topic pages. This value will be overruled by any style settings in the topic pages or in included CSS files. For better control over this value, add the desired value as part of optional style code."
  Case 7
    GetHelpString = "Optional font color for CHM help file topic pages. This value will be overruled by any style settings in the topic pages or in included CSS files. For better control over this value, add the desired value as part of optional style code."
  Case 8
    GetHelpString = "The destination folder path is optional. Normally the CHM file will be created in the same location where the HXS file is. But if the Destination Folder value is a valid folder path, the CHM file will be created there."
  Case 9
    GetHelpString = "Microsoft HTML Help Workshop must be installed to convert HXS files. The required path here is the path to hhc.exe, the HTML Help compiler. A typical path string might be: C:\Program Files\HTML Help Workshop\hhc.exe." & vbCrLf & vbCrLf & "If you do not have the Help Workshop installed you can download it for free here: http://msdn.microsoft.com/en-us/library/ms669985(VS.85).aspx"
  Case 10
    GetHelpString = "7-Zip is required to unpack HXS files. The required path here is the path to 7z.exe. A typical path string might be C:\Program Files\7-Zip\7z.exe." & vbCrLf & vbCrLf & "7-Zip is a free, open-source program. If you do not already have it installed, it can be downloaded here: http://www.7-zip.org/"
  Case 11
    GetHelpString = "Optional style is a style block to be inserted in each topic page. By inserting just before the </HEAD> tag this style will override all but inline styles. This allows you to change any visual aspects of the resulting CHM help file topic pages."
    GetHelpString = GetHelpString & " You can change font, background color, etc. The text should include opening and closing STYLE tags. See the file ConvertToCHM2.vbs for sample code."
    GetHelpString = GetHelpString & " Optional style code will be applied if anything is entered in the designated text area. You can also cause the HXS Converter to save that code for next time, so that it does not have to be entered again each time the Converter is used."
  Case 12
    GetHelpString = "Click the " & Chr(34) & "Convert HXS File" & Chr(34) & " button to convert HXS file. Processing may take several minutes for extremely large (10-50 MB) files. If the conversion fails an error code is returned. The errors are as follows:" & vbCrLf
    GetHelpString = GetHelpString & "1-The path to either MS Help compiler or 7-Zip is missing or invalid." & vbCrLf & "2-Unpacking failure. Probably either a problem with 7-Zip or no .HXT file in HXS." & vbCrLf
    GetHelpString = GetHelpString & "3-The project HHP file should have been produced but is missing." & vbCrLf & "4-The project index [HHK] file should have been produced but is missing." & vbCrLf
    GetHelpString = GetHelpString & "5-The project table of contents file [HHC] should have been produced but is missing." & vbCrLf & "6-The function succeeded and sent the project to the Help Compiler but no CHM file has been found. The Help Compiler has apparently failed without error."
   Case 13
     GetHelpString = "Internet Explorer has a problematic bug that may cause interruptions when converting large files. The bug causes the following message:" & vbCrLf & vbCrLf
     GetHelpString = GetHelpString & "A script on this page is causing Internet Explorer to run slowly. If it continues to run, your computer may become unresponsive. Do you want to abort the script?" & vbCrLf & vbCrLf
     GetHelpString = GetHelpString & "That message might occasionally be helpful on a broken website, but it should not be displayed in an HTA. Moreover, if you choose not to abort the script the message will just keep coming back!"
     GetHelpString = GetHelpString & " With a long-running operation the message box can become so intrusive that one is forced to abort. The fix here writes a value in the Registry to stop the warning messages."
     GetHelpString = GetHelpString & " If you use this fix and then later decide you do not want it, just delete the Registry value: HKCU\Software\Microsoft\Internet Explorer\Styles\MaxScriptStatements"
End Select
   GetHelpString = "  " & GetHelpString
End Function