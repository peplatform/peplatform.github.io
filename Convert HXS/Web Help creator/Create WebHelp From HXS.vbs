
'-- Drop a folder onto this script. All HXS help files will be processed and an HTA viewer with index will be produced.
'-- This script does not use the contents or index files in the HXS. Instead, in order to get better index captions for topics,
'-- it uses the HTML TITLE tag content of each page for the index caption.
'-- The script just walks all folders with HTML content, from all unpacked HXS files, adds their title/path to the viewer index,
'-- and, if necessary, fixes any MSHelp links.
'-- The script also starts out by checking for extra-long folder names that may cause IE to freeze.
'-- (See more detailed explanation above the "main loop" section below.

'-- Notes: 

   '  *  7-Zip must be installed. See the settings below to set their paths before using the script.
   '  *  This script cannot process an external HXI index file. If the HXS file has no internal index (an HXK file) then an index will be generated from the HXT (TOC) file.
   
Dim FSO, SH, oFol, oFils, oFil, oFols, TS
Dim iFolCount, iRenamedFolCount, sFolPath, sFolNameShort
Dim iCount1, iCount2, Q2, s1, s2, s3, i2, i3, i4, i5, BooRet, sLog, Ret, PtA
Dim SevZip, ParFol, TempFol, DestFol, ThisFol
Dim DexFil
Dim AFils(), ANames(), ATemp(), AHTML(37)
Dim ATitles(), APaths(), ALines()   'title and full path of each htm file.
Dim iPages, TotalPages 'total webpages/topics.
Dim DicKeys
Dim cHAID
Dim IndexWidthPix '-- width of left-side scrolling index.
Dim DatFile   '-- wordlist.dat file to be used for index.

'-- =============== SETTINGS ==========================================

    '-----  THIS PROGRAM MUST BE INSTALLED FOR UNPACKING HXS FILES.    -------------------------

SevZip =  "C:\Program Files\7-Zip\7z.exe"

IndexWidthPix = "300"  '-- width of left-side index.


'-=============== END SETTINGS ========================================

 Q2 = Chr(34)
 iRenamedFolCount = 0
 sFolNameShort = "vkw_z"
 cHAID = "NAME=" & Q2 & "MS-HAID"


On Error Resume Next

ParFol = WScript.Arguments(0)

Set FSO = CreateObject("Scripting.FileSystemObject")
Set DicKeys = CreateObject("Scripting.Dictionary")

If (FSO.FileExists(SevZip) = False) Then
  DropIt "Error. Before using this script you must have 7-Zip installed. Then hardcode the Path in the Settings section at the top of this script. Script will now quit."
End If

Set SH = CreateObject("WScript.Shell")

  If FSO.FolderExists(ParFol) = False Then 
    ParFol = InputBox("Enter the full path of the folder containing HXS files.")
  End If
  If FSO.FolderExists(ParFol) = False Then 
     DropIt "Error. To use this script you must drop a folder onto it that contains 1 or more HXS files. The script then creates an index and webpages from the HXS files."
  End If
    
TempFol = ParFol & "\temp"   ' temp fol Path for conversion ops.

'-- folder path for help file setup.
DestFol = InputBox("Enter the Path of an existing, empty folder where help will be created. The folder should be in a place where it will not be moved. If it is moved the index links will not work.", "Where to put new help files?")
   If FSO.FolderExists(DestFol) = False Then 
     DropIt "Error. The script requires the Path of an existing folder. Script will now quit."
   End If
   
If Right(DestFol, 1) <> "\" Then DestFol = DestFol & "\"

