'-- This script is for use with the script Create WebHelp From HXS.vbs. With that script you
'-- can generate a "web help" system as an HTA that has an index on the left side. The web help
'-- is similar to the MSDN help viewer. Since an HXS file is actually just a compressed website,
'-- Create WebHelp From HXS.vbs works by unpacking the HXS files and then creating index
'-- links to the pages.

'-- >>> THIS SCRIPT IS USED AFTER Create WebHelp From HXS.vbs. You drop the folder full of
'-- of help webpages, produced by that script, onto this script. This script then goes through
'-- each top-level folder and processes the HTML files. It does several things:
'--  With HXS files, some -- but not all -- links are in an unusable format, using a made-up HTML
'   tag: <MSHELP:link
'   That tag links to a page ID that may may not be in the help package webpages. The page ID appears as a META tag, like so:

'     <META NAME="MS-HAID" CONTENT="_win32_User_Input_cpp">
'
'  A link pointing to that ID might be like this:   

'    <MSHelp:Keyword Index="A" Term="_win32_User_Input_cpp"></MSHelp:Keyword>

'   Obviously this is not real HTML. It's corrupt Microsoft nonsense that can only be read
'   by the HXS help file parser. So in order for such links to work, this script goes through
'   each file in a package and gets all HAIDs, linking those to webpage file paths. It then
'   goes through all files again and replaces something like:

'  <MSHelp:Link Index="A" Term="_win32_User_Input_cpp"></MSHelp:Link>

' with something like:

'   <A HREF="D:/SDKFiles/Winui/winui/windowsuserinterface/userinput.htm">User Input</A>

'-- In addition to fixing links, this script provides the option to add custom CSS to each page
'-- and an option to remove all script from each page. These are the same options provided
'-- by the HTA utility that processes 1 HXS at a time and produces a CHM file.

'-- To use this script, drop the parent folder of your webhelp files onto it, but first
'-- set the CustomStyleBlock below if you want to customize the appearance of the help pages.


Dim FSO, TS, oFol, oFol1, oFols, oFils, oFil, Arg, Ret, sParFols, AParFols(), ATemp(), AFils
Dim i2, i3, iHlpCnt, iCur, UB2
Dim DicKeys
Dim sFilList
Dim Verbose, CleanScriptMess, CustomStyleBlock
Dim Q2, cHAID

Q2 = Chr(34)
cHAID = "NAME=" & Q2 & "MS-HAID"

'------------ IMPORTANT: If you want to add custom CSS to the pages add that here. ---------------------

'CustomStyleBlock = "<STYLE>" & vbCrLf & "BODY, TD, DIV, P, SPAN, DT, DD, LI, A, BLOCKQUOTE {font-family: verdana, sans-serif; font-size: 12px; line-height: 1.4; color: #000040; background-color: #FEFDFC;}"
'CustomStyleBlock = CustomStyleBlock & "H1, H2{font-size: 18px; color: #0033AA; background-color: #FFF0DF; font-family: arial; line-height: 1.5;} H3, H4, H5 {font-size: 14px; color: #0033AA; background-color: #FFF0DF; font-family: arial; line-height: 1.5;}"
'CustomStyleBlock = CustomStyleBlock & "PRE {font-size: 12px; color: #660000; line-height: 1.4;} A:link {color: #0033FF; text-decoration: none;} A:visited {text-decoration: none;} A:hover {color: #FFFFFF; background-color: #0066EE; text-decoration: none;}"
'CustomStyleBlock = CustomStyleBlock & "</STYLE>"

'-------------- end custom style. ------------------------------------------------------

On Error Resume Next

Set FSO = CreateObject("Scripting.FileSystemObject")

Arg = WScript.Arguments(0)

 If FSO.FolderExists(Arg) = False Then
   MsgBox "Drop a folder of uncompressed HXS help files onto this script in order to fix internal links. This script is for use on the parent folder after you have created a web help system with the file Create WebHelp From HXS.vbs", 64
   Set FSO = Nothing: WScript.Quit
 End If

