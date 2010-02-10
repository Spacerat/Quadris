
Framework brl.blitz
Import brl.glmax2d

Import "game.bmx"

Apptitle="Joe's Bitris Clone"

'Graphics 270, 400

Const GAMEHEIGHT:Int = 500

Graphics btGame.GetWidthForHeight(GAMEHEIGHT), GAMEHEIGHT
SetClsColor(255,255,255)
Local game:btGame = New btGame.Init(GAMEHEIGHT)


While Not AppTerminate()
	Cls
	
	game.Run()
	game.Render()
	
	Flip
Wend



