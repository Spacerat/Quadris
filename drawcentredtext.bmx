
SuperStrict

Import brl.max2d

Function DrawTextCentred(s:String, x:Float, y:Float, hcentre:Int = True, vcentre:Int = False)
	If (hcentre) x:-(TextWidth(s) / 2)
	If (vcentre) y:-(TextHeight(s) / 2)
	DrawText(s, x, y)
End Function