'-- viewer webpage For unpacked help files.
DexFil = DestFol & "index.hta"
'-- file to contain topic name offsets. 
DatFile = DestFol & "wordlist.dat"  

  '-- Write the basic layout of the HTA webpage.
  
 AHTML(0) = "<HTML><HEAD><TITLE>Help Index</TITLE>"
 AHTML(1) = "<SCRIPT LANGUAGE=" & Q2 & "VBScript" & Q2 & ">" & vbCrLf & "Dim ABack(5)" & vbCrLf & "Dim AWords" & vbCrLf & "Dim HaveWords"
 AHTML(2) = "Sub GetWords()" & vbCrLf & "Dim FSO, TS, sHome, LPt, sWordFile, sWordList" & vbCrLf & "On Error Resume Next"
 AHTML(3) = "HaveWords = False" & vbCrLf & "sHome = window.location" & vbCrLf & "sHome = Replace(sHome, " & Q2 & "/" & Q2 & ", " & Q2 & "\" & Q2 & ")"
 AHTML(4) = "LPt = InStrRev(sHome, " & Q2 & "\\" & Q2 & ")" & vbCrLf & "If LPt > 0 Then sHome = Right(sHome, (len(sHome) - (LPt + 1)))"
 AHTML(5) = "sHome = Replace(sHome, " & Q2 & "%20" & Q2 & ", " & Q2 & " " & Q2 & ")"
 AHTML(6) = "LPt = InStrRev(sHome, " & Q2 & "\" & Q2 & ")" & vbCrLf & "sHome = Left(sHome, LPt)"  & vbCrLf & "sWordFile = sHome & " & Q2 & "wordlist.dat" & Q2
 AHTML(7) = "Set FSO = CreateObject(" & Q2 & "Scripting.FileSystemObject" & Q2 & ")" & vbCrLf & "If FSO.FileExists(sWordFile) = False Then"
 AHTML(8) = "MsgBox " & Q2 & "Wordlist.dat file is missing." & Q2 & ", 64" & vbCrLf & "Exit Sub" & vbCrLf & "End If"
 AHTML(9) = "Set TS = FSO.OpenTextFile(sWordFile, 1)" & vbCrLf & "sWordList = TS.ReadAll" & vbCrLf & "TS.Close" & vbCrLf  & "Set TS = Nothing" & vbCrLf & "Set FSO = Nothing"
 AHTML(10) = "AWords = Split(sWordList, vbCrLf)" & vbCrLf & "If UBound(AWords) > 0 Then HaveWords = True" & vbCrLf & "End Sub" & vbCrLf
 AHTML(11) = "Sub But1_onclick()" & vbCrLf & "Dim i2, i3, s1, s2" & vbCrLf & "On Error Resume Next" & vbCrLf & "If HaveWords = False Then" 
 AHTML(12) = "MsgBox " & Q2 & "No word list available." & Q2 & ", 64" & vbCrLf & "Exit Sub" & vbCrLf & "End If"
 AHTML(13) = "s1 = LCase(T1.Value)" & vbCrLf & "For i2 = 0 to UBound(AWords)"
 AHTML(14) = "s2 = AWords(i2)"      
 AHTML(15) = "If InStr(1, s2, s1, 0) = 1 Then"          
 AHTML(16) = "document.links.item(i2).scrollintoview True"
 AHTML(17) = "Exit Sub"
 AHTML(18) = "End If"
 AHTML(19) = "Next" & vbCrLf & "MsgBox " & Q2 & "Not found." & Q2 & vbCrLf & "End Sub" & vbCrLf
 AHTML(20) = "Sub document_onclick()" & vbCrLf & "If window.event.srcelement.tagname = " & Q2 & "A" & Q2 & " Then"
