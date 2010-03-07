
SuperStrict

Import "game.bmx"
Import "menu.bmx"
Import "settings.bmx"
Import brl.ramstream
Import brl.freetypefont
Import brl.standardio

Type btMenuState Extends btState
	
	Field _Menu:btMenu
	Field _Settings:btMenu
	Field _Font:TImageFont
	Method Init:btMenuState()
	
		Local scale:Float = btSettings.Height / 500.0
		
		_Menu = New btMenu
		_Menu.Initialise(GameMenuCallback, Self)
		_Menu.SetPosition(30 * scale, 40 * scale)
		_Menu.SetSpacing(20 * scale)
		_Menu.AddItem("Single-player Standard")
		_Menu.AddItem("Single-player Custom")
		_Menu.AddItem("Hotseat")
		_Menu.AddItem("Settings")
		_Menu.AddItem("Exit")
		
		_Settings = New btMenu
		_Settings.SetCallback(GameMenuCallback)
		_Settings.SetContext(Self)
		_Settings.SetPosition(30 * scale, 40 * scale)
		_Settings.SetSpacing(20.0 * scale)
		
		If btSettings.Glass
			_Settings.AddItem("Glass: On")
		Else
			_Settings.AddItem("Glass: Off")
		End If
		_Settings.AddItem("Fade time: " + Int(btSettings.FadeTime))
		_Settings.AddItem("Pieces: " + btSettings.Moves)
		_Settings.AddItem("Grid width: " + btSettings.GameWidth)
		_Settings.AddItem("Grid height: " + btSettings.GameHeight)
		If btSettings.Seed = 0
			_Settings.AddItem("Random Seed: Random")
		Else
			_Settings.AddItem("Random Seed: " + btSettings.Seed)
		EndIf
		_Settings.AddItem("")
		_Settings.AddItem("Return to main menu")
		
		
		_Font = LoadImageFont("incbin::ARLRDBD.TTF", Int(22 * scale))
		
		Return Self
	End Method
	
	Method Run()
		If KeyHit(KEY_ESCAPE)
			If _Settings.IsEnabled()
				_Settings.Disable()
				_Menu.Enable()
			Else
				End
			EndIf
		End If
	End Method
	
	Method MenuClicked(index:Int, text:String, button:Int, Menu:btMenu)
		If Menu = _Menu
			If Button = MOUSE_LEFT
				Select index
					Case 0
						CurrentState = New btStandardGame.Init(btSettings.Height)
						Leave()
					Case 1
						CurrentState = New btStandardGame.Init(btSettings.Height, btSettings.GameWidth, btSettings.GameHeight, btSettings.Movetime, btSettings.Moves, btSettings.seed)
						Leave()
					Case 2	
						Leave()
						'DebugStop
						CurrentState = New btHotseatGame.Init(btSettings.Height, btSettings.GameWidth, btSettings.GameHeight, btSettings.Movetime, - 1)
						
					Case 3
						_Menu.Disable()
						_Settings.Enable()
					Case 4
						End
				End Select
			EndIf
		ElseIf Menu = _Settings
			Select index
				Case 0
					If btSettings.ToggleGlass()
						_Settings.ChangeItem(0, "Glass: On")
					Else
						_Settings.ChangeItem(0, "Glass: Off")
					End If
				Case 1
					If Button = MOUSE_LEFT
						btSettings.SetFadeTime(btSettings.FadeTime + 4)
					ElseIf Button = MOUSE_RIGHT
						btSettings.SetFadeTime(btSettings.FadeTime - 4)
					End If
					_Settings.ChangeItem(1, "Fade time: " + Int(btSettings.FadeTime))
				Case 2
					Local moves:Int
					If Button = MOUSE_LEFT
						moves = btSettings.SetMoves(btSettings.Moves + 1)
					ElseIf Button = MOUSE_RIGHT
						moves = btSettings.SetMoves(btSettings.Moves - 1)
					End If
					If moves = -1
						_Settings.ChangeItem(2, "Pieces: Infinate")
					Else
						_Settings.ChangeItem(2, "Pieces: " + Int(btSettings.Moves))
					EndIf
				Case 3
					If Button = MOUSE_LEFT
						btSettings.SetGameWidth(btSettings.GameWidth + 1)
					ElseIf Button = MOUSE_RIGHT
						btSettings.SetGameWidth(btSettings.GameWidth - 1)
					End If
					_Settings.ChangeItem(3, "Grid width: " + Int(btSettings.GameWidth))
				Case 4
					If Button = MOUSE_LEFT
						btSettings.SetGameHeight(btSettings.GameHeight + 1)
					ElseIf Button = MOUSE_RIGHT
						btSettings.SetGameHeight(btSettings.GameHeight - 1)
					End If
					_Settings.ChangeItem(4, "Grid height: " + Int(btSettings.GameHeight))
				Case 5
					Local seed:Int
					If Button = MOUSE_LEFT
						seed = btSettings.SetSeed(btSettings.Seed + 1)
					ElseIf Button = MOUSE_RIGHT
						seed = btSettings.SetSeed(Max(btSettings.Seed - 1, 0))
					End If
					If seed = 0
						_Settings.ChangeItem(5, "Random Seed: Random")
					Else
						_Settings.ChangeItem(5, "Random Seed: " + btSettings.Seed)
					EndIf
				Case 7
					If Button = MOUSE_LEFT
						_Settings.Disable()
						_Menu.Enable()
					EndIf
			EndSelect
		EndIf
	End Method

	Method Leave()
		_Menu.Disable()
		_Settings.Disable()
	End Method
	
	Method Render()
		SetImageFont(_Font)
		SetColor(0, 0, 0)
		SetScale(1, 1)
		If _Menu.IsEnabled() _Menu.Render()
		If _Settings.IsEnabled() _Settings.Render()
	End Method
	
End Type

Function GameMenuCallback(index:Int, text:String, Button:Int, Menu:btMenu, context:Object)
	btMenuState(context).MenuClicked(index, Text, Button, Menu)
EndFunction