net stop spooler
del /q /f /s "%SystemRoot%\system32\spool\printers\*.*"
net start spooler
