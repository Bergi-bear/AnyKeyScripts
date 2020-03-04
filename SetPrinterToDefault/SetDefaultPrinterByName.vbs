Option Explicit

Dim i

Dim objRegExp
Dim objWshNetwork
Dim collWshCollection


Set objRegExp = WScript.CreateObject("VBScript.RegExp")

With objRegExp
	.IgnoreCase = True
	.Pattern    = "PrinterNa*"
End With

With WScript.CreateObject("WScript.Network")
	Set collWshCollection = .EnumPrinterConnections()
	
	For i = 0 To collWshCollection.Count - 1 Step 2
		If objRegExp.Test(collWshCollection.Item(i + 1)) Then
			.SetDefaultPrinter collWshCollection.Item(i + 1)
			
			Exit For
		End If
	Next
	
	Set collWshCollection = Nothing
End With

Set objRegExp = Nothing

WScript.Quit 0
