
SuperStrict

Import "grid.bmx"

Type btGame

	Field _MainGrid:btGrid
	Field _NextGrid:btGrid[3]

	Field _w:Int, _h:Int
	Method Init(ScreenWidth:Int, ScreenHeight:Int)
		_MainGrid = New btGrid.Init(5, 5)
		For Local k:Int = 0 Until _NextGrid.Dimensions()[0]
			_NextGrid[k].Init(3, 3)
		Next
		
		_w = ScreenWidth
		_h = ScreenHeight
	End Method
	
	Method Run()
		
		Rem
		testgrid.Render(10, 130, 330, 330)
		addgrid.Render(100, 10, 115, 115)
		
		Local tx:Int, ty:Int
		testgrid.TestPos(tx, ty, 10, 130, 330, 330, MouseX(), MouseY())
		
		DrawText(tx + "," + ty, 030, 460)
		
		If MouseHit(MOUSE_LEFT)
			testgrid.addgrid(addgrid, tx, ty)
		End If	
		EndRem
	End Method
	
	Method Render()
		_MainGrid.Render(10, 130, _w - 20, _w - 20)
	End Method

EndType