
Framework brl.blitz
Import brl.glmax2d

Import "game.bmx"

Graphics 350, 500

Local game:btGame = New btGame.Init(350, 500)

While Not AppTerminate()
	Cls
	
	game.Run()
	game.Render()
	
	Flip
Wend



