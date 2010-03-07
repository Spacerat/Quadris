
SuperStrict

Import brl.max2d
Import brl.linkedlist
Import brl.hook

Type btMenu

	Field _Items:TList = New TList
	Field _x:Float, _y:Float
	Field _context:Object
	Field _Callback:Int(index:Int, Text:String, Menu:btMenu, data:Object)
	
	Field _HoverItem:Int = -1
	
	Method Initialise(func:Int(index:Int, Text:String, Menu:btMenu, data:Object), context:Object = Null)
		AddHook(EmitEventHook, btMenu.InputHook, Self)
		SetContext(context)
		SetCallback(func)
	End Method
	
	Method Render()
	
		Local spacing:Int = TextHeight("|") + 2
		Local yy:Int = _y
	
		Local n:Int = 0
		SetBlend(ALPHABLEND)
		For Local i:String = EachIn _Items
			If _HoverItem = n
				SetColor(60, 60, 60)
				SetAlpha(0.2)
				DrawText(i, _x+3, yy+3)
			EndIf
			SetScale(1, 1)
			SetAlpha(1)
			SetColor(0, 0, 0)
			DrawText(i, _x, yy)
			yy:+spacing
			n:+1
		Next
	
	End Method
	
	Method AddItem(name:String)
		_Items.AddLast(name)
	End Method
	
	Method GetMouseIndex:Int(x:Int, y:Int)
		If x < _x Return - 1
		If y < _y Return - 1
		
		Local spacing:Int = TextHeight("|") + 2
		Local longesttext:String
		
		If y > _y + spacing * _Items.Count() Return - 1
		
		For Local i:String = EachIn _Items
			If TextWidth(i) > TextWidth(longesttext) longesttext = i
		Next
		
		If x > _x + TextWidth(longesttext) Return - 1
		
		Local yy:Int = y - _y
		Local n:Int = yy / spacing
		
		If n >= 0 And n < _Items.Count()
			Return n
		EndIf
		
		Return - 1
	End Method
	
	Method TestInput:Int (id:Int, button:Int, x:Int, y:Int)

		Local n:Int = GetMouseIndex(x, y)
		If n >= 0 _Callback(n, String(_Items.ValueAtIndex(n)), Self, _context)
	
	EndMethod
	
	Method MouseMove(x:Int, y:Int)
		_HoverItem = GetMouseIndex(x, y)
	End Method
		
	Function InputHook:Object(id:Int, data:Object, context:Object)
		Assert data <> Null
		Assert context <> Null
		
		Local e:TEvent = TEvent(data)
		Select e.id
			Case EVENT_MOUSEDOWN
				If btMenu(context).TestInput(e.id, e.data, e.x, e.y) = False Then Return data Else Return Null
			Case EVENT_MOUSEMOVE
				btMenu(context).MouseMove(e.x, e.y)
		End Select
		
		Return data
	EndFunction
		
	Method SetCallback(func:Int(index:Int, Text:String, Menu:btMenu, data:Object))
		_Callback = func
	EndMethod
	
	Method SetContext(context:Object)
		_context = context
	End Method

	Method SetPosition(x:Float, y:Float)
		_x = x
		_y = y
	End Method
	
End Type


