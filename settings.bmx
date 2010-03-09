
SuperStrict
Import "ini.bmx"

Type btSettings

	Global Height:Int
	Global Glass:Int
	Global FadeTime:Float
	Global GameWidth:Int
	Global GameHeight:Int
	Global Movetime:Int
	Global Moves:Int
	Global Seed:Int
	Global Skips:Int
	Global ini:TPertIni
	
	Function Load()
		ini = TPertIni.Create("config.ini")
		ini.Load()
		
		Height = Int(IniLoadDef(ini, "Display", "Height", "500"))
		Glass = Int(IniLoadDef(ini, "Display", "Glass", "1"))
		FadeTime = Int(IniLoadDef(ini, "Display", "FadeDuration", "20"))
		GameWidth = Int(IniLoadDef(ini, "Game", "Width", "5"))
		GameHeight = Int(IniLoadDef(ini, "Game", "Height", "5"))
		Movetime = Int(IniLoadDef(ini, "Game", "Time limit", "25000"))
		Moves = Int(IniLoadDef(ini, "Game", "Moves", "35"))
		Skips = Int(IniLoadDef(ini, "Game", "Skips", "-1"))
		Seed = 0
		ini.Save()
	End Function

	Function ToggleGlass:Int()
		Glass = 1 - Glass
		ini.SetSectionValue("Display", "Glass", Glass)
		ini.Save(True)
		Return Glass
	End Function
	
	Function SetFadeTime:Int(msecs:Int)
		FadeTime = Max(msecs, 0)
		ini.SetSectionValue("Display", "FadeDuration", FadeTime)
		ini.Save(True)
		Return FadeTime
	End Function
	
	Function SetMoves:Int(n:Int)
		
		If n = 0 n = 3
		If n < 3 n = -1
		
		Moves = n
		ini.SetSectionValue("Game", "Moves", Moves)
		ini.Save(True)
		Return Moves
	End Function
	
	Function SetGameWidth:Int(x:Int)
		GameWidth = Max(x, 3)
		ini.SetSectionValue("Game", "Width", GameWidth)
		ini.Save(True)
		Return GameWidth
	End Function

	Function SetGameHeight:Int(y:Int)
		GameHeight = Max(y, 3)
		ini.SetSectionValue("Game", "Width", GameHeight)
		ini.Save(True)
		Return GameHeight
	End Function
	
	Function SetSeed:Int(n:Int)
		Seed = n
		Return Seed
	End Function
	
	Function SetSkips:Int(n:Int)
		Skips = Max(n, - 1)
		ini.SetSectionValue("Game", "Skips", Skips)
		ini.Save(True)
		Return Skips
	End Function
EndType



