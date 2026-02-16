
'- This script is used to call 7-Zip. It waits for 7-Zip to return and then quits.
'- In initial tests, 7-zip stayed in memory if called from the main script, resulting in numerous instances of 7-Zip running.
' This method means that the calling script quits after calling 7-Zip once, thus causing 7-Zip to exit.


Dim Arg, Ret, SH, SevZip, Q2, A2, sFil, Tempfol
Set SH = CreateObject("WScript.Shell")

Arg = WScript.arguments(0)
A3 = split(Arg, "|")
SevZip = A3(0)
sFil = A3(1)
Tempfol = A3(2)
 On Error Resume Next
Q2 = chr(34)
SevZip = Q2 & SevZip & Q2
    Ret = SH.Run(SevZip & " x " & Q2 & sFil & Q2 & " -aoa -o" & Q2 & Tempfol & Q2 & " * -r", 0, True)
Set SH = Nothing
WScript.quit      