
'-- Drop a folder onto this script. All HXS help files will be processed and CHM copies produced.
'-- Notes: 

   '  *  7-Zip and the HTML Help Compiler must both be installed. See the settings below to set their paths before using the script.
   '  *  This script cannot process an external HXI index file. If the HXS file has no internal index (an HXK file) then an index will be generated from the HXT (TOC) file.

Dim FSO, SH, oFol, oFils, oFil, oFols, oFol1
Dim iCount1, iCount2, iCountDone, Q2, s1, s2, s3, s4, i2, i3, BooRet, BooRetCHI, UB, iDex, sLog, Ret, cHAID
Dim ParFol, TempFol, DefFile
Dim LenTempPath '-- length of path of files that needs to be removed from left side to get usable relative path for compiler.
Dim HXSPath, HXTPath, HXKPath, HHPPath, HHCPath, HHKPath, HHCName, CHMPath, CHIPath, HHKName, CHMName, CHIName, CHMTitle, CHMTitleBarTitle, HXCPath
Dim AFils(), A1, A2(), ATemp()
Dim AFolPathsLong(), AFolPathsShort(), FolsCount, sFolNameShort
Dim TYPE_LINE
Dim Fixer                  '-- class FixLinks (at end of this script).
Dim sWebFiles            '-- list of files for processing.

   '-- Settings variables. (See explanations below.)
   
Dim Compiler                   '-- Required path to hhc.exe, the HTML Help compiler.
Dim SevZip                     '-- Required path to 7-Zip, used for unpacking .HXS files.
Dim DestinationFolder       '-- Optional value -- path to create CHM file if you DO NOT want it created in same folder as HXS file.
Dim BooDeleteTemp          '-- Boolean. delete temp files produced after finished? Default True.
Dim BooGetTitle               '-- check for a file title if there's an HXC file? Default False.
Dim BooCreateCHI            '-- Create an external CHI index file? Usually not necessary. Default False.
Dim Verbose                    '-- Boolean. want messages while processing?  Default False. (Use for debugging.)
Dim CleanScriptMess         '-- Boolean. Optional function that removes script from .htm files, to stop annoying and unnecessary junk code that creates expanding, scrollable DIVs.
Dim BackColor, FontColor   '-- optional color choices.
Dim CustomStyleBlock              '-- optional style settings.
Dim MSCrapString, sBaseNameHXT , sHTMLPath, sBlankCode1, sBlankCode2, iBlankCount    '1/2018
Dim sParamName, sParamLocal, sParamEnd   '1/2018
'--============================================================================
'-- =============== SETTINGS ====================================================

'--             These first two parameters are required before using script.  
'--              BOTH OF THESE PROGRAMS MUST BE INSTALLED.

'--         Compiler                  - full path to HTML Help Workshop compiler: hhc.exe --------------------------

   Compiler = "C:\Program Files\HTML Help Workshop\hhc.exe"      '-- download here: http://msdn.microsoft.com/en-us/library/ms669985(VS.85).aspx
                                                                                   
'--          SevZip                   - full path to 7-Zip executable. -----------------------------------

   SevZip =  "C:\Program Files\7-Zip\7z.exe"          '--  Download here: http://www.7-zip.org/

'-- 
'---------      OPTIONAL SETTINGS:  -------------------------------------------
'--

' --        DestinationFolder                 -  set this path if you want CHM files to go elsewhere than the location of the HXS file. 
                                                 '-- If this value is "" the CHM will be put in the same folder as the HXS file. (If DestinationFolder path is invalid it won't be used.)
                                
   DestinationFolder = "" 

'--           BooGetTitle                -  True to retrieve a descriptive name for the CHM help file by getting the TITLE value from the HXC file, if present. 
                                               ' Example: sr.hxs is about System Restore. BooGetTitle = True: CHM is named System Restore.chm.  BooGetTitle = False: CHM is named sr.chm, same as HXS file.
                                               '  In many other cases there simply is no title propety in the HXC file, or there may be no HXC file at all.

   BooGetTitle = False

'--           BooCreateCHI                -   If you don't have a plan to use a CHI then you probably don't need it, but set this to True if you plan to integrate the CHM with MSDN.  
  
   BooCreateCHI = False

'--           BooDeleteTemp               -    delete temp folder used for ops after done? Set to false for debugging if you want to inspect files created.

   BooDeleteTemp = True
   
'--           Verbose                         -   True will display progress messages during processing.

    Verbose =  False 
    
'--           CleanScriptMess              - Optional step. Setting this to True will clean script and "display:none" CSS from files. Reason: Microsofties love to overdo
                                                   ' things. In some help files they create expandable, scrolling DIVs. For instance, with the IE document object there is a menu
                                                   ' for events, properties, etc. Select an item and the members are displayed in a small, scrolling DIV at right. Click the down-arrow
                                                   ' button to expand the DIV. In other words, where there used to be a simple list of links for all document methods/properties, 
                                                   ' now one has to continually click "buttons" to view members, while others get hidden.
                                                   ' Also, leaving script in will reslut in errors with some help files.

    CleanScriptMess = True
    
'--          BackColor, FontColor     ' option to use colors other than black and white in topic window. These will not always show up. They may be overridden by style settings.
    
    BackColor = "ffffff" 
    FontColor = "000000"
    
'--           CustomStyleBlock    ' a style block to be inserted in each topic page. By inserting just before the </HEAD> tag this style will override all but inline styles.

    CustomStyleBlock = ""
    
'-- Sample custom style block:

 '   CustomStyleBlock =  "<STYLE>" & vbCrLf & "BODY, TD, DIV, P, SPAN {font-family: verdana, sans-serif; font-size: 12px; line-height: 1.4; color: #000040; background-color: #FEFDFC;}"
 '   CustomStyleBlock = CustomStyleBlock & vbCrLf & "H1, H2, H3, H4 {font-size: 18px; color: #0033AA; background-color: #FFF0DF; font-family: arial, helvetica, sans-serif;}"
 '   CustomStyleBlock = CustomStyleBlock & vbCrLf & "PRE {font-size: 12px; color: #660000; line-height: 1.4;}" & vbCrLf & "A:link {color: #0033FF; text-decoration: none;}" & vbCrLf & "A:visited {text-decoration: none;}"
 '   CustomStyleBlock = CustomStyleBlock & vbCrLf & "A:hover {color: #FFFFFF; background-color: #0066EE; text-decoration: none;}" & vbCrLf & "</STYLE>"


'--=====================   END SETTINGS   ========================================

'--=====================   BASIC START OF SCRIPT: Set up objects, get HXS file paths, etc.   ==================

Q2 = Chr(34)
cHAID = "NAME=" & Q2 & "MS-HAID"
MSCrapString = "ms-help:" '1/2018
 sHTMLPath = ""
  sBlankCode1 = "<HTML><HEAD></HEAD><BODY><H3>"
  sBlankCode2 = "</H3></BODY></HTML>"
  sParamName = "<param name=" & Q2 & "Name" & Q2 & " value=" & Q2
  sParamLocal = "<param name=" & Q2 & "Local" & Q2 & " value=" & Q2
  sParamEnd = Q2 & ">" & vbCrLf
  iBlankCount = 0
  
On Error Resume Next

ParFol = WScript.Arguments(0)
Set FSO = CreateObject("Scripting.FileSystemObject")

If (FSO.FileExists(Compiler) = False) Or (FSO.FileExists(SevZip) = False) Then
  DropIt "Error. Before using this script you must have HTML Help Workshop and 7-Zip installed. Then hardcode the paths in the Settings section at the top of this script. Script will now quit."
End If

Compiler = Q2 & Compiler & Q2

Set Fixer = new FixLinks   ' Fixer used throughout for read/write.