Ret = MsgBox(Arg & vbCrLf & "This must be the folder that contains the parent folder for each help file. See included explanations if you do not understand. Are you ready to proceed?", 36)
  If Ret = 7 Then
     Set FSO = Nothing: WScript.Quit
 End If

Ret = MsgBox("Do you want to run this script in verbose mode?", 36)
  If Ret = 6 Then Verbose = True: Else: Verbose = False

Ret = MsgBox("Do you want to clean all script from the help files?", 36)
  If Ret = 6 Then CleanScriptMess = True: Else: CleanScriptMess = False

'If Right(Arg, 1) <> "\" Then Arg = Arg & "\"
  '-- start by getting an array of top-level folders. Each folder represents a single help file, decompressed.
Set oFol = FSO.GetFolder(Arg)
Set oFols = oFol.SubFolders
   iHlpCnt = oFols.Count - 1
  ReDim AParFols(iHlpCnt)
    i3 = 0
     For Each oFol1 in oFols
        AParFols(i3) = oFol1.Path
        i3 = i3 + 1
     Next
Set oFols = Nothing
Set oFol = Nothing
 
 Set DicKeys = CreateObject("Scripting.Dictionary")
      
For iCur = 0 to iHlpCnt  '-- loop through each HXS parent folder.
   sFilList = ""
   GetFilesList AParFols(iCur)   '-- this will be something like "D:\WinSDK\GDI", "D:\WinSDK\ShelCC", etc.
   
   ProcessLinksForCHM sFilList
Next

Set DicKeys = Nothing

MsgBox "Done. " & CStr(iHlpCnt + 1) & " file sets processed."
WScript.quit
'-------------------------------------------

'-- this is a recursive sub that gets a list of all HTML files in parent folder -- and subfolders -- of specific help file.

Sub GetFilesList(sPath)
    Dim oFol2, oFil2, oFils2, oFols2, oFol3
    Set oFol2 = FSO.GetFolder(sPath)
       Set oFils2 = oFol2.Files
         For Each oFil2 in oFils2
           sFilList = sFilList & oFil2.Path & vbCrLf
         Next  
      Set oFils2 = Nothing
      Set oFols2 = oFol2.SubFolders
        For Each oFol3 in oFols2
           GetFilesList oFol3.Path
        Next
      Set oFols2 = Nothing
End Sub
  
'---------------
Public Sub ProcessLinksForCHM(sFilesList)
    Dim sFil1
  AFils = Split(sFilesList, vbCrLf)
  UB2 = UBound(AFils)

   If Verbose = True Then MsgBox "Beginning Phase 1 -- processing of HTM files, matching up identifying keywords to file paths. Total files to process: " & CStr(UB2 + 1)
   
    For i3 = 0 to UB2
      sFil1 = AFils(i3)
      If UCase(Right(sFil1, 4)) = ".HTM" Then FLProcessFile sFil1, 1
    Next

'-- At this point the only major job left is replacing the MSHelp links, but that's a big job.
    If Verbose = True Then MsgBox "Beginning phase 2 with HTM files -- replacing MSHelp links with normal links, using file paths obtained in Phase 1. Total files to process: " & CStr(UB2 + 1)
    
  For i3 = 0 to UB2
     sFil1 = AFils(i3)
     If UCase(Right(sFil1, 4)) = ".HTM" Then FLProcessFile sFil1, 2
  Next
  
  DicKeys.RemoveAll
End Sub

Private Sub FLProcessFile(sPath_, Phase)
  Dim s1_, s2_, s3_, sDisp, LenDisp, Pt1_, Pt2_, Pt3_, Pt4_, sMid, sKey, i2_, i4_, sLnk, UBTemp, sUCase
    s1_ = FLReadFile(sPath_)
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
      FLWriteFile sPath_, s2_   
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
  Set TS = FSO.OpenTextFile(Path, 1)
    FLReadFile = TS.ReadAll
    TS.Close
  Set TS = Nothing
End Function

Public Sub FLWriteFile(Path, sContent)
  Set TS = FSO.CreateTextFile(Path, True)
    TS.Write sContent
    TS.Close
  Set TS = Nothing
End Sub

