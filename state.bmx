
SuperStrict

Type btState

	Global CurrentState:btState

	Method Run()
		
	End Method
	
	Method Render()
		
	End Method
	
	Function RunCurrent()
		If (CurrentState)
			CurrentState.Run()
		EndIf
	End Function
	
	Function RenderCurrent()
		If (CurrentState)
			CurrentState.Render()
		EndIf
	End Function
	
EndType