Set SH = CreateObject("WScript.Shell")

  If FSO.FolderExists(ParFol) = False Then DropIt "Error. To use this script you must drop a folder onto it that contains 1 or more HXS files. The script then creates CHM versions of the HXS files."
 
  If FSO.FolderExists(DestinationFolder) = False Then DestinationFolder = ParFol

 Set oFol = FSO.GetFolder(ParFol)  '-- start by getting a list of HXS files in the folder.
ReDim AFils(300)
iCount1 = 0
  Set oFils = oFol.Files
    For Each oFil in oFils
       s2 = oFil.Path
       If UCase(right(s2, 4)) = ".HXS" Then
           AFils(iCount1) = s2
           iCount1 = iCount1 + 1
       End If
    Next
  Set oFils = Nothing
Set oFol = Nothing

If iCount1 = 0 Then DropIt "Error. To use this script you must drop a folder onto it that contains 1 or more HXS files. The script then creates CHM versions of the HXS files. No HXS files found in:" & vbCrLf & ParFol

sLog = "Number of HXS found: " & iCount1 & vbCrLf 

'-- iCount1 is now number of HXS files. AFils holds their paths.
ReDim Preserve AFils(iCount1 - 1)
 
iCount2 = 0
iCountDone = 0   
  
'-- =========== End initial setup and finding of HXS file(s) ===============================


'-- =============================== BEGIN MAIN LOOP ==============================================================
   
'-- Main loop. For each HXS file path, do the following:
'  delete any temp folder left over and extract all files into a fresh temp folder, using 7-Zip.
'  Get path to HXT file. (There must be an HXT file. If not then ProcessHXSFile returns false and loop moves on to next file.)
'  Get path of HXK file if there is one.
'  With that info, create an HHC from the HXT (the TOC) and create an index (HHK) from the HXK if there is one, or from the HXT otherwise.
'  Create an HHP (project file) from the HHC.
'     CreateHHP sub includes calling RepairFolderTree. The CHM compiler will freeze or crash on long folder names, so any name over 16 char. long is changed.
'  Call EditFolderPaths to update the HHC and HHK files with newly shortened paths, if necessary.
'  Fix any "<MSHelp:link>" links. (In some Help2 projects this custom link style is used. See the ProcessLinksForCHM sub for further info.)
'  Call HTML Help Workshop compiler to compile using the HHC, HHK, HHP files.
'  Move the newly-created CHM into the parent folder where the HXS is.

' When the compiling is done, Run is called
'  with the last parameter set to true. The sleep from 1-100 is just for good measure. Actually, HHC creates the CHM file
' before compiling, so if Run does not successfully wait for compiler return then CHM will be open when FSO.MoveFile
' is called and that call will fail with Permission Denied.

