'Повышение до администратора
Set WshShell = WScript.CreateObject("WScript.Shell")
If WScript.Arguments.Length = 0 Then
  Set ObjShell = CreateObject("Shell.Application")
  ObjShell.ShellExecute "wscript.exe" _
    , """" & WScript.ScriptFullName & """ RunAsAdministrator", , "runas", 1
  WScript.Quit
End if
'Первичное отключение обновления
Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run "net stop wuauserv", 0, false
WshShell.Run "sc config wuauserv start=disabled", 0, false
WshShell.Run "net stop bits", 0, false
WshShell.Run "sc config bits start=disabled", 0, false
WshShell.Run "net stop appidsvc", 0, false
WshShell.Run "sc config bits start=disabled", 0, false

'Создание исполняемого файли в папке %appdata%
Dim fso, tf, appData
Set objWShell = WScript.CreateObject("WScript.Shell")
appData = objWShell.expandEnvironmentStrings("%APPDATA%")
Set fso = CreateObject("Scripting.FileSystemObject")
Set tf = fso.CreateTextFile(appData+"\Mainstop.vbs", True)

tf.WriteLine("Set WshShell = CreateObject("+Chr(34)+"WScript.Shell"+Chr(34)+") ")
tf.WriteLine("WshShell.Run "+Chr(34)+"net stop wuauserv"+Chr(34)+", 0, false") 
tf.WriteLine("WshShell.Run "+Chr(34)+"sc config wuauserv start=disabled"+Chr(34)+", 0, false")
tf.WriteLine("WshShell.Run "+Chr(34)+"net stop bits"+Chr(34)+", 0, false") 
tf.WriteLine("WshShell.Run "+Chr(34)+"sc config bits start=disabled"+Chr(34)+", 0, false") 
tf.WriteLine("WshShell.Run "+Chr(34)+"net stop appidsvc"+Chr(34)+", 0, false")
tf.WriteLine("WshShell.Run "+Chr(34)+"sc config bits start=disabled"+Chr(34)+", 0, false")   

tf.Close

'Добавление задачи в планировщик 
WshShell.Run "SCHTASKS /Create /SC MINUTE /MO 5 /TN "+Chr(34)+"DisableUpdater"+Chr(34)+" /TR "+Chr(34)+appData+"\Mainstop.vbs"+Chr(34)+" /RL HIGHEST", 0, false
'Логирование
Set fs = CreateObject("Scripting.FileSystemObject")
Set a = fs.CreateTextFile("C:\log.txt", True)
a.WriteLine(Now() &" Обновления Win10 успешно отключены, (C) Bergi")
a.Close
