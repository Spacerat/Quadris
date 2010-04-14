
SuperStrict

Import "grid.bmx"
Import "state.bmx"
Import "settings.bmx"
Import joe.advtext

Type btGame Extends btState

	Field _MainGrid:btGrid
	Field _NextGrid:btGrid[3]

	Field _xoffset:Int = 0, _yoffset:Int = 0
	Field _w:Int, _h:Int
	Global _footsize:Int = 50
	Field _mainsize:Int, _headsize:Int = 100
	Field _tx:Int, _ty:Int
	Field _timelimit:Int = 25000
	Field _deadline:Int = MilliSecs() + _timelimit
	Field _turnsleft:Int = -1
	Field _movecounter:Int = 0
	Field _Font:TImageFont
	Field _Score:Int[]
	Field _Skips:Int[]
	Field _SkipLimit:Int = -1
	Field _Players:Int = 1
	Field _Player:Int = 0
	Field _GameOver:Int = False
	Field _Title:String = "Game"
	
	Method Init:btGame(title:String, w:Int = 0, h:Int = 0, players:Int = 1, seed:Int = 0)', timelimit:Int = 25000, _turns:Int = 35, _skips:Int = -1, seed:Int = 0)
		FlushKeys()
		FlushMouse()
		_Font = LoadImageFont("incbin::ARLRDBD.TTF", 22)
		_MainGrid = New btGrid.Init(w, h)
		If seed = 0 SeedRnd(MilliSecs()) Else SeedRnd(seed)
		
		InitPieces()
		
		SetTitle(title)
		InitPlayers(players)
		SetSkipLimit(btSettings.Skips)
		SetSize(btSettings.Height)
		SetTimeLimit(btSettings.Movetime)
		SetTurnsLimit(btSettings.Moves)
		Return Self
	End Method
	
	Method InitPieces()
		For Local k:Int = 0 Until _NextGrid.Dimensions()[0]
			_NextGrid[k] = New btGrid.Init3by3Piece()
		Next		
	End Method
	
	Method SetTitle(t:String)
		_Title = t
	End Method
	
	Method InitPlayers(num:Int)
		_Score = New Int[num]
		_Skips = New Int[num]
		_Players = num
		_Player = 0
	End Method
	
	Method SetTimeLimit(msecs:Int)
		_timelimit = msecs
		_deadline = MilliSecs() + _timelimit
	End Method
	
	Method SetTurnsLimit(turns:Int)
		_turnsleft = turns
	End Method
	
	Method SetSkipLimit(skips:Int)
		_SkipLimit = skips
		For Local n:Int = 0 Until _Players
			_Skips[n] = _Skiplimit
		Next
	End Method
	
	Method SetSize(ScreenHeight:Int)
		_headsize = ScreenHeight / 4
		
		_h = ScreenHeight
		_w = ScreenHeight - _footsize - _headsize
		
		_mainsize = Min(_w, _h - _footsize - _headsize)
		_headsize = _h - _footsize - _mainsize
	'	_headsize = _mainsize
	EndMethod
	
	Method GameOver()
		_GameOver = True
	End Method
	
	Method IsGameOver:Int()
		Return _GameOver
	End Method
	
	Function GetWidthForHeight:Int(height:Int)
		Return height - (height / 4) - _footsize
	End Function
	
	Method Run()
		If KeyHit(KEY_ESCAPE)
			CurrentState = Null
		End If
		
		If Not IsGameOver()
			_MainGrid.TestPos(_tx, _ty, 10, _headsize + 10, _mainsize - 20, _mainsize - 20, MouseX(), MouseY())
			
			If MouseHit(MOUSE_LEFT)
				Local score:Int = PlacePiece(_tx - 1, _ty - 1)
				If score >= 0
					AddScore(score)
					NextPlayer()
				EndIf
				If score = -2 Or GetRemainingMoves() = 0
					GameOver()
				EndIf
			End If
			
			If (MouseHit(MOUSE_RIGHT) Or MilliSecs() >= _Deadline) And GetRemainingMoves() <> 0
				SkipPiece()
			End If
		Else
			If MouseHit(MOUSE_LEFT)
				CurrentState = Null
			End If
		EndIf
	End Method
	
	Method PlacePiece:Int(x:Int, y:Int)
		If GetRemainingMoves() = 0 Return - 2
		If _MainGrid.addgrid(_NextGrid[0], x, y) = 0
			NextPiece()
			_movecounter:+1
			_DeadLine = MilliSecs() + _timelimit
			Return _MainGrid.UpdateGrid()
		Else
			Return - 1
		EndIf
	End Method
	
	Method AddScore(n:Int)
		If Not isGameOver()
			_Score[_Player]:+n
		End If
	End Method
	
	Method SkipPiece()
		_Skips[_Player]:-1
		If _Skips[_Player] = - 1 Or GetRemainingMoves() = 0 GameOver()
		
		NextPiece()
		NextPlayer()
		AddScore(- 7)
		
		_DeadLine = MilliSecs() + _timelimit
	End Method
	
	Method SetOffset(x:Int, y:Int)
		_xoffset = x
		_yoffset = y
	End Method
	
	Method NextPiece()
		For Local n:Int = 0 Until _NextGrid.Dimensions()[0] - 1
			_NextGrid[n] = _NextGrid[n + 1]				
		Next
		
		If _turnsleft > _NextGrid.Dimensions()[0] Or _turnsleft < 0
			_NextGrid[_NextGrid.Dimensions()[0] - 1] = New btGrid.Init3by3Piece()
			_turnsleft:-1
		Else
			_NextGrid[_NextGrid.Dimensions()[0] - 1] = New btGrid.Init(3, 3)
			_turnsleft:-1
		EndIf
	End Method
	
	Method NextPlayer()

		_Player:+1
		If _Player >= _Players Then _Player = 0
	End Method
	
	Method GetRemainingMoves:Int()
		Return _turnsleft
	End Method
	
	Method Render()
		SetAlpha(1)
		SetScale(1, 1)
		SetImageFont(_Font)
		SetOrigin(_xoffset, _yoffset)
		_MainGrid.Render(10, _headsize + 10, _mainsize - 20, _mainsize - 20, _NextGrid[0], _tx - 1, _ty - 1)
		
		_NextGrid[0].Render(_mainsize / 5 + 10, 10, _headsize - 10, _headsize - 10)

		_NextGrid[1].Render(10, _headsize / 2 + 5, _headsize / 2 - 7, _headsize / 2 - 7)
		_NextGrid[2].Render(10, 10, _headsize / 2 - 7, _headsize / 2 - 7)
		SetAlpha(0.8)
		SetColor(255, 255, 255)
		DrawRect(10, 10, _headsize / 2 - 7, _headsize / 2 - 7)
		If Not isGameOver()
		
			SetColor(255, 0, 0)
			DrawRect(Float(_mainsize / 5.0) + _headsize + 5, 10, (_w / 4) , (_headsize - 10) * ((Float(_DeadLine) - Float(MilliSecs())) / Float(_TimeLimit)))

		EndIf
		SetAlpha(1)
		
	End Method

