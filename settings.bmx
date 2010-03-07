
SuperStrict
Import "ini.bmx"

Type btSettings

	Global Height:Int
	Global Glass:Int
	Global FadeTime:Int
	Global GameWidth:Int
	Global GameHeight:Int
	Global Movetime:Int
	Global Moves:Int

	Function Load()
		Local ini:TPertIni = TPertIni.Create("config.ini")
		ini.Load()
		
		Height = Int(IniLoadDef(ini, "Display", "Height", "500"))
		Glass = Int(IniLoadDef(ini, "Display", "Glass", "1"))
		FadeTime = Int(IniLoadDef(ini, "Display", "FadeDuration", "20"))
		GameWidth = Int(IniLoadDef(ini, "Game", "Width", "5"))
		GameHeight = Int(IniLoadDef(ini, "Game", "Height", "5"))
		Movetime = Int(IniLoadDef(ini, "Game", "Time limit", "25000"))
		Moves = Int(IniLoadDef(ini, "Game", "Moves", "35"))
		
		
		
		ini.Save()
	End Function

EndType



