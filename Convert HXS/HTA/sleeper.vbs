'-- This is just a simple pause script for use with utility.
'-- Since WScript is not available from a webpage the utility
'-- class uses Shell to call this script and wait, thereby simulating
'-- a sleep function.

Dim Arg
  on error resume next
 Arg = WScript.Arguments(0)
 wscript.sleep Arg
 
