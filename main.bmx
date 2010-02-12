
Framework brl.blitz
Import brl.glmax2d

Import "game.bmx"
Import "ini.bmx"

AppTitle = "Joe's Bitris Clone"

'Graphics 270, 400

Global ini:TPertIni = TPertIni.Create("config.ini")
ini.Load()

Global GAMEHEIGHT:Int = Int(iniLoadDef(ini, "Display", "Height", "500"))
btGrid._effects = Int(IniLoadDef(ini, "Display", "Effects", "1"))
Local gwidth:Int = Int(IniLoadDef(ini, "Game", "Width", "5"))
Local gheight:Int = Int(IniLoadDef(ini, "Game", "Height", "5"))
Local gtime:Int = Int(IniLoadDef(ini, "Game", "Time limit", "25000"))
Local gmoves:Int = Int(IniLoadDef(ini, "Game", "Moves", "35"))

ini.Save()

Graphics btGame.GetWidthForHeight(GAMEHEIGHT), GAMEHEIGHT
SetClsColor(255,255,255)
Local game:btGame = New btStandardGame.Init(GAMEHEIGHT, gwidth, gheight, gtime, gmoves)



While Not AppTerminate()
	Cls
	
	game.Run()
	game.Render()
	
	Flip
Wend