'-------------------------------- MAIN LOOP starts here ------------------
For i2 = 0 to iCount1 - 1
  s2 = AFils(i2)
     '--  use 2 Temp folders to allow for deletion. With multiple files sometimes files are still locked when the script tries to delete the old folder and create a fresh one.
   If i2 Mod 2 = 0 Then
      TempFol = ParFol & "\Temp1"
   Else
       TempFol = ParFol & "\Temp2"
   End If
   
  sHTMLPath = ""
  iBlankCount = 0
  sBaseNameHXT = ""
  LenTempPath = Len(TempFol & "\")
  DefFile = ""  '-- clear last default file and reset for this op.

  BooRet = ProcessHXSFile(s2) '-- unpack HXS with 7-Zip and make sure there's at least a .HXT file present.
    If BooRet = False Then sLog = sLog & "ProcessHXSFile failed: " & s2  & vbCrLf & "Likely cause: A problem with 7-Zip or no .HXT file in HXS."
  iCount2 = iCount2 + 1
    If BooRet = True Then 'found unpacked TOC file, at least.
    
       If Verbose = True Then MsgBox "Finished unpacking HXS file. Proceeding with functions to conver project files for CHM."
       
       ConvertHXTtoHHC  ' convert HXT to HHC, which will then be HHCPath.
     
       If FSO.FileExists(HXKPath) = True Then
           ConvertHXKtoHHK   '-- convert the index to a .HHK file.
       Else
           HHKFromHHC '-- create an index .HHK from the TOC if none is present.
       End If

        CHMTitle = ""
        If BooGetTitle = True Then ParseHXC  '-- An official title for the help file may be in the .HXC file, if that's present.
       
    End If
      ' Now HHC and HHK files are ready.
      
    CreateHHP  ' write the HHP project file. This also deals with renaming folders if necessary. (Long folder names will crash the help compiler.)
  '-- problem with extra long folder names in some help2 projects. RepairFolderTree fixed that, if necessary, but if so then
  '-- the contents and index files also need to be fixed. (.HHC and .HHK)
     If FolsCount > 0 Then  '-- some folder names have been changed.
        EditFolderPaths
     End If
     
    Fixer.ParentPath = TempFol & "\"  
    
         '-- if there are MSHelp:link links they need to be fixed. This works in two stages. First it goes through all .htm files to look for
         '-- a META tag with the NAME: "MS_HAID". The CONTENT of that attribute will be a "keyword" string. Those strings correspond to the keyword
         '-- attributes in MSHelp:link tags. So the first stage gets all keywords and saves the corresponding file path. But unfortunately, an MS-HAID
         '-- keyword is not always present. In that case it seems that the file base name will usually work, but it's still a big waste of time because
         '-- many HXS files are not using MSHelp links in the first place, yet there's no way to know for sure since there is no consistency in the application.
         '-- So MSHelp tag processing just has to be done for all files.
         
          '-- The second stage of that process (which can
         '-- be slow with a very big file) opens each .htm, looks for MSHelp:link lnks, and checks the list of IDs that were saved in DicKeys.
         '--  If the MSHelp:link keyword is matched to a key in DicKeys, the item
         '--  will be a valid file path. A valid A tag will then be created to replace the MSHelp tag.

     Fixer.ProcessLinksForCHM sWebFiles  '-- (This operation also calls the function to remove script and adjust CSS if CleanScriptMess = True.)
               
        '-- Make sure everything is ready to go.
    If FSO.FileExists(HHPPath) = False Then sLog = sLog & "Project file " & HHPPath & ": file missing." & vbCrLf
    If FSO.FileExists(HHKPath) = False Then sLog = sLog & "Index file " & HHKPath & ": file missing." & vbCrLf
    If FSO.FileExists(HHCPath) = False Then sLog = sLog & "TOC file " & HHCPath & ": file missing." & vbCrLf

      '-- All done with processing of HXS. Send it to the compiler. 
          If Verbose Then MsgBox "Done processing. Calling HTML Help Workshop compiler." 
          
      Ret = SH.Run(Compiler & " " & Q2 & HHPPath & Q2, 0, True)
   
    On Error Resume Next
       BooRet = False
       If BooCreateCHI = True Then
         BooRetCHI = False
       Else
         BooRetCHI = True
       End If    
   For i3 = 1 to 100   '-- copy CHM to parent folder as soon as possible. This should not actually run more than 1 loop, since code above waits for return.
     WScript.sleep 500
     If FSO.FileExists(CHMPath) = True Then
        If FSO.FileExists(DestinationFolder & "\" & CHMName) = True Then FSO.DeleteFile DestinationFolder & "\" & CHMName, True
        FSO.MoveFile CHMPath, DestinationFolder & "\" & CHMName
        iCountDone = iCountDone + 1
        BooRet = True
        If BooRetCHI = True Then Exit For
     End If
     If BooCreateCHI = True Then
        If FSO.FileExists(DestinationFolder & "\" & CHIName) = True Then FSO.DeleteFile DestinationFolder & "\" & CHIName, True
        FSO.MoveFile CHIPath, DestinationFolder & "\" & CHIName
        BooRetCHI = True
        If BooRet = True Then Exit For
     End If 
   Next    
     If BooRet = False Then sLog = sLog & "No CHM file found: " & CHMName & vbCrLf
Next  


'-- all done.
DropIt iCount2 & " files processed." & vbCrLf & iCountDone & " files converted."

'--========================= END MAIN LOOP ===================================================

'--================ End of main script. Subs and Functions below this point ======================

'-- Ops. From here down are routines that create |  HHC from HXT  |  HHK from HXK  |  HHK from HHC  |  HHP from HHC  etc.


'-------- unzip HXS and find HXT. Return false if it doesn't get that far. --------------------
Function ProcessHXSFile(sFil)
Dim Boo
 On Error Resume Next
     If FSO.FolderExists(TempFol) = True Then FSO.DeleteFolder TempFol, True
       Set oFol = FSO.CreateFolder(TempFol)
     Set oFol = Nothing
     UnZipHXS SevZip & "|" & sFil & "|" & TempFol
    Boo = GetHXTandHXKPaths
    ProcessHXSFile = Boo   
End Function

  '-- get paths of HXT and HXK. Return false if no HXT found. ------------------------------------
Function GetHXTandHXKPaths()
  Dim sExt1, sLinkName
   HXTPath = ""
   HXKPath = "" 
   GetHXTandHXKPaths = False

  Set oFol = FSO.GetFolder(TempFol)
    Set oFils = oFol.Files
      For Each oFil in oFils
          sExt1 = UCase(right(oFil.Path, 4)) 
          sLinkName = UCase(right(oFil.Path, 9))
         Select Case sExt1
           Case ".HXT"
             HXTPath = oFil.path
          
           Case ".HXK" 
             '-- this is a pain in the neck. The help2 system is full of inconsistencies. Besides the fact that
             '-- an HXS may or may not contain various HXK files that are useless here, with names like ALinks.hxk, FLinks.hxk, etc.
             '   in some cases there will be an apparent index file but it's basically empty! So this code has to check whether a found HXK
             '   is the main HXK, and then it checks the size to see whether it's usable. The 1000 number here is a guess, assuming that
             '   a dummy index will be under 1 KB, and that a usable index will be over 1 KB.
             If (sLinkName <> "LINKS.HXK") And (oFil.Size > 1000) Then HXKPath = oFil.Path
          
           Case ".HXC"
              If BooGetTitle = True Then HXCPath = oFil.path
              
          End Select 
       Next
     Set oFils = Nothing
  Set oFol = Nothing
     If FSO.FileExists(HXTPath) = True Then GetHXTandHXKPaths = True 
 End Function
         
'------------------------------ convert HXT(TOC) to HHC(TOC) file ------------------------------------------
Sub ConvertHXTtoHHC()
  Dim Pt3, Pt4, i6
  Dim TempBuildPath  '1/2018
  
  HHCPath = ""
    s1 = Fixer.FLReadFile(HXTPath)
    
'--very messed up here. Some hxt entries are garbage and have to be fixed.
' this first gets the file name of the hxt, which is the best guess as
' to what a corrupted hxt url will need to clean it up.
' example: HTML file is at html/page1.htm. But some HXT entries have a bizarre format
' like: ms-help:/../blah/html/page1.htm
' Where do they get "blah"? Why? In the one case found, blah was the name
' of the HXT file.

Pt3 = InStrRev(HXTPath, "\")
sBaseNameHXT = Right(HXTPath, len(HXTPath) - Pt3)   'blah.hxt
sBaseNameHXT = Left(sBaseNameHXT, len(sBaseNameHXT) - 4)      'blah

TYPE_LINE = "<LI><OBJECT type=" & Q2 & "text/sitemap" & Q2 & ">"
s1 = Replace(s1, Chr(9), "")
s1 = Replace(s1, vbCr, "")
s1 = Replace(s1, vbLf, "")
A1 = Split(s1, ">")
UB = UBound(A1)
ReDim A2(UB + 10)
iDex = 0

              '1/2018 - fix screwed up HXT files with no title attributes.
TempBuildPath = TempFol
AddSlash TempBuildPath

s1 = "<!DOCTYPE HTML Public " & Q2 & "-//IETF//DTD HTML//EN" & Q2 & ">" & vbCrLf & "<HTML><HEAD><meta name=" & Q2 & "GENERATOR" & Q2 & " content=" & Q2 & "Microsoft&reg; HTML Help Workshop 4.1" & Q2 & ">"
A2(iDex) = s1: iDex = iDex + 1
s1 = "<!-- Sitemap 1.0 -->" & vbCrLf & "</HEAD><BODY>" & vbCrLf & "<OBJECT type=" & Q2 & "text/site properties" & Q2 & ">" & vbCrLf 
s1 = s1 &  "<param name=" & Q2 & "Background" & Q2 & " value=" & Q2 & "0x" & LCase(BackColor) & Q2 & ">" & vbCrLf 
s1 = s1 & "<param name=" & Q2 & "Foreground" & Q2 & " value=" & Q2 & "0x" & LCase(FontColor) & Q2 & ">" & vbCrLf 
s1 = s1 & "<param name=" & Q2 & "Window Styles" & Q2 & " value=" & Q2 & "0x800025" & Q2 & ">" & vbCrLf & "</OBJECT>" & vbCrLf & "<UL>" & vbCrLf
A2(iDex) = s1: iDex = iDex + 1

For i6 = 0 to UB
  s2 = A1(i6)  ' get line of help2 TOC.
  s2 = Trim(s2)
    If Len(s2) > 12 Then  
        Select Case Left(s2, 12)
            Case "<HelpTOCNode"
                   s3 = GetItemHXT(s2, TempBuildPath)
                 If Len(s3) > 0 Then
                     A2(iDex) = s3
                     iDex = iDex + 1
                 End If                 
            Case "</HelpTOCNod"
                 A2(iDex) = "</UL>" & vbCrLf
                 iDex = iDex + 1                
            Case Else
              '--
        End Select
   End If
 Next

ReDim Preserve A2(iDex)
A2(iDex) = "</UL></BODY></HTML>"
s1 = Join(A2, "")

s2 = Left(HXTPath, (len(HXTPath) - 4))
HHCPath = s2 & ".hhc"
HHCName = ""
Pt3 = InStrRev(s2, "\")
HHCName = Right(s2, (len(s2) - Pt3))

Fixer.FLWriteFile HHCPath, s1
 End Sub

  '-- Convert an HXT listing to an HHC listing. iType is 1 if this is an item, 2 if it's a header.
Function GetItemHXT(sLine, HXTFolPath)   '1/2018
  Dim Pt1, Pt2, sTitle, sURL, PtQ1, PtQ2, sPagePath, s8, BlankPath
    On Error Resume Next
    GetItemHXT = ""

      '   If Pt1 = 0 Then Exit Function
     ' this is rewritten 1/2018. The script56 HXS was found to have a
     ' corrupt HXT file in the Win7 SDK version. The HXT entires have
     ' no title attribute and some of them have corrupt path strings.
     ' So far it's only one case. The code below does two things:
     ' 1) if there's no titel it's retrieved from the webpage <TITLE> tag.
     ' otherwise the contents of the CHM would have no listings.
     ' 2) A check is made for corrupt paths that start with : "ms-help:"
     ' If found, those are cleaned up.
 
 Pt1 = InStr(1, sLine, "Title=", 1)
     If Pt1 = 0 Then  '-- no title. Microsoft breaks everything sooner or later.
         sTitle = "-"
     Else ' get the title if it's there. no quotes!
         PtQ1 = InStr(Pt1, sLine, Q2)
         PtQ2 = InStr(PtQ1 + 1, sLine, Q2)
         If PtQ1 > 0 And PtQ2 > (PtQ1 + 1) Then
            sTitle = Mid(sLine, PtQ1 + 1, ((PtQ2 - PtQ1) - 1))
         End If   
     End If    
       If Len(sTitle) = 0 Then sTitle = "-" 
       
    '-- get url ---This gets the full url with quotes from the HXT item, like: /html/webpagename.htm
        '-- if it's corrupted with ms-help:, as a few are, then it tries to clean that
        '-- up by looking for the HXT base file name and assuming that's the end of the junk
        '-- string.
    Pt2 = InStr(1, sLine, "Url=", 1)
      If Pt2 > 0 Then
         PtQ1 = InStr(Pt2, sLine, Q2)
         PtQ2 = InStr(PtQ1 + 1, sLine, Q2)
          sURL = Mid(sLine, PtQ1 + 1, ((PtQ2 - PtQ1) - 1))  'no quotes.
          sURL = Replace(sURL, "/", "\")
              '-- final url should be like html\webpage1.htm  
              '--  because that's how help workshop writes an HHC.
          If Left(sURL, 1) = "\" Then sURL = Right(sURL, len(sURL) - 1)         
           If Left(sURL, 8) = MSCrapString Then    'fix this one "ms-help:/../blah/realpath
              PtQ1 = InStr(1, sURL, sBaseNameHXT, 1)
              If PtQ1 > 0 Then 
                 PtQ2 = InStr(PtQ1, sURL, "\")
                 sURL = Right(sURL, len(sURL) - PtQ2)
              End If  
           End If  
     End If
       '--if there's no url it will be dealt with below.
       
'1/2018 - have to fish out the actual HTML topic file and get the <title> from the HTML
'-- if it wasn't in the HXT:

  If sTitle = "-" Then
      sPagePath = HXTFolPath & sURL 'local path to HTML page.
      s8 = Fixer.FLReadFile(sPagePath)
      PtQ1 = InStr(5, s8, "<TITLE>", 1)
      PtQ2 = InStr(PtQ1, s8, "</TITLE>", 1)
        If PtQ1 > 0 And PtQ2 > 0 Then
           sTitle = Mid(s8, (PtQ1 + 7), (PtQ2 - (PtQ1 + 7)))
        End If
  End If
  
 '-- now there should be a title and probably a URL -- ready to
'--  create the CHM item in the HHC file. But one more thing:
'-- Some heading topics don't have a page. The CHM then shows
'-- an IE 404 error page. For neatness, if there's no page then just
'-- write a page here and put the topic text in it.
  
  '-- only run this once per HXS: the first time a URL path is found.
  '-- assuming there's a relative URL to the pages, like "html\",
  '-- this gets it.
  
    If Len(sHTMLPath) = 0 And Len(sURL) > 5 Then     
       PtQ1 = InStrRev(sURL, "\")  '-- get the base path in case it's needed.
       sHTMLPath = Left(sURL, PtQ1)  'something like "html\" or "files\html\" etc. The relative path to the HTML files.         
    End If
    
  '-- if there's no URL but the HTML files location has been found, make a blank page.
   If Len(sURL) = 0 And Len(sHTMLPath) > 1 Then
       sURL = sHTMLPath & "blank_" & CStr(iBlankCount) & ".htm"  ' so this is like html/blank_0.htm
       iBlankCount = iBlankCount + 1
         '-- the full path to write the file: C:\windows\desktop\hxs files\temp1\html\blank_0.htm
       BlankPath = HXTFolPath & sURL    '-- make a path for writing the blank file.
       Fixer.FLWriteFile BlankPath, sBlankCode1 & sTitle & sBlankCode2 ' write a blank page with the title as a heading.
   End If 
      
 '-- finally, set up the HHC entry for this topic.
  
  GetItemHXT = TYPE_LINE & vbCrLf
  GetItemHXT = GetItemHXT & sParamName & sTitle & sParamEnd  ' <param name="Name" value=" & q2 & sTitle & q2 & ">" & vbcrlf
 If Len(sURL) > 0 Then
                        '  "<param name=" & Q2 & "Local" & Q2 & " value=" & Q2 & sURL & Q2 & ">" & vbCrLf & "</OBJECT>" & vbCrLf
    GetItemHXT = GetItemHXT & sParamLocal & sURL & sParamEnd & "</OBJECT>" & vbCrLf
 End If   
      If (Right(sLine, 1) <> "/") Then GetItemHXT = GetItemHXT & "<UL>" & vbCrLf
 End Function

'------------------------- end convert HXT to HHC -------------------------------------

'-- begin convert HXK(index) to HHK(index)   ----------------------------------------------------------
Sub ConvertHXKtoHHK()
Dim Pt3, i5
  s1 = Fixer.FLReadFile(HXKPath) 
Q2 = Q2 
TYPE_LINE = "<LI><OBJECT type=" & Q2 & "text/sitemap" & Q2 & ">"
s1 = Replace(s1, Chr(9), "")
s1 = Replace(s1, vbCr, "")
s1 = Replace(s1, vbLf, "")
A1 = Split(s1, ">")
UB = UBound(A1)
ReDim A2(UB + 10)
iDex = 0

s1 = "<HTML>" & vbCrLf & "<!-- Sitemap 1.0 -->" & vbCrLf & "<OBJECT type=" & Q2 & "text/site properties" & Q2 & ">" & vbCrLf & "</OBJECT>" & vbCrLf & "<UL>"
A2(iDex) = s1: iDex = iDex + 1

For i5 = 0 to UB
  s2 = A1(i5)  ' get line of help2 TOC.
  s2 = Trim(s2)
    If Len(s2) > 8 Then  
        Select Case Left(s2, 8)
           Case "<Keyword"
              If InStr(1, s2, "Term=" & Q2 & "described") = 0 Then
                 s3 = A1(i5 + 1)
                 s3 = Trim(s3)
                   If Left(s3, 5) = "<Jump" Then
                       s4 = GetItemHXK(s2, s3)
                        If Len(s4) > 0 Then
                          A2(iDex) = s4
                          iDex = iDex + 1
                        End If  
                    End If
                End If   
            
           Case Else
              '--
        End Select
   End If
 Next

ReDim Preserve A2(iDex)
A2(iDex) = "</UL></HTML>"
s1 = Join(A2, vbCrLf)

s2 = Left(HXKPath, (len(HXKPath) - 4))
HHKPath = s2 & ".hhk"
Pt3 = InStrRev(s2, "\")
HHKName = Right(s2, (len(s2) - Pt3))

 Fixer.FLWriteFile HHKPath, s1
End Sub

  '-- Convert an HXK listing to an HHK listing. 
 Function GetItemHXK(sKey, sJump)
   Dim Pt1, Pt2, sTitle, sURL
    On Error Resume Next
    GetItemHXK = ""
    Pt1 = InStr(1, sKey, Q2)
      If Pt1 > 0 Then Pt2 = InStr(Pt1 + 1, sKey, Q2)
      If Pt2 > 0 Then sTitle = Mid(sKey, Pt1, ((Pt2 - Pt1) + 1))
    Pt1 = InStr(1, sJump, Q2)
      If Pt1 > 0 Then Pt2 = InStr(Pt1 + 1, sJump, Q2)
      If Pt2 > 0 Then sURL = Mid(sJump, Pt1, ((Pt2 - Pt1) + 1))
                If Len(sTitle) = 0 Or Len(sURL) = 0 Then Exit Function    
      If Left(sURL, 2) = Q2 & "/" Then sURL = Q2 & Right(sURL, (len(sURL) - 2))
   GetItemHXK = TYPE_LINE & vbCrLf
   GetItemHXK = GetItemHXK & "<param name=" & Q2 & "Name" & Q2 & " value=" & sTitle & ">" & vbCrLf
   GetItemHXK = GetItemHXK & "<param name=" & Q2 & "Local" & Q2 & " value=" & sURL & ">" & vbCrLf & "</OBJECT>" & vbCrLf
 End Function

'-------------------------- get HHK from HHC if no HXK file present. ------------------

Sub HHKFromHHC()
Dim Pt3, i7
  s1 = Fixer.FLReadFile(HHCPath) 
TYPE_LINE = "<LI><OBJECT type=" & Q2 & "text/sitemap" & Q2 & ">"
s1 = Replace(s1, Chr(9), "")
A1 = Split(s1, vbCrLf)
UB = UBound(A1)
ReDim A2(UB + 10)
iDex = 0

s1 = "<HTML>" & vbCrLf & "<!-- Sitemap 1.0 -->" & vbCrLf & "<OBJECT type=" & Q2 & "text/site properties" & Q2 & ">" & vbCrLf & "</OBJECT>" & vbCrLf & "<UL>" & vbCrLf
A2(iDex) = s1: iDex = iDex + 1

PAR_LINE1 = "<param name=" & Q2 & "Name"
PAR_LINE2 = "<param name=" & Q2 & "Loca"

For i7 = 0 to UB
  s2 = A1(i7)  ' get line of help TOC.
    If Len(s2) > 17 Then  
        Select Case Left(s2, 17)
           Case PAR_LINE1
              s3 = A1(i7 + 1)
                If Len(s3) > 17 Then
                   If Left(s3, 17) = PAR_LINE2 Then
                        s4 = GetItemHHCtoHHK(s2, s3)
                        If Len(s4) > 0 Then
                          A2(iDex) = s4
                          iDex = iDex + 1
                        End If  
                  End If
                End If        
            Case Else
              '--
        End Select
   End If
 Next

ReDim Preserve A2(iDex)
A2(iDex) = "</UL></HTML>"
s1 = Join(A2, "")

s2 = Left(HHCPath, (len(HHCPath) - 4))
HHKPath = s2 & ".hhk"
Pt3 = InStrRev(s2, "\")
HHKName = Right(s2, (len(s2) - Pt3))

  Fixer.FLWriteFile HHKPath, s1
End Sub

  '-- Convert an HHC listing to an HHK listing. 
 Function GetItemHHCtoHHK(sKey, sJump)
   Dim Pt1, Pt2, sTitle, sURL
   On Error Resume Next
    GetItemHHCtoHHK = ""
    Pt1 = InStr(1, sKey, "value=")
    Pt1 = Pt1 + 6
      If Pt1 > 6 Then Pt2 = InStr(Pt1 + 1, sKey, Q2)
      If Pt2 > 0 Then sTitle = Mid(sKey, Pt1, ((Pt2 - Pt1) + 1))
    Pt1 = InStr(1, sJump, "value=")
     If Pt1 > 0 Then
        Pt1 = Pt1 + 6
        Pt2 = InStr(Pt1 + 1, sJump, Q2)
       If Pt2 > 0 Then sURL = Mid(sJump, Pt1, ((Pt2 - Pt1) + 1))
    End If   

      If Len(sTitle) = 0 Or Len(sURL) = 0 Then Exit Function   
      sURL = Replace(sURL, "\", "/")  '-- strange design here. A TOC file uses file system paths, but an index file uses web paths. So if an index is derived from a TOC that must be adjusted. 
   
   GetItemHHCtoHHK = TYPE_LINE & vbCrLf
   GetItemHHCtoHHK = GetItemHHCtoHHK & "<param name=" & Q2 & "Name" & Q2 & " value=" & sTitle & ">" & vbCrLf
   GetItemHHCtoHHK = GetItemHHCtoHHK & "<param name=" & Q2 & "Local" & Q2 & " value=" & sURL & ">" & vbCrLf & "</OBJECT>" & vbCrLf
 End Function

'---------------------- end convert HXK to HHK index file ---------------------------------------------------------

'--------------- parse HXC file to get title, if desired. -----------------------------------

Sub ParseHXC()
 Dim s7, A7, i7, Pt71, Pt72
 On Error Resume Next
     If FSO.FileExists(HXCPath) = False Then Exit Sub
    s7 = Fixer.FLReadFile(HXCPath)
    s7 = Replace(s7, Chr(9), "")
  A7 = Split(s7, vbCrLf)
  For i7 = 0 to UBound(A7)
    s7 = A7(i7)
    s7 = Trim(s7)
    If Len(s7) > 10 Then
       If UCase(left(s7, 5)) = "TITLE" Then
          Pt71 = InStr(1, s7, Q2)
          Pt72 = InStr((Pt71 + 1), s7, Q2)
          If Pt72 > (Pt71 + 2) Then CHMTitle = Mid(s7, (Pt71 + 1), ((Pt72 - Pt71) - 1))
          Exit For
       End If
     End If
  Next   
    If Len(CHMTitle) > 0 Then
      CHMTitle = Replace(CHMTitle, Q2, "")
      CHMTitle = Replace(CHMTitle, "?", "")
      CHMTitle = Replace(CHMTitle, "<", "")
      CHMTitle = Replace(CHMTitle, ">", "")
      CHMTitle = Replace(CHMTitle, "/", "-")
      CHMTitle = Replace(CHMTitle, "\", "-")
      CHMTitle = Replace(CHMTitle, ":", "-")
      CHMTitle = Replace(CHMTitle, "*", "")
    End If  
End Sub

'-- Create of HHP project file from HHC ----------------------------------
'-- This sub includes getting a list of files in the package. Therefore, the job of fixing the Help2 links
'-- is also done in this sub, since the list will be handy.

Sub CreateHHP()
  Dim sExt2
  sWebFiles = ""
       '-- this is all added to deal with the problem of extra lobng folder names in some help2 projects.
     FolsCount = 0
     sFolNameShort = "vkq_z"
     ReDim AFolPathsLong(400)
     ReDim AFolPathsShort(400)
   
 RepairFolderTree    '--fix extra long foldernames.
  
  Set oFol = FSO.GetFolder(TempFol)
    Set oFols = oFol.SubFolders
       For Each oFol1 in oFols
         If Left(oFol1.Name, 1) <> "$" Then
           sWebFiles = sWebFiles & GetFileList(oFol1.Path, oFol1.Name)  '-- get file names/paths in any folders with names that don't start with $.
         End If   
      Next
   Set oFols = Nothing
   
     '-- usually the webpage files are in subfolders, but sometimes they're just loose inside the HXS. This next part deals with that possibility.
     '-- Note that the paths are critical here. The HHC, HHK and HHP file paths must all match the actual file paths on disk or the help compiler won't find the files.
     '-- The symptom of that problem is that the CHM compiles but all links in the file yield IE 404 pages.
     
   Set oFils = oFol.Files
     For Each oFil in oFils
        If Len(oFil.name) > 5 Then
          sExt2 = UCase(Right(oFil.Name, 3))
          If sExt2 = "HTM" Or sExt2 = "JPG" Or sExt2 = "GIF" Or sExt2 = "CSS" Or  sExt2 = "PNG" Or sExt2 = "HTC" Or sExt2 = ".JS" Then
            sWebFiles = sWebFiles & oFil.name & vbCrLf
          End If  
       End If
     Next
   Set oFils = Nothing     
Set oFol = Nothing   

GetDefFile(sWebFiles)   '-- set path of default file that shows when help is opened.

If Len(CHMTitle) > 0 Then 
   CHMName = CHMTitle & ".chm"
   CHIName = CHMTitle & ".chi"
   CHMPath = TempFol & "\" & CHMTitle & ".chm"
   CHIPath = TempFol & "\" & CHMTitle & ".chi"
   CHMTitleBarTitle = CHMTitle
Else   
   CHMName = HHCName & ".chm"
   CHIName = HHCName & ".chi"
   CHMPath = TempFol & "\" & HHCName & ".chm"
   CHIPath = TempFol & "\" & HHCName & ".chi"
   CHMTitleBarTitle = HHCName
End If   

'-- build the HHP file using necessary info. like HHC name, HHK name, etc.
s1 = "[OPTIONS]" & vbCrLf & "Compatibility=1.1 Or later" & vbCrLf & "Compiled file=" & CHMName & vbCrLf & "Contents file=" & HHCName & ".hhc" & vbCrLf
   If BooCreateCHI = True Then
      s1 = s1 & "Create CHI file=Yes" & vbCrLf
   Else
      s1 = s1 & "Create CHI file=No" & vbCrLf  
   End If  
s1 = s1 & "Default topic=" & DefFile & vbCrLf & "Default Window=Favorites" & vbCrLf & "Index file=" & HHKName & ".hhk" & vbCrLf  & "Display compile progress=No" & vbCrLf & "Full-text search=Yes" & vbCrLf 
s1 = s1 & "Language=0x409 English (United States)" & vbCrLf & "Title=" & CHMTitleBarTitle & vbCrLf & vbCrLf 

s1 = s1 & "[WINDOWS]" & vbCrLf & "Favorites=," & Q2 & HHCName & ".hhc" & Q2 & "," & Q2 & HHKName & ".hhk" & Q2  'Favorites=,contents file,index file
s1 = s1 & "," & Q2 & DefFile & Q2 & ",,,,,,0x43520,,0x3006,,,,,,,,0" & vbCrLf & vbCrLf

s1 = s1 &  "[FILES]" & vbCrLf & sWebFiles & vbCrLf & vbCrLf & "[INFOTYPES]" & vbCrLf
HHPPath = TempFol & "\" & HHCName & ".hhp"

' write HHP file to disk.
  Fixer.FLWriteFile HHPPath, s1
End Sub

'---------- fixes extra long folder names in folder tree before proceeding. This sub processes all top-level folders that don't have $ in their name.
Sub RepairFolderTree()
  On Error Resume Next
   Set oFol = FSO.GetFolder(TempFol)
     Set oFols = oFol.SubFolders
       For Each oFol1 in oFols
         If Left(oFol1.Name, 1) <> "$" Then
           RepairFolderTreeHelper oFol1.Path
         End If   
      Next
     Set oFols = Nothing
   Set oFol = Nothing
       '-- resize folder path arrays, or erase arrays if not used.
    If FolsCount > 0 Then
       ReDim Preserve AFolPathsLong(FolsCount - 1)
       ReDim Preserve AFolPathsShort(FolsCount - 1)
    Else
       Erase AFolPathsLong
       Erase AFolPathsShort
    End If
End Sub

  '-- Called for each top-level folder. (Usually that's just 1.) This sub is recursive, creating shortened folder names for any folder/subfolder with a name length greater that 16 characters.
Sub RepairFolderTreeHelper(sFolder)
  Dim oFols2, oFol2, oFol3, sPath3
    On Error Resume Next
    Set oFol2 = FSO.GetFolder(sFolder)
      If Len(oFol2.name) > 16 Then 
         FolsCount = FolsCount + 1
         sPath3 = Right(oFol2.path, (len(oFol2.path) - LenTempPath))  '-- save \files\foldercrazylengthnameishere\
         AFolPathsLong(FolsCount) = sPath3 & "\" '1/2018
         oFol2.Name = sFolNameShort & CStr(FolsCount)
         sPath3 = Right(oFol2.path, (len(oFol2.path) - LenTempPath)) '-- save files\vk3dqq7s1\  
         AFolPathsShort(FolsCount) = sPath3 & "\" '1/2018"  
      End If   
     Set oFols2 = oFol2.SubFolders
       For Each oFol3 in oFols2
             RepairFolderTreeHelper oFol3.Path
       Next
     Set oFols2 = Nothing
   Set oFol2 = Nothing
End Sub

  '-- if there are problematically long folder names they've been changed.
  '-- In that case, this sub will update the contents and index files.
  '-- This can't be done at the outset because the HHC and HHK files must first be created from the HXT/HXK files.
Sub EditFolderPaths()
  Dim sFil3, i10, sPathL, sPathS
    sFil3 = Fixer.FLReadFile(HHCPath)
    For i10 = 0 to FolsCount - 1
      sPathL = AFolPathsLong(i10)
      sPathS = AFolPathsShort(i10)
       sFil3 = Replace(sFil3, sPathL, sPathS, 1, -1, 1)
    Next
    Fixer.FLWriteFile HHCPath, sFil3  
    
   sFil3 = Fixer.FLReadFile(HHKPath)
    For i10 = 0 to FolsCount - 1
      sPathL = AFolPathsLong(i10)
      sPathS = AFolPathsShort(i10)
      sFil3 = Replace(sFil3, sPathL, sPathS, 1, -1, 1)
    Next
    Fixer.FLWriteFile HHKPath, sFil3     
End Sub

'-- This function recurses folders with names that don't start with $. It creates a list of files for the HHP that includes
'-- the relative path of files. This is called after folder names have been fixed, so the HHP file will not need to be updated. 
' Example: An HXS contains a folder named "html" that contains a folder named "images". Those contain the HTM files and GIF files, respectively.
' To successfully build a CHM, the HHC and HHK must both list the file paths accurately, like "html\page1.htm", "html\images\pic1.gif", etc.
' That info comes from the the HXT (and maybe the HXK) file. It should match the file hierarchy as it was unpacked by 7-Zip.
' Assuming that worked out, GetFileList can create a list of all files for the HHP file that has the same accurate relative paths.

Function GetFileList(FolPath, ParFolList)
  Dim SubPath, oFols2, sList, oFol2, oFol3, oFils2, oFil2, ParFol1
    Set oFol2 = FSO.GetFolder(FolPath)
    Set oFils2 = oFol2.Files
      If oFils2.count > 0 Then
         For Each oFil2 in oFils2
            GetFileList = GetFileList & ParFolList & "\" & oFil2.Name & vbCrLf
         Next   
      End If
     
   Set oFols2 = oFol2.SubFolders
        If oFols2.count > 0 Then
            For Each oFol3 in oFols2
               SubPath = oFol3.Path
               ParFol1 = ParFolList & "\" & oFol3.Name
               sList = GetFileList(SubPath, ParFol1)
                GetFileList = GetFileList & sList
            Next
         End If    
    Set oFols2 = Nothing
    Set oFils2 = Nothing
    Set oFol2 = Nothing    
End Function

'-- find the first HTM file in file list to show when CHM opens.
'-- HXS files don't seem to list a default topic file. This does not always return the first topic, but it will at least
'-- return some sort of valid path so that the CHM doesn't open to a browser error window.
Sub GetDefFile(FileList)
 Dim AList, i8, s8
   On Error Resume Next
AList = Split(FileList, vbCrLf)
  For i8 = 0 to UBound(AList)
    s8 = AList(i8)
    If (Len(s8) > 5) Then
       If (UCase(right(s8, 4)) = ".HTM") And (InStr(1, s8, "badjump", 1) = 0) Then
          DefFile = s8
          Exit For
       End If
    End If
  Next
End Sub

Sub UnZipHXS(sCom)
  Dim Ret, Pt4, ScrPath
   On Error Resume Next
    ScrPath = WScript.ScriptFullName
      Pt4 = InStrRev(ScrPath, "\")
    ScrPath = Left(ScrPath, Pt4) & "zip7.vbs"
    SH.run Q2 & ScrPath & Q2 &  " " & Q2 & sCom & Q2, , True
End Sub

Private Sub AddSlash(sPathIn)
  On Error Resume Next
   If Right(sPathIn, 1) <> "\" Then sPathIn = sPathIn & "\"
 End Sub


'---------------------------------------------------- END -------------------------------------------------
Sub DropIt(sMsg)
  On Error Resume Next
  Set SH = Nothing
  MsgBox sMsg, 64, "Convert HXS to CHM"
   If Len(sLog) > 0 Then
      Fixer.FLWriteFile ParFol & "\Conversion Log.txt", sLog
   End If
  WScript.sleep 4000    ' pause before trying to delete folders.
  
  If BooDeleteTemp = True Then 
     If FSO.FolderExists(ParFol & "\Temp1") Then FSO.DeleteFolder ParFol & "\Temp1", True
     If FSO.FolderExists(ParFol & "\Temp2") Then FSO.DeleteFolder ParFol & "\Temp2", True
  End If
   Set Fixer = Nothing
  Set FSO = Nothing
  WScript.quit
End Sub  








'--------------------- extra for version 2. The class below handles fixing the strange MSHelp:link tags in Help2.
'-- it also holds file IO functions, etc. This class isn't really necessary. It was written originally to separate out the MSHelp functions.
'-- If, for any reason, you decide to eliminate this class, be careful to avoid mixing variable names. This class mainly uses variable
'-- names with underscores to avoid clashing with the global variables in the script.

'============================= BEGIN CLASS FixLinks =====================================================
Class FixLinks

   Private  FSO_, TS_, sPath_, oFol_, oFol2_, oFols_, oFils_, oFil_, AFils_, LnkPath_, i3_, UB2_
   Private DicKeys
   Private ParPath_  'send in full parent path to append to relative paths for accessing files.
Private Sub Class_Initialize()
  Set FSO_ = CreateObject("Scripting.FileSystemObject")
  Set DicKeys = CreateObject("Scripting.Dictionary")
End Sub

Private Sub Class_Terminate()
  Set FSO_ = Nothing
  Set DicKeys = Nothing
End Sub

Public Property Let ParentPath(sPath_)
  ParPath_ = sPath_
End Property

'-- call this with file list, but first assign parent path, which must be the first part of full path. Maybe TempFol & "\"?
Public Sub ProcessLinksForCHM(sFilesList)
    Dim sFil1
  AFils_ = Split(sFilesList, vbCrLf)
  UB2_ = UBound(AFils_)

   If Verbose = True Then MsgBox "Beginning processing of web files for CHM. Total files to process: " & CStr(UB2_ + 1)
   
    For i3_ = 0 to UB2_
      sFil1 = AFils_(i3_)
      If UCase(Right(sFil1, 4)) = ".HTM" Then FLProcessFile sFil1, 1
    Next

'-- At this point the only major job left is replacing the MSHelp links, but that's a big job.
    If Verbose = True Then MsgBox "Beginning phase 2 with web files for CHM -- replacing MSHelp links with normal links. Total files to process: " & CStr(UB2_ + 1)
    
  For i3_ = 0 to UB2_
     sFil1 = AFils_(i3_)
     If UCase(Right(sFil1, 4)) = ".HTM" Then FLProcessFile sFil1, 2
  Next
  
  DicKeys.RemoveAll
End Sub

Private Sub FLProcessFile(sPath_, Phase)
  Dim s1_, s2_, s3_, sDisp, LenDisp, Pt1_, Pt2_, Pt3_, Pt4_, sMid, sKey, i2_, i4_, sLnk, UBTemp, sUCase
    s1_ = FLReadFile(ParPath_ & sPath_)
    Pt2_ = 1
    
       If Phase = 1 Then
          sUCase = UCase(s1_)
          Pt1_ = InStr(Pt2_, sUCase, cHAID)
                If Pt1_ = 0 Then   '-- in some cases there may be MSHelp links but no MS-HAID. In that case it seems the file base name is usually (always?) the keyword.
                  On Error Resume Next
                   Pt4_ = InStrRev(sPath_, "\")
                   s2_ = right(sPath_, (Len(sPath_) - Pt4_))
                   If DicKeys.exists(Left(s2_, (Len(s2_) - 4))) = False Then DicKeys.add Left(s2_, (Len(s2_) - 4)), Replace(sPath_, "\", "/")    
                   Exit Sub
                End If
          Pt2_ = InStr(Pt1_ + 6, sUCase, "CONTENT=")  '-- find content=   equal sign.
                If Pt2_ = 0 Then Exit Sub
                If (Pt2_ - Pt1_) > 40 Then Exit Sub
          Pt2_ = Pt2_ + 9
          Pt1_ = InStr(Pt2_, s1_, Q2)
             If (Pt1_ > Pt2_) And (Pt1_ < (Pt2_ + 260)) Then
                DicKeys.add Mid(s1_, Pt2_, (Pt1_ - Pt2_)), Replace(sPath_, "\", "/")     
             End If  
             '-- explanation: HTM file has something like this: <META NAME="MS-HAID" CONTENT="_inet_document_Object_scr">
             '-- _inet_document_Object_scr is the keyword for the page, appearing in MSHELP:link tags within other pages. When the
             '-- HXS is converted to CHM those type of links are nonsense. So this function puts the keyword and relative path  
             '-- into DicKeys. In phase 2, anywhere in a page where that keyword is found, the valid path can be substituted.
             '-- This operation adds significant time to the conversion process. Worse, the MSHelp system is poorly designed
             '-- and quirky. Most files with MSHelp links seem to have an MS-HAID meta tag, but not all. So all files have to be processed.
             '-- if no MS-HAID is found then the file base name is used as the keyword. That seems to work, at least in all files tested.
       Exit Sub
       
    Else  ' second phase: go through files again and fix links.
      '-- optional ops to clean inline display:none and script.
 
          If Len(CustomStyleBlock) > 0 Then s1_ = AddCustomStyle(s1_)
          
           If CleanScriptMess = True Then
              s1_ = CleanFile(s1_) 
              sUCase = UCase(s1_)   
           Else
             sUCase = UCase(s1_)   
           End If
           
  '-- This is the time-consuming function to replace MSHelp link tags with normal A tags. With each tag the keyword must be retrieved and checked 
  '-- against DicKeys, which will probably have a number of keys matching the number of files in project, if MSHelp links are used. That comparison
  '-- is fairly quick, but it adds up when there are perhaps 50000 links and 10000 webpages (as in the Inet.hxs file). However, the bigger job is
  '-- parsing each file. The file must be rebuilt by getting each MSHelp link and replacing it with a working A link, while retaining the surrounding text.
  
  '-- This code may seem clunky and overdone. It optimizes by 1) using a UCase string (to avoid case-insensitive Instr searches) and 2) building the file 
  '-- string by using an array with Join rather than just plain string concatenation. The result looks bulky and inefficient, but it is actually vastly faster 
  '-- than the basic, most obvious method. In a simple test, a 200+-KB file was processed without the key search operation, just processing the MSHelp
  '-- links. Typical string operations resulted in a run of 5.4 seconds. By adding the array method of concatenation that time was cut to 4.8 seconds.
  '-- By then adding the UCase string method, and optimizing the search to produce less strings altogether, the time was cut to 23 milliseconds!
  
     ReDim ATemp(100)
     UBTemp = 100
     i4_ = 0
   
         Do
           If i4_ > UBTemp - 4 Then 
              UBTemp = UBTemp + 100
              ReDim Preserve ATemp(UBTemp)
           End If  
           Pt1_ = InStr(Pt2_, sUCase, "<MSHELP:LINK")
               If Pt1_ = 0 Then Exit Do
             ATemp(i4_) = Mid(s1_, Pt2_, (Pt1_ - Pt2_)): i4_ = i4_ + 1
           Pt2_ = InStr(Pt1_ + 7, sUCase, "</MSHELP")  ' set Pt2_ as character following </MSHelp:link>
                 If Pt2_ = 0 Then Exit Do
              Pt2_ = Pt2_ + 14
           Pt3_ = InStr(Pt1_, sUCase, "KEYWORDS")
             If (Pt3_ > 0) And (Pt3_ < Pt2_) Then 
                 Pt3_ = Pt3_ + 10
                 Pt4_ = InStr(Pt3_, sUCase, Q2)
                 sKey = Mid(s1_, Pt3_, (Pt4_ - Pt3_))  'this is now keyword.
                 Pt1_ = InStr(Pt4_, sUCase, ">")   ' find first char. of visible link text:  keywords="keys">click here<...etc.
                 Pt4_ = InStr(Pt1_, sUCase, "<")
                  If Pt4_ > (Pt1_ + 1) Then
                      If DicKeys.exists(sKey) Then      
                          ATemp(i4_) = "<A HREF=" & Q2 & DicKeys.item(sKey) & Q2 & ">" & Mid(s1_, (Pt1_ + 1), (Pt4_ - Pt1_) - 1) & "</A>"   ' replace the bad link, if possible.
                      Else
                          ATemp(i4_) = Mid(s1_, (Pt1_ + 1), (Pt4_ - Pt1_) - 1)  '  If not then possible to replace the bad link then delete it and just leave the link text.  
                      End If
                    i4_ = i4_ + 1     
                  End If  
               End If           
                If Pt2_ >= Len(s1_) Then Exit Do    
            '-- loop now resumes at Pt2_ 
         Loop
     
       If Pt2_ < Len(s1_) Then
          ATemp(i4_) = Right(s1_, (len(s1_) - Pt2_) + 1): i4_ = i4_ + 1
       End If  
         
'-- write the edited file back to disk.
      s2_ = Join(ATemp, "")
      FLWriteFile ParPath_ & sPath_, s2_   
    End If   
    
End Sub

'-- optional ops to clean script and inline display:none from pages.  --------------------------
'-- if script is removed then display:none must be removed because the two are used to change scrolling DIV content.
'--    CleanFile is an optional operation that does Not seem to be necessary. It was originally written to
    '--   deal with crashes in the CHM compiler on some Help2 projects. The function cleans script/XML/META junk from all .htm
    '--   files, and adjusts the STYLE settings accordingly. However, it turned out that the problem of CHM compiler crashes was
    '--   actually due not to irregular .htm code but rather was due to excessiveky long folder names. So there should be no need
    '-- to use CleanFile, but it's been left in just in case.
Private Function CleanFile(sFilText)
  Dim sNew2_, sNew3_, sDisp, LenDisp, Pt1_, Pt2_, Pt3_, Pt5_, Pt6_, Pt7_, UBTemp, i4_, sUCase   
      ReDim ATemp(100)
      UBTemp = 100
       i4_ = 0   
       Pt2_ = 1
       sUCase = UCase(sFilText)
        
      Do  '-- strip out SCRIPT tags.
           If i4_ > UBTemp - 4 Then 
              UBTemp = UBTemp + 100
              ReDim Preserve ATemp(UBTemp)
           End If  

           Pt1_ = InStr(Pt2_, sUCase, "<SCRIPT")
                If Pt1_ = 0 Then Exit Do
             ATemp(i4_) = Mid(sFilText, Pt2_, (Pt1_ - Pt2_)): i4_ = i4_ + 1
           Pt2_ = InStr(Pt1_ + 1, sUCase, "</SCRIPT>")
              If Pt2_ = 0 Then Exit Do
           Pt2_ = Pt2_ + 9   
           If Pt2 >= Len(sFilText) Then Exit Do  
     Loop 
     
     If Pt2_ < Len(sFilText) Then
          ATemp(i4_) = Right(sFilText, (len(sFilText) - Pt2_) + 1): i4_ = i4_ + 1
     End If  

  sNew2_ = Join(ATemp, "")
    ReDim ATemp(100)
    UBTemp = 100
    i4_ = 0   
  sUCase = UCase(sNew2_)
  
Pt1_ = 1
    Do '-- strip out inline script calls like <BODY onload="someop()"
       If i4_ > UBTemp - 10 Then 
            UBTemp = UBTemp + 100
            ReDim Preserve ATemp(UBTemp)
       End If  

       Pt2_ = InStr(Pt1_, sNew2_, "<")
           If Pt2_ = 0 Then Exit Do
       Pt3_ = InStr(Pt2_, sNew2_, ">")
            If Pt3_ = 0 Then Exit Do
       Pt7_ = Pt2_
        Do             
           Pt6_  = InStr(Pt7_, sUCase, " ON")
             If (Pt6_ < Pt3_) And (Pt6_ > 0) Then
                  If Pt6_ > Pt1_ Then  
                      ATemp(i4_) =  Mid(sNew2_, Pt1_, (Pt6_ - Pt1_)): i4_ = i4_ + 1   '--needs to check that there's text to add. Ex.: onmouseout="doit()" onkeyup="doit()" When second " on" is found there's no new text to add.
                  End If 
                   Pt5_ = InStr(Pt6_ + 2, sNew2_, " ")
                    If (Pt5_ < Pt3_) And (Pt5_ > 0) Then 'another space in tag.
                       Pt1_ = Pt5_   'start next block at following space in tag.
                       Pt7_ = Pt5_
                    Else
                       Pt1_ = Pt3_    ' start next block at closing >.
                       Exit Do
                    End If    
              Else
                 ATemp(i4_) =  Mid(sNew2_, Pt1_, (Pt3_ - Pt1_) + 1): i4_ = i4_ + 1
                 Pt1_ = Pt3_ + 1   
                 Exit Do
              End If    
         Loop
         
       If Pt1_ >= Len(sNew2_) Then Exit Do
     Loop 
     
     If Pt1_ < Len(sNew2_) Then
          ATemp(i4_) =  Right(sNew2_, (len(sNew2_) - Pt1_) + 1): i4_ = i4_ + 1
     End If  

   sNew3_ = Join(ATemp, "")

   ReDim ATemp(100)
    UBTemp = 100
    i4_ = 0   
    sUCase = UCase(sNew3_)  
    Pt2_ = 1
    sDisp = "STYLE=" & Q2 & "DISPLAY"
   Do  '-- strip out any CSS display:none.
        If i4_ > UBTemp - 4 Then 
            UBTemp = UBTemp + 100
            ReDim Preserve ATemp(UBTemp)
       End If  

      Pt1_ = InStr(Pt2_, sUCase, sDisp)
            If Pt1_ = 0 Then Exit Do
      Pt5_ =  InStr(Pt1_ + 9, sUCase, Q2)
      Pt6_ = InStr(Pt1_, sUCase, "NONE")
        If (Pt6_ > 0) And (Pt6_ < Pt5_) Then
             LenDisp = 0
            If Mid(sNew3_, Pt5_ + 1, 1) = " " Then   'drop spaces after STYLE attr.
               LenDisp = (Pt5_ - Pt1_) + 2
            Else
               LenDisp = (Pt5_ - Pt1_) + 1
            End If 
            If Mid(sNew3_, Pt1_ - 1, 1) = " " Then   'drop spaces before STYLE attr.
               LenDisp = LenDisp + 1
               Pt1_ = Pt1_ - 1
            End If   
              ATemp(i4_) = Mid(sNew3_, Pt2_, (Pt1_ - Pt2_)): i4_ = i4_ + 1
              Pt2_ = Pt1_ + LenDisp   
             
        Else  '-- no tag to drop, but must avoid a loop, so take part of this tag.
           ATemp(i4_) = Mid(sNew3_, Pt2_, (Pt1_ - Pt2_) + 10): i4_ = i4_ + 1
           Pt2_ = Pt1_ + 10   
        End If     
         
           If Pt2_ >= Len(sNew3_) Then Exit Do 
     Loop
     
       If Pt2_ < Len(sNew3_) Then
          ATemp(i4_) = Right(sNew3_, (len(sNew3_) - Pt2_) + 1): i4_ = i4_ + 1  
       End If  
  
  CleanFile = Join(ATemp, "")
End Function

Private Function AddCustomStyle(sFilText)
  Dim Pt1_, Pt2_
     ' If Len(CustomStyleBlock) = 0 Then AddCustomStyle = sFilText: Exit Function
   Pt1_ = InStr(1, sFilText, "</HEAD", 1)
     If Pt1_ > 0 Then
        AddCustomStyle = Left(sFilText, (Pt1_ - 1)) & CustomStyleBlock & Right(sFilText, (len(sFilText) - (Pt1_ - 1)))  
     Else
        AddCustomStyle = sFilText   
     End If   
End Function

Public Function FLReadFile(Path)
  Set TS_ = FSO_.OpenTextFile(Path, 1)
    FLReadFile = TS_.ReadAll
    TS_.Close
  Set TS_ = Nothing
End Function

Public Sub FLWriteFile(Path, sContent)
  Set TS_ = FSO_.CreateTextFile(Path, True)
    TS_.Write sContent
    TS_.Close
  Set TS_ = Nothing
End Sub

End Class
