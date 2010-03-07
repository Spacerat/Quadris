
SuperStrict

Import "game.bmx"
Import "menu.bmx"
Import "settings.bmx"
Import brl.ramstream
Import brl.freetypefont
Import brl.standardio

Type btMenuState Extends btState
	
	Field _Menu:btMenu
	Field _Font:TImageFont
	Method Init:btMenuState()
	
		_Menu = New btMenu
		_Menu.Initialise(GameMenuCallback, Self)
		_Menu.AddItem("Single-player Standard")
		_Menu.AddItem("Single-player Arcade")
		_Menu.AddItem("Hotseat")
		_Menu.SetPosition(40, 40)
		
		_Font = LoadImageFont("incbin::ARLRDBD.TTF", 20)
		
		Return Self
	End Method
	
	Method MenuClicked(index:Int, text:String)

		Select index
			Case 0
				CurrentState = New btStandardGame.Init(btSettings.Height, btSettings.GameWidth, btSettings.GameHeight, btSettings.Movetime, btSettings.Moves)
			Case 1
				CurrentState = New btStandardGame.Init(btSettings.Height, btSettings.GameWidth, btSettings.GameHeight, btSettings.Movetime, - 1)
			Case 2
					CurrentState = New btHotseatGame.Init(btSettings.Height, btSettings.GameWidth, btSettings.GameHeight, btSettings.Movetime, - 1)
		End Select
	End Method

	Method Render()
		SetImageFont(_Font)
		SetColor(0, 0, 0)
		_Menu.Render()
	End Method
	
End Type

Function GameMenuCallback(index:Int, text:String, Menu:btMenu, context:Object)
	btMenuState(context).MenuClicked(index, Text)
EndFunction