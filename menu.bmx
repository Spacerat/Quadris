
SuperStrict

Import brl.max2d
Import brl.linkedlist
Import brl.hook
Import joe.advtext

Type btMenu

	Field _Items:TList = New TList
	Field _x:Float, _y:Float
	Field _context:Object
	Field _Callback:Int(index:Int, Text:String, Button:Int, Menu:btMenu, data:Object)
	Field _HoverItem:Int = -1
	Field _Spacing:Int = 20
	Field _Enabled:Int = False
	Method Initialise(func:Int(index:Int, Text:String, Button:Int, Menu:btMenu, data:Object), context:Object = Null)
		Enable()
		SetContext(context)
		SetCallback(func)
	End Method
	
	Method Enable()
		_Enabled = 1
		AddHook(EmitEventHook, btMenu.InputHook, Self)
	End Method
	
	Method Disable()
		_Enabled = 0
		RemoveHook(EmitEventHook, btMenu.InputHook, Self)
	End Method
	
	Method Render()
		Local sx:Float, sy:Float
		Local spacing:Int
		Local yy:Int = _y
		
		GetScale(sx, sy)
		spacing = sy * TextHeight("|") + _Spacing
		
		
		
		Local n:Int = 0
		SetBlend(ALPHABLEND)
		For Local i:btMenuItem = EachIn _Items
			DrawTextShadow(i.GetText(), _x, yy, 3, 3, (_HoverItem = n))
			yy:+spacing
			n:+1
		Next
	
	End Method
	
	Method AddItem(name:String)
		_Items.AddLast(New btMenuItem.Init(name))
	End Method
	
	Method ChangeItem(index:Int, name:String)
		btMenuItem(_Items.ValueAtIndex(index)).SetText(name)
	End Method
	
	Method GetMouseIndex:Int(x:Int, y:Int)
		If x < _x Return - 1
		If y < _y Return - 1
		
		Local sx:Float, sy:Float
		Local spacing:Int
		
		GetScale(sx, sy)
		spacing = sy * TextHeight("|") + _Spacing
		
		Local longesttext:String
		
		If y > _y + spacing * _Items.Count() Return - 1
		
		For Local i:btMenuItem = EachIn _Items
			If TextWidth(i.GetText()) > TextWidth(longesttext) longesttext = i.GetText()
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
		If n >= 0 _Callback(n, GetText(n), Button:Int, Self, _context)
	
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
	
	Method SetCallback(func:Int(index:Int, Text:String, Button:Int, Menu:btMenu, data:Object))
		_Callback = func
	EndMethod
	
	Method SetContext(context:Object)
		_context = context
	End Method

	Method SetPosition(x:Float, y:Float)
		_x = x
		_y = y
	End Method
	
	Method SetSpacing(spacing:Int)
		_Spacing = spacing
	End Method
	
	Method IsEnabled:Int()
		Return _Enabled
	End Method
	
	Method GetItem:btMenuItem(index:Int)
		Return btMenuItem(_Items.ValueAtIndex(index))
	End Method
	
	Method GetText:String(index:Int)
		Return GetItem(index).GetText()
	End Method
	
End Type

Type btMenuItem
	Field _text:String
	
	Method Init:btMenuItem(text:String)
		SetText(Text)
		Return Self
	End Method
	
	Method SetText(text:String)
		_text = Text
	End Method
	
	Method GetText:String()
		Return _text
	End Method
	
EndType
