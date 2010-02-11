
SuperStrict

Import "grid.bmx"

Type btGame

	Field _MainGrid:btGrid
	Field _NextGrid:btGrid[3]

	Field _w:Int, _h:Int
	Global _footsize:Int = 50
	Field _mainsize:Int, _headsize:Int = 100
	Field _Score:Int = 0
	Field _tx:Int, _ty:Int
	Field _timelimit:Int = 25000
	Field _deadline:Int = MilliSecs() + _timelimit
	Field _turnsleft:Int = -1

	Method Init:btGame(ScreenHeight:Int, w:Int = 5, h:Int = 5, timelimit:Int = 25000, _turns:Int = 35)
		_MainGrid = New btGrid.Init(w, h)
		SeedRnd(MilliSecs())
		For Local k:Int = 0 Until _NextGrid.Dimensions()[0]
			_NextGrid[k] = New btGrid.Init3by3Piece()
		Next
		
		SetSize(ScreenHeight)
		_timelimit = timelimit
		_deadline = MilliSecs() + _timelimit
		_turnsleft = _turns - _NextGrid.Dimensions()[0]
		Return Self
	End Method
	
	Method SetSize(ScreenHeight:Int)
		_headsize = ScreenHeight / 4
		
		_h = ScreenHeight
		_w = ScreenHeight - _footsize - _headsize
		
		_mainsize = Min(_w, _h - _footsize - _headsize)
		_headsize = _h - _footsize - _mainsize
	'	_headsize = _mainsize
	EndMethod
	
	Function GetWidthForHeight:Int(height:Int)
		Return height - (height / 4) - _footsize
	End Function
	
	Method Run()

		_MainGrid.TestPos(_tx, _ty, 10, _headsize + 10, _mainsize - 20, _mainsize - 20, MouseX(), MouseY())
		
		If MouseHit(MOUSE_LEFT)
			If _MainGrid.addgrid(_NextGrid[0], _tx - 1, _ty - 1) = 0
				NextPiece()
				_score:+_MainGrid.UpdateGrid()
				_DeadLine = MilliSecs() + _timelimit
			EndIf
		End If
		
		If MouseHit(MOUSE_RIGHT) Or MilliSecs() >= _Deadline
			NextPiece()
			_Score:-7
			_DeadLine = MilliSecs() + _timelimit
		End If

	End Method
	
	Method NextPiece()
		For Local n:Int = 0 Until _NextGrid.Dimensions()[0] - 1
			_NextGrid[n] = _NextGrid[n + 1]				
		Next
		
		If _turnsleft <> 0
		'	DebugStop
			_NextGrid[_NextGrid.Dimensions()[0] - 1] = New btGrid.Init3by3Piece()
			_turnsleft:-1
		Else
			_NextGrid[_NextGrid.Dimensions()[0] - 1] = New btGrid.Init(3, 3)
		EndIf
	End Method
	
	Method Render()
		SetAlpha(1)
		_MainGrid.Render(10, _headsize + 10, _mainsize - 20, _mainsize - 20, _NextGrid[0], _tx - 1, _ty - 1)
		
		_NextGrid[0].Render(_mainsize / 5 + 10, 10, _headsize - 10, _headsize - 10)

		_NextGrid[1].Render(10, _headsize / 2 + 5, _headsize / 2 - 7, _headsize / 2 - 7)
		_NextGrid[2].Render(10, 10, _headsize / 2 - 7, _headsize / 2 - 7)
		
		SetColor(255, 0, 0)
		DrawRect(Float(_mainsize / 5.0) + _headsize + 5, 10, (_w / 4) , (_headsize - 10) * ((Float(_DeadLine) - Float(MilliSecs())) / Float(_TimeLimit)))
		
		SetAlpha(0.8)
		SetColor(255, 255, 255)
		DrawRect(10, 10, _headsize / 2 - 7, _headsize / 2 - 7)
		SetColor(0, 0, 0)
		DrawText("Score: " + _Score, 10, _h - _footsize)
	End Method

EndType