AHTML(21) = "ABack(5) = ABack(4): ABack(4) = ABack(3): ABack(3) = ABack(2): ABack(2) = ABack(1): ABack(1) = ABack(0): ABack(0) = window.event.srcelement.href" & vbCrLf & "End If" & vbCrLf & "End Sub" & vbCrLf
AHTML(22) = "Sub butback_onclick()" & vbCrLf & "If ABack(1) <> " & Q2 & Q2 & " Then"
AHTML(23) = "window.frames(" & Q2 & "Box" & Q2 & ").location = ABack(1): ABack(0) = ABack(1): ABack(1) = ABack(2): ABack(2) = ABack(3): ABack(3) = ABack(4): ABack(4) = ABack(5): ABack(5) = " & Q2 & Q2
AHTML(24) = "End If" & vbCrLf & "End Sub" & vbCrLf & "</SCRIPT>" & vbCrLf
AHTML(25) = "<STYLE>" & vbCrLf & "BODY, PRE, DIV, TD, A, A:visited{font-family: verdana; font-size: 11px; color: #000060; text-decoration: none;}" 
AHTML(26) = "#tab1 {position: absolute; height: 100%; width: 100%; border-style: double; border-color: #CCCCCC;}"
AHTML(27) = "#top1 {position: relative; width: " & IndexWidthPix & "px; height: 40px; font-size: 11px; border-style: solid;  border-width: 1px; border-color: #CCCCCC;}" 
AHTML(28) = "#top2 {position: relative; width: 100%; height: 40px; font-size: 11px;}"
AHTML(29) = "#TDex {position: relative; width: " & IndexWidthPix & "px; font-size: 11px; border-style: solid; border-width: 1px; border-color: #CCCCCC;}"
AHTML(30) = "#TPage {position: relative; width: 100%; height: 100%; border-style: solid;  border-width: 1px; border-color: #CCCCCC;}"
AHTML(31) = "#Box {position: relative; width: 100%; height: 100%;}"
AHTML(32) = "#div1 {position: relative; height: 100%; width: " & IndexWidthPix & "px; font-size: 11px; overflow: scroll;}" & vbCrLf & "</STYLE>"
AHTML(33) = "</HEAD><BODY onload=" & Q2 & "GetWords()" & Q2 & "><TABLE ID=" & Q2 & "tab1" & Q2 & ">"
AHTML(34) = "<TR><TD ID=" & Q2 & "top1" & Q2 & ">Auto-scroll to: <INPUT TYPE=" & Q2 & "text" & Q2 & " ID=" & Q2 & "T1" & Q2 & " Maxlength=20 SIZE=20></INPUT>"
AHTML(35) = "</TD><TD ID=" & Q2 & "top2" & Q2 & "> &#160; <INPUT type=" & Q2 & "button" & Q2 & " VALUE=" & Q2 & "Search" & Q2 & " ID=" & Q2 & "But1" & Q2 & "></INPUT> &#160;" 
AHTML(36) = "<INPUT type=" & Q2 & "button" & Q2 & " VALUE=" & Q2 & "Back" & Q2 & " ID=" & Q2 & "butback" & Q2 & "></TD></TR>"
AHTML(37) = "<TR><TD ID=" & Q2 & "TDex" & Q2 & "><DIV ID=" & Q2 & "div1" & Q2 & "><PRE>" & vbCrLf

s1 = Join(AHTML, vbCrLf)
Set TS = FSO.CreateTextFile(DexFil, True)
   TS.Write s1
   TS.Close
Set TS = Nothing

 Set oFol = FSO.GetFolder(ParFol)  '-- start by getting a list of HXS files in the folder.
ReDim AFils(300)
ReDim ANames(300)

