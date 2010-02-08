
SuperStrict

Import joe.colour

Type btGrid
	
	Global _effects:Int = 1

	Field _Grid:Int[,]
	Field _w:Int
	Field _h:Int
	
	Field _colEmpty:TColour = TColour.Silver()
	Field _colFilled:TColour = TColour.Orange()
	Field _colSelected:TColour = TColour.Lime()
	Field _colLines:TColour = TColour.Black()
	
	Rem
	bbdoc: Initialises the grid
	returns: self
	Endrem
	Method Init:btGrid(w:Int, h:Int)
		Assert (w > 0 And h > 0)
		
		_Grid = New Int[w, h]
		_w = w
		_h = h

		Return Self
	End Method
	
	
	
	Rem
	bbdoc: If possible, adds a grid to this grid
	returns: 0 if successful, other numbers otherwise.
	EndRem
	Method AddGrid:Int(grid:btGrid, xcoord:Int, ycoord:Int)
		For Local xx:Int = xcoord Until (xcoord + grid.GetWidth())
			For Local yy:Int = ycoord Until (ycoord + grid.GetHeight())
				If (grid._Grid[xx - xcoord, yy - ycoord] = 1)
					Local res:Int = FillGrid(xx, yy, False)
					If (res <> 0) Return res
				EndIf
			Next
		Next

		For Local xx:Int = xcoord Until (xcoord + grid.GetWidth())
			For Local yy:Int = ycoord Until (ycoord + grid.GetHeight())
				If (grid._Grid[xx - xcoord, yy - ycoord] = 1)
					FillGrid(xx, yy)
				EndIf
			Next
		Next
				
	End Method

	Rem
	bbdoc: Fills a grid box
	returns: 0 if successful
	EndRem
	Method FillGrid:Int(x:Int, y:Int, fill:Int = True)
	
		If x < 0 Or y < 0 Or x >= GetWidth() Or y >= GetHeight()
			'Cannot fill outside grid
			Return 1
		EndIf
		If _Grid[x, y] = 1
			'Cannot fill a filled square
			Return 2
		End If
		If (fill) _Grid[x, y] = 1
		
	End Method
	
	Rem
	bbdoc: Update the grid
	returns: Score increase.
	EndRem
	Method UpdateGrid:Int()

	EndMethod
	
	Rem
	bbdoc: Render the grid
	EndRem
	Method Render(x:Int, y:Int, width:Int, height:Int)
		Local blockw:Float = width / GetWidth()
		Local blockh:Float = height / GetHeight()
		SetBlend(ALPHABLEND)
		_colLines.Set()
		DrawRect(x, y, width, height)
		Local vpx:Int, vpy:Int, vpw:Int, vph:Int
		
		If (_effects)
			GetViewport(vpx, vpy, vpw, vph)
		EndIf
		For Local xx:Int = 0 Until GetWidth()
			For Local yy:Int = 0 Until GetHeight()
				SetAlpha(1)
				Select _Grid[xx, yy]
					Case 0
						_colEmpty.Set()
					Case 1
						_colFilled.Set()
					Case 2
						_colSelected.Set()
				EndSelect
			'   DrawRect(x + xx * blockw + 1, y + yy * blockh + 1, blockw - 2, blockh - 2)

				If (_effects) SetViewport(x + xx * blockw + 1, y + yy * blockh + 1, blockw - 2, blockh - 2)
				
				DrawRect(x + xx * blockw + 1, y + yy * blockh + 1, blockw - 2, blockh - 2)
				
				If (_effects)
					TColour.White(0.6).Set()
					DrawOval(x + xx * blockw - (blockw / 3.0), y + yy * blockh - (blockh / 2.0), blockw * (5.0 / 3.0), blockh)
				EndIf
			Next
		Next
		
		If (_effects)
			SetViewport(vpx, vpy, vpw, vph)
		EndIf
		

	End Method
	
	Method TestPos(resultX:Int Var, resultY:Int Var, x:Float, y:Float, w:Float, h:Float, px:Int, py:Int)
		px = px - x
		py = py - y
		
		IF KeyDown(KEY_J) DebugStop
		
		resultX = Floor(px / (w / GetWidth()))
		resultY = Floor(py / (h / GetHeight()))
		
		If resultX < 0 Or ResultX >= GetWidth() Or ResultY < 0 Or ResultY >= GetHeight()
			resultX = -1
			resultY = -1
		EndIf
		
	EndMethod
	
	Rem
	bbdoc: Get the number of columns
	EndRem
	Method GetWidth:Int()
		Return _w
	End Method
	
	Rem
	bbdoc: Get the number of rows
	Endrem
	Method GetHeight:Int()
		Return _h
	End Method

EndType
