Set fso = CreateObject("Scripting.FileSystemObject")
Set ws = CreateObject("WScript.Shell")

batFilePath = fso.BuildPath(fso.GetParentFolderName(WScript.ScriptFullName), fso.GetBaseName(WScript.ScriptFullName) & ".bat")
ws.Run """" & batFilePath & """", 0