' MajorGeeks.Com
' How to Easily Benchmark Restart Time in Windows 10 & 11 With a VBS File
' https://www.majorgeeks.com/content/page/how_to_easily_benchmark_restart_time_in_windows.html

Option Explicit
On Error Resume Next

Dim WSHell
Dim strRegCurrentTime, strSeflPath, MsgResult, strCloseAppsConfirmation, strMsgboxTitle
Dim ddTimeResult, secs, mins, hours, result

strSeflPath = """" & WScript.ScriptFullName & """"

set WSHell = CreateObject("WScript.Shell")
strRegCurrentTime = WSHell.RegRead("HKEY_CURRENT_USER\Software\CurrentTime")

if strRegCurrentTime = "" then
	MsgResult = Msgbox("Close all running applications now. Click Yes when ready!", VBExclamation + VBYesNo, "Warning!")
	If MsgResult = VBYes then
		WSHell.RegWrite "HKEY_CURRENT_USER\Software\CurrentTime", Now, "REG_SZ"
		WSHell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\CheckRestartTime", strSeflPath, "REG_SZ"
		WSHell.Run "shutdown -r -f -t 0", false, 0 
	end if
else
	WSHell.RegDelete "HKEY_CURRENT_USER\Software\CurrentTime"
	WSHell.RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\CheckRestartTime"
	secs = DateDiff("s", strRegCurrentTime, Now)
	mins = secs \ 60 
	hours = mins \ 60 
	mins = mins mod 60 
	secs = secs mod 60 
	hours = hours mod 24 
	result = right("00" & hours , 2) & ":" & right("00" & mins, 2) & ":" & right("00" & secs, 2)
	
	MsgBox "Your computer restart time is " & result & ".", VBOKOnly + VbInformation, "Restart time"
end if

set WSHell = nothing
wscript.Quit
