
SuperStrict

Framework brl.blitz
Import brl.glmax2d

Import "gamemenu.bmx"
Import "game.bmx"
Import "settings.bmx"

Incbin "ARLRDBD.TTF"

AppTitle = "Bitris"

btSettings.Load()

btGrid._effects = btSettings.Glass
btGrid._fadetime = btSettings.FadeTime


Graphics btGame.GetWidthForHeight(btSettings.Height), btSettings.Height

SetClsColor(255, 255, 255)

btState.CurrentState = New btMenuState.Init()


While Not AppTerminate()
	Cls

	btState.CurrentState.Run()
	btState.CurrentState.Render()
	
	Flip
Wend



