
SuperStrict

Import joe.colour
Import brl.random
Import "settings.bmx"

Type btGrid
	
	Field _Grid:Int[,]
	Field _w:Int
	Field _h:Int
	
	Field _colEmpty:TColour = TColour.Silver()
	Field _colFilled:TColour = TColour.Orange()
	Field _colSelected:TColour = TColour.Lime()
	Field _colImpossible:TColour = TColour.Red()
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
	
	Method Init3by3Piece:btGrid(piece:Int = -1)
		Init(3, 3)
		Local b:Int[][][] = GetPieceArray()
		If (piece = -1) piece = Rand(0, b.dimensions()[0] - 1)

		For Local xx:Int = 0 To 2
			For Local yy:Int = 0 To 2
				_Grid[xx, yy] = b[piece][yy][xx]
			Next
		Next
		
		Return Self
	EndMethod
		
	Function GetPieceArray:Int[][][] ()
	
		Local b:Int[][][]
		b = [[ ..			'Three pronged pieces
		[0, 1, 0],  ..
		[1, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[0, 1, 0],  ..
		[0, 1, 1],  ..
		[0, 1, 0] ], [ ..
..
		[0, 0, 0],  ..
		[1, 1, 1],  ..
		[0, 1, 0] ], [ ..
..
		[0, 1, 0],  ..
		[1, 1, 0],  ..
		[0, 1, 0] ], [ ..
..
		[0, 0, 0],  ..		'Straight lines
		[1, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[0, 1, 0],  ..
		[0, 1, 0],  ..
		[0, 1, 0] ], [ ..
..
		[0, 1, 0],  ..		'L pieces
		[0, 1, 0],  ..
		[0, 1, 1] ], [ ..
..
		[0, 0, 1],  ..
		[1, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[1, 1, 0],  ..
		[0, 1, 0],  ..
		[0, 1, 0] ], [ ..
..
		[0, 0, 0],  ..
		[1, 1, 1],  ..
		[1, 0, 0] ], [ ..
..
		[0, 1, 0],  ..		'J pieces
		[0, 1, 0],  ..
		[1, 1, 0] ], [ ..
..
		[0, 0, 0],  ..
		[1, 1, 1],  ..
		[0, 0, 1] ], [ ..
..
		[0, 1, 1],  ..
		[0, 1, 0],  ..
		[0, 1, 0] ], [ ..
..
		[1, 0, 0],  ..
		[1, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[0, 0, 0],  ..		'.
		[0, 1, 0],  ..
		[0, 0, 0] ], [ ..
..
		[0, 0, 0],  ..		'Small L pieces
		[0, 1, 1],  ..
		[0, 1, 0] ], [ ..
..
		[0, 1, 0],  ..
		[0, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[0, 1, 0],  ..
		[1, 1, 0],  ..
		[0, 0, 0] ], [ ..
..
		[0, 0, 0],  ..
		[1, 1, 0],  ..
		[0, 1, 0] ], [ ..
..
		[0, 0, 0],  ..		'Two piece lines
		[0, 1, 0],  ..
		[0, 1, 0] ], [ ..
..
		[0, 0, 0],  ..		'Two piece lines
		[0, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[0, 1, 1],  ..		'S
		[1, 1, 0],  ..
		[0, 0, 0] ], [ ..
..
		[0, 1, 0],  ..
		[0, 1, 1],  ..
		[0, 0, 1] ], [ ..
..
		[0, 1, 0],  ..		'Z
		[1, 1, 0],  ..
		[1, 0, 0] ], [ ..
..
		[1, 1, 0],  ..
		[0, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[1, 0, 1],  ..		'X
		[0, 1, 0],  ..
		[1, 0, 1] ], [ ..
..
		[0, 1, 0],  ..		'+
		[1, 1, 1],  ..
		[0, 1, 0] ], [ ..
..
		[1, 0, 0],  ..		'\ long
		[0, 1, 0],  ..
		[0, 0, 1] ], [ ..
..
		[0, 0, 1],  ..		'/ long
		[0, 1, 0],  ..
		[1, 0, 0] ], [ ..
..
		[0, 0, 1],  ..		'/ short
		[0, 1, 0],  ..
		[0, 0, 0] ], [ ..
..
		[1, 0, 0],  ..		'\ short
		[0, 1, 0],  ..
		[0, 0, 0] ], [ ..
..
		[0, 0, 0],  ..		'n
		[1, 1, 1],  ..
		[1, 0, 1] ], [ ..
..
		[1, 0, 1],  ..		'u
		[1, 1, 1],  ..
		[0, 0, 0] ], [ ..
..
		[0, 1, 1],  ..		'<
		[0, 1, 0],  ..
		[0, 1, 1] ], [ ..
..
		[1, 1, 0],  ..		'>
		[0, 1, 0],  ..
		[1, 1, 0] ] ]

		Return b
	End Function
	
	
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
	
	Method EraseRect:Int(x:Int, y:Int, w:Int, h:Int)
		For Local xx:Int = Max(0, x) Until Min(x + w, _w)
			For Local yy:Int = Max(0, y) Until Min(y + h, _h)
				EraseBlock(xx, yy)
			Next
		Next
	EndMethod

	Method EraseBlock(x:Int, y:Int)
		_Grid[x, y] = - btSettings.FadeTime
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
		
		Local ret:Int = 0
	
		For Local yy:Int = 0 Until _h
	
			For Local xx:Int = 0 Until _w
				
			If CheckRect(xx, yy, 3, 3) = True
				EraseRect(xx, yy, 3, 3)
				ret:+30
			EndIf
				
			If CheckRect(xx, yy, 3, 2) = True
				EraseRect(xx, yy, 3, 2)
				ret:+15
			EndIf
			
			If CheckRect(xx, yy, 2, 3) = True
				EraseRect(xx, yy, 2, 3)
				ret:+15
			EndIf
			
			If CheckRect(xx, yy, 2, 2) = True
				EraseRect(xx, yy, 2, 2)
				ret:+5
			EndIf
			
			Next
		Next
		
		Return ret
		
	EndMethod
	
	Method CheckRect:Int(x1:Int, y1:Int, w:Int, h:Int)
		For Local xx:Int = x1 Until x1 + w
			For Local yy:Int = y1 Until y1 + h
				If GetGrid(xx, yy) <= 0 Return 0
			Next
		Next
		Return 1
	End Method
	
	Method GetGrid:Int(x:Int, y:Int)
		If x < 0 Or x >= _w Or y < 0 Or y >= _h
			Return - 1
		Else
			Return _Grid[x, y]
		EndIf
		
	End Method
	
	Rem
	bbdoc: Render the grid
	EndRem
	Method Render(x:Int, y:Int, width:Int, height:Int, superimpose:btGrid = Null, sx:Int = 0, sy:Int = 0)
		Local blockw:Int = width / GetWidth()
		Local blockh:Int = height / GetHeight()
		Local vpx:Int, vpy:Int, vpw:Int, vph:Int 'Viewport
		Local hx:Float, hy:Float				'Handle
		
		SetBlend(ALPHABLEND)
		SetAlpha(1)
		_colLines.Set()
		DrawRect(x, y, blockw * GetWidth(), blockh * GetHeight())

		GetOrigin(hx, hy)
		If (btSettings.Glass)
			GetViewport(vpx, vpy, vpw, vph)
		EndIf
		For Local xx:Int = 0 Until GetWidth()
			For Local yy:Int = 0 Until GetHeight()
				SetAlpha(1)
				
				If _Grid[xx, yy] > 0
					_colFilled.Set()		
				Else
					_colEmpty.Set()
				EndIf
				
				If (superimpose)
					If xx >= sx If yy >= sy If xx - sx <= superimpose.GetWidth() - 1 If yy - sy <= superimpose.GetHeight() - 1
						
						If superimpose.GetGrid(xx - sx, yy - sy) = 1
							If GetGrid(xx, yy) = 1
								_colImpossible.Set()
							Else
								_colSelected.Set()
							EndIf
						EndIf
					EndIf
				EndIf
				
			'   DrawRect(x + xx * blockw + 1, y + yy * blockh + 1, blockw - 2, blockh - 2)
				Rem
				If (_effects)

					SetViewport(x + xx * blockw + 1 + hx, y + yy * blockh + 1 + hy, blockw - 2, blockh - 2)
				EndIf
				DrawRect(x + xx * blockw + 1, y + yy * blockh + 1, blockw - 2, blockh - 2)
				
				If (_effects)
					TColour.White(0.4).Set()
					DrawOval(x + xx * blockw - (blockw / 3.0), y + yy * blockh - (blockh / 2.0), blockw * (5.0 / 3.0), blockh)
				EndIf
				EndRem
				RenderBlock(x + xx * blockw, y + yy * blockh, blockw, blockh)
				
				If _Grid[xx, yy] < 0
					_colFilled.Set()
					SetAlpha((- 1 * GetGrid(xx, yy)) / btSettings.FadeTime)
					
					RenderBlock(x + xx * blockw, y + yy * blockh, blockw, blockh)
					
					SetBlend(LIGHTBLEND)
					'Quadratic equation
					Local t:Float = GetGrid(xx, yy)
					Local k:Float = btSettings.FadeTime
					Local c:Float = -(((t) * (t + k)) / ((k / 2) ^ 2)) * 100
					SetColor(c, c, c)
					DrawRect(x + xx * blockw, y + yy * blockh, blockw, blockh)
					SetBlend(ALPHABLEND)
					
					
					_Grid[xx, yy]:+1
				End If
			Next
		Next
		
		If (btSettings.Glass)
			SetViewport(vpx, vpy, vpw, vph)
		EndIf

	End Method
	
	Function RenderBlock(x:Float, y:Float, w:Float, h:Float)
		Local hx:Float, hy:Float				'Handle
		GetOrigin(hx, hy)
		
		If (btSettings.Glass)

			SetViewport(x + hx + 1, y + hy + 1, w - 2, h - 2)
		EndIf
		DrawRect(x + 1, y + 1, w - 2, h - 2)
		
		If (btSettings.Glass)
			TColour.White(0.4).Set()
			DrawOval(x - (w / 3.0), y - (h / 2.0), w * (5.0 / 3.0), h)
		EndIf
		
	End Function
	
	Method TestPos(resultX:Int Var, resultY:Int Var, x:Float, y:Float, w:Float, h:Float, px:Int, py:Int)
		Local hx:Float, hy:Float
		GetOrigin(hx, hy)
		px = px - x - hx
		py = py - y - hy
		
		
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