EndType

Type btStandardGame Extends btGame
	
	Method Render()
		Super.Render()
		SetColor(0, 0, 0)
		DrawText("Score: " + _Score[0], 10, _h - _footsize)
		If _turnsleft >= 0
			DrawText("Moves: " + GetRemainingMoves(), 10, _h - _footsize + 20)
		Else
			DrawText("Moves: " + _movecounter, 10, _h - _footsize + 20)
		EndIf
		
		If _Skips[0] >= 0
			DrawText("Skips: " + _Skips[0], _w / 2, _h - _footsize)
		End If
		
		SetColor(0, 0, 100)
		If isGameOver()
			DrawTextCentred("Game Over!", _w / 2, _h / 2)
			DrawTextCentred(_Title + " Score of " + _Score[0], _w / 2, _h / 2 + 30)
			DrawTextCentred("Click to continue.", _w / 2, _h / 2 + 60)
		End If		
	End Method
	
	Method InitPieces()
		'Create a set of all possible pieces in order
		Local l:Int = btGrid.GetPieceArray().Dimensions()[0]

		_NextGrid = New btGrid[l]
		
		For Local i:Int = 0 Until l
			_NextGrid[i] = New btGrid.Init3by3Piece(i)
		Next
		
		'Shuffle the set
		Local n:Int = l
		While n > 1
			Local k:Int = Rand(0, n - 1)
			n:-1
			Local tmp:btGrid = _NextGrid[k]
			_NextGrid[k] = _NextGrid[n]
			_NextGrid[n] = tmp
		WEnd
				
	End Method
	
End Type

Type btHotseatGame Extends btGame
	
	Method Render()
		Super.Render()
		SetBlend(ALPHABLEND)
		SetColor(0, 0, 0)
		If _Player = 0 SetAlpha(1) Else SetAlpha(0.5)
		DrawText("P1 Score: " + _Score[0], 10, _h - _footsize)
		If _Skips[0] >= 0 DrawText("Skips: " + _Skips[0], _w / 2, _h - _footsize)
		If _Player = 1 SetAlpha(1) Else SetAlpha(0.5)
		DrawText("P2 Score: " + _Score[1], 10, _h - _footsize + 20)
		If _Skips[1] >= 0 DrawText("Skips: " + _Skips[1], _w / 2, _h - _footsize + 20)
		SetAlpha(1)
		
		SetColor(0, 0, 100)
		If isGameOver()
			DrawTextCentred("Game Over!", _w / 2, _h / 2)
			DrawTextCentred("Click to continue.", (_w / 2), _h / 2 + 30)
		End If			
		
	End Method	
	
	
End Type