'-- get paths and base names of HXS files into arrays.
iCount1 = 0
  Set oFils = oFol.Files
    For Each oFil in oFils
       s2 = oFil.Path
       If UCase(right(s2, 4)) = ".HXS" Then
           AFils(iCount1) = s2
           PtA = InStrRev(s2, "\")
           s2 = Mid(s2, (PtA + 1), (Len(s2) - (PtA + 4)))
           ANames(iCount1) = s2          
           iCount1 = iCount1 + 1
       End If
    Next
  Set oFils = Nothing
Set oFol = Nothing

If iCount1 = 0 Then DropIt "Error. To use this script you must drop a folder onto it that contains 1 or more HXS files. The script then creates CHM versions of the HXS files. No HXS files found in:" & vbCrLf & ParFol

sLog = "Number of HXS found: " & iCount1 & vbCrLf 

'-- iCount1 is now number of HXS files. AFils holds their paths. ANmaes holds the file base names, to be used for parent folders.
ReDim Preserve AFils(iCount1 - 1)
ReDim Preserve ANames(iCount1 - 1)

iCount2 = 0

ReDim ATitles(400) '--track ALL titles/topic pages.
ReDim APaths(400)
iPages = 400: TotalPages = 0
   
'-- Main loop. For each HXS file Path, do the following:

 ' * delete any temp folder left over and extract all files into a fresh temp folder.

'       (Unlike the HXStoCHM converter script, this one does not use the HXT/HXK content/index files in the HXS.
'         Instead it deals directly with the webpages in the package, creating an index from the webpage titles.)

'  * Walk the webpage files/folders, making sure that no folder name exceeds 16 characters. IE and some other software may freeze when a
'       path is encountered with long folder names, but they sometimes occur in HXS files. So the first step here is to rename any problem folders.

'  * Walk the files and for each .htm file get the TITLE tag/ file path into the ATitles/APaths arrays. All HXS files processed will have their file titles/paths
'       added to the same arrays. Those arrays will then be sebt to QuickSort2 to be alphabetized, and then used to create the viewer index.

'  * While getting TITLE, also check for any MS_HAID keyword in the META tags. MS_HAID is part of a strange system of links that the Microsofties
'      have cooked up. In some, but not all, HXS files the links in pages are "MSHelp:link" custom tags. They use keywords that correspond to the
'      MS_HAID value. If this system is in use then all in-page links must be repaired, replacing them with A tags. To do that, all found MS_HAID IDs
'      are added to DicKeys as keys, while the file path is added as the key item. Then all .htm files are parsed. Any MSHelp link found is parsed
'      to return the keyword value, which is them compared to the DicKeys keys. If a match is found, the corresponding path 
'--    is used in an A tag to replace the dysfunctional MSHelp:link mess.
'      The fixing of MSHelp links is an operation that is specific to each file.

'   * With all of the files processed, the index is built, using the ALines array, and finally added to the main HTA webpage.

'-------------------------------- MAIN LOOP -------------------------------------------
For i2 = 0 to iCount1 - 1
  s2 = AFils(i2)
   ' use 2 Temp fols to allow for deletion. With multiple files sometimes files are still locked when the script tries to delete the old folder and create a fresh one.
   If i2 Mod 2 = 0 Then
      TempFol = ParFol & "\Temp1"
   Else
       TempFol = ParFol & "\Temp2"
   End If

  BooRet = ProcessFile(s2)
    If BooRet = False Then 
         sLog = sLog & "ProcessFile failed: " & s2  & vbCrLf 
    Else
         iCount2 = iCount2 + 1
            RepairFolderTree2 ThisFol '-- eliminate any extra-long folder names that may freeze IE.
            ProcessFolder ThisFol '-- go through getting titles for index and keywords for fixing MSHelp links.
            FixLinks ThisFol
            DicKeys.RemoveAll 
    End If   
Next  

'-- end main loop.

   If TotalPages > 0 Then 
       ReDim Preserve ATitles(TotalPages - 1)
       ReDim Preserve APaths(TotalPages - 1)

       QuickSort2 ATitles, APaths, 0, 0
        
     i5 = 0

     ReDim ALines(TotalPages - 1)
        For i3 = 0 to (TotalPages - 1)
            s1 = ATitles(i3)
            s2 = APaths(i3)
              If Len(s1) > 0 And Len(s2) > 0 Then
                s1 = Trim(s1)
                ALines(i5) = "<A ID=" & Q2 & CStr(i5) & Q2 & " HREF=" & Q2 & s2 & Q2 & " TARGET=" & Q2 & "Box" & Q2 & ">" & s1 & "</A>"
                i5 = i5 + 1
              End If  
        Next
      ReDim Preserve ALines(i5 - 1)
      s3 = Join(ALines, vbCrLf)
      
      '-- write the index.hta file.
      Set TS = FSO.OpenTextFile(DexFil, 8)  
        TS.Write s3
        TS.Write "</PRE></DIV></TD><TD ID=" & Q2 & "TPage" & Q2 & "><IFRAME NAME=" & Q2 & "Box" & Q2 & " ID=" & Q2 & "Box" & Q2 & " ALIGN=" & Q2 & "top" & Q2 & "></IFRAME></TD></TR></TABLE></BODY></HTML>"
        TS.Close
      Set TS = Nothing    
      
      '-- write the word list file for faster search.
      s3 = Join(ATitles, vbCrLf)
      s3 = LCase(s3)
      Set TS = FSO.CreateTextFile(DatFile, True)  
        TS.Write s3
        TS.Close
      Set TS = Nothing    

   End If


'-- all done.
DropIt iCount2 & " files processed." & vbCrLf & "Help file location is" & vbCrLf & DexFil & "."


'--================ End Main Script. Subs and Functions below this point ======================

'-------- unzip HXS. check for folders inside that have names not starting with $. 
'-- Create a folder named for the HXS file name and move any web content folders there.

Function ProcessFile(sFil)
Dim Boo, iFols, oFol1
  On Error Resume Next
     ProcessFile = False
    If FSO.FolderExists(TempFol) Then FSO.DeleteFolder TempFol, True
     Set oFol = FSO.CreateFolder(TempFol)
     Set oFol = Nothing
     UnZipHXS SevZip & "|" & sFil & "|" & TempFol
        ThisFol = DestFol & ANames(i2)    '-- folder to put this help file's files.
     If FSO.FolderExists(ThisFol) = False Then
       Set oFol = FSO.CreateFolder(ThisFol)
       Set oFol = Nothing
     End If
        '-- add the parent folder in case there are loose HTM files.

      ProcessFile = True '-- this assumes that there are some files or subfolders, and that 7_zip worked OK.
             
     Set oFol = FSO.GetFolder(TempFol)
         '-- copy any folders that might contain webpage files over to the new help system folder.   
     Set oFols = oFol.SubFolders
       If oFols.Count > 0 Then
         For Each oFol1 in oFols
           If InStr(oFol1.Name, "$") = 0 Then
              FSO.CopyFolder oFol1.Path, ThisFol & "\" & oFol1.Name, True
           End If
         Next
       End If
            '-- HTM files in the top-level of the HXS folder tree seem to be rare or non-existent....but just in case:
       Set oFils = oFol.Files 
         For Each oFil in oFils
           If UCase(right(oFil.Name, 4)) = ".HTM" Then
             FSO.CopyFile oFil.Path, ThisFol & "\" & oFil.Name, True
           End If
         Next
      Set oFils = Nothing     
     Set oFols = Nothing   
  Set oFol = Nothing
End Function

Sub RepairFolderTree2(sFolder)
  Dim oFol2, oFols2, oFol3
     On Error Resume Next
   Set oFol2 = FSO.GetFolder(sFolder)
      If Len(oFol2.name) > 16 Then 
         oFol2.Name = sFolNameShort & CStr(iRenamedFolCount)
         iRenamedFolCount = iRenamedFolCount + 1
      End If   
    Set oFols2 = oFol2.SubFolders
       For Each oFol3 in oFols2
             RepairFolderTree2 oFol3.Path
       Next
    Set oFols2 = Nothing
  Set oFol2 = Nothing
End Sub

'-- goes through a folder recursively, getting title/path for index and MS-HAID keyword/path (if keyword is present) to be used later for fixing MSHelp links.
Sub ProcessFolder(sFolder)
  Dim oFol2, oFols2, oFol3, oFils2, oFil2
  Dim sFil2, sTitle, sKeyword
    On Error Resume Next
      Set oFol2 = FSO.GetFolder(sFolder)
        Set oFils2 = oFol2.Files
          For Each oFil2 in oFils2
            If UCase(Right(oFil2.Name, 4)) = ".HTM" Then
                 sFil2 = ReadFile(oFil2.Path)
                 GetTitleAndKeyword sFil2, sTitle, sKeyword
                If Len(sTitle) > 0 Then 
                   ATitles(TotalPages) = sTitle  '--ATitles holds all page titles, for index.
                   APaths(TotalPages) = oFil2.Path   '-- APaths holds file paths correspnding to titles.
                   TotalPages = TotalPages + 1
                       If TotalPages = iPages Then
                            iPages = iPages + 400
                            ReDim Preserve ATitles(iPages)
                            ReDim Preserve APaths(iPages)
                        End If  
                          If Len(sKeyword) = 0 Then sKeyword = Left(oFil2.name, len(oFil2.name) - 4) '--MS-HAID is not always present, but typically the file base name is used otherwise.
                         DicKeys.add sKeyword, oFil2.path          
                 End If   
             End If  
         Next
       Set oFils2 = Nothing
       Set oFols2 = oFol2.SubFolders
          For Each oFol3 in oFols2
              ProcessFolder oFol3.Path
          Next
       Set oFols2 = Nothing
     Set oFol2 = Nothing           
End Sub

Sub GetTitleAndKeyword(sText, sTitle1, sKeyword1)
  Dim Pt1, Pt2, sUCase
      On Error Resume Next
    sTitle1 = ""
    sKeyword1 = ""
    sUCase = UCase(sText)
     Pt1 = InStr(1, sUCase, "<TITLE")
         If Pt1 = 0 Then Exit Sub   '-- can't use the page without a title for the index. 
     Pt2 = InStr(Pt1, sUCase, "</TITLE")
         If Pt2 = 0 Then Exit Sub
     Pt1 = Pt1 + 7
        sTitle1 = Mid(sText, Pt1, (Pt2 - Pt1))
        Pt1 = InStr(1, sTitle1, "|")
           If Pt1 > 0 Then sTitle1 = Left(sTitle1, (Pt1 - 1))        
      sTitle1 = Trim(sTitle1)
                         
       Pt1 = InStr(1, sUCase, cHAID)
             If Pt1 = 0 Then Exit Sub
       Pt2 = InStr(Pt1 + 6, sUCase, "CONTENT=")  '-- find content=   equal sign.
             If Pt2 = 0 Then Exit Sub
             If (Pt2 - Pt1) > 40 Then Exit Sub
       Pt2 = Pt2 + 9
       Pt1 = InStr(Pt2, sUCase, Q2)
           If (Pt1 > 0) And (Pt1 < (Pt2 + 260)) Then
                sKeyword1 = Mid(sText, Pt2, (Pt1 - Pt2)) 'get keyword ID for link.
           End If  
End Sub

Sub FixLinks(sFolder)
  Dim oFol2, oFols2, oFol3, oFils2, oFil2
    On Error Resume Next
    Set oFol2 = FSO.GetFolder(sFolder)
      Set oFils2 = oFol2.Files
          For Each oFil2 in oFils2
            If UCase(Right(oFil2.Name, 4)) = ".HTM" Then
                 RepairFileLinks oFil2.Path
            End If
          Next
       Set oFils2 = Nothing
       Set oFols2 = oFol2.SubFolders   
         For Each oFol3 in oFols2
           FixLinks oFol3.Path   
         Next
       Set oFols2 = Nothing
    Set oFol2 = Nothing     
End Sub

Sub RepairFileLinks(sFilePath)
  Dim UBTemp, i2_, i4_, sUCase, Pt1, Pt2, Pt3, Pt4, sKey, sLnk, sFil2
     On Error Resume Next
   ReDim ATemp(100)
    UBTemp = 100
     i4_ = 0
     sFil2 = ReadFile(sFilePath)
     sUCase = UCase(sFil2) 
     Pt2 = 1
      Do
           If i4_ > UBTemp - 4 Then 
              UBTemp = UBTemp + 100
              ReDim Preserve ATemp(UBTemp)
           End If  
           Pt1 = InStr(Pt2, sUCase, "<MSHELP:LINK")
                If Pt1 = 0 Then Exit Do
            ATemp(i4_) = Mid(sFil2, Pt2, (Pt1 - Pt2)): i4_ = i4_ + 1
           Pt2 = InStr(Pt1 + 7, sUCase, "</MSHELP")  ' set Pt2_ as character following </MSHelp:link>
                 If Pt2 = 0 Then Exit Do
              Pt2 = Pt2 + 14
           Pt3 = InStr(Pt1, sUCase, "KEYWORDS")
             If (Pt3 > 0) And (Pt3 < Pt2) Then 
                 Pt3 = Pt3 + 10
                 Pt4 = InStr(Pt3, sUCase, Q2)
                 sKey = Mid(sFil2, Pt3, (Pt4 - Pt3))  'this is now keyword.
                 Pt1 = InStr(Pt4, sUCase, ">")   ' find first char. of visible link text:  keywords="keys">click here<...etc.
                 Pt4 = InStr(Pt1, sUCase, "<")
                  If Pt4 > (Pt1 + 1) Then                       
                     If DicKeys.exists(sKey) Then    
                        ATemp(i4_) = "<A HREF=" & Q2 & DicKeys.item(sKey) & Q2 & ">" & Mid(sFil2, (Pt1 + 1), (Pt4 - Pt1) - 1) & "</A>"   ' replace the bad link, if possible.
                     Else        
                         ATemp(i4_) =  Mid(sFil2, (Pt1 + 1), (Pt4 - Pt1) - 1) '-- if not replaceable then remove it and just leave text of link.
                     End If
                        i4_ = i4_ + 1           
                  End If  
              End If    
            
                If Pt2 >= Len(sFil2) Then Exit Do    
            '-- loop now resumes at Pt2
         Loop
     
       If Pt2 < Len(sFil2) Then
          ATemp(i4_) = Right(sFil2, (len(sFil2) - Pt2) + 1): i4_ = i4_ + 1
       End If  
         
'-- write the edited file back to disk.
      sFil2 = Join(ATemp, "")
      WriteFile sFilePath, sFil2   
End Sub

Sub UnZipHXS(sCom)
  Dim Ret, Pt4, ScrPath
   On Error Resume Next
    ScrPath = WScript.ScriptFullName
      Pt4 = InStrRev(ScrPath, "\")
    ScrPath = Left(ScrPath, Pt4) & "zip7.vbs"
    SH.Run Q2 & ScrPath & Q2 &  " " & Q2 & sCom & Q2, , True
End Sub

Sub QuickSort2(AIn, A2In, LBeg, LEnd)
  Dim LBeg2, vMid, LEnd2, vSwap, vSwap2
      If (LEnd = 0) Then LEnd = UBound(AIn)
    LBeg2 = LBeg
    LEnd2 = LEnd
     vMid = AIn((LBeg + LEnd) \ 2)  '*
      Do
          Do While AIn(LBeg2) < vMid And LBeg2 < LEnd   '*
             LBeg2 = LBeg2 + 1
          Loop
          Do While vMid < AIn(LEnd2) And LEnd2 > LBeg   '*
             LEnd2 = LEnd2 - 1
          Loop
            If LBeg2 <= LEnd2 Then
               vSwap = AIn(LBeg2)
               vSwap2 = A2In(LBeg2)
               AIn(LBeg2) = AIn(LEnd2)
               A2In(LBeg2) = A2In(LEnd2)
               AIn(LEnd2) = vSwap
               A2In(LEnd2) = vSwap2
               LBeg2 = LBeg2 + 1
               LEnd2 = LEnd2 - 1
            End If
     Loop Until LBeg2 > LEnd2
       If LBeg < LEnd2 Then QuickSort2 AIn, A2In, LBeg, LEnd2
       If LBeg2 < LEnd Then QuickSort2 AIn, A2In, LBeg2, LEnd
End Sub 

Function ReadFile(Path)
  Set TS = FSO.OpenTextFile(Path, 1)
    ReadFile = TS.ReadAll
    TS.Close
  Set TS = Nothing
End Function

Sub WriteFile(Path, sContent)
  Set TS = FSO.CreateTextFile(Path, True)
    TS.Write sContent
    TS.Close
  Set TS = Nothing
End Sub

'---------------------------------------------------- END -------------------------------------------------
Sub DropIt(sMsg)
  On Error Resume Next
  Set SH = Nothing
  MsgBox sMsg, 64, "Convert HXS to CHM"
   If Len(sLog) > 0 Then
      Set TS = FSO.CreateTextFile(ParFol & "\Conversion Log.txt", True)
        TS.Write sLog
        TS.Close
      Set TS = Nothing
   End If
  WScript.Sleep 4000    ' pause before trying to delete folders.
    If FSO.FolderExists(ParFol & "\Temp1") Then FSO.DeleteFolder ParFol & "\Temp1", True
    If FSO.FolderExists(ParFol & "\Temp2") Then FSO.DeleteFolder ParFol & "\Temp2", True
    
  Set DicKeys = CreateObject("Scripting.Dictionary")  
  Set FSO = Nothing
  WScript.quit
End Sub  
