
SuperStrict

Framework brl.blitz
Import brl.glmax2d

Import "gamemenu.bmx"
Import "game.bmx"
Import "settings.bmx"

Incbin "ARLRDBD.TTF"

AppTitle = "Quadris"

btSettings.Load()

Graphics btGame.GetWidthForHeight(btSettings.Height), btSettings.Height

SetClsColor(255, 255, 255)

btState.CurrentState = New btMenuState.Init()


While (Not AppTerminate())
	btState.RunCurrent()
	Cls
	btState.RenderCurrent()
	Flip
	If btState.CurrentState = Null btState.CurrentState = New btMenuState.Init()
Wend



