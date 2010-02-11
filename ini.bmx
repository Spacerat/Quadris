' Code for handling INI files, taken from BlitzBasic forums, by Perturbatio
' http://www.blitzmax.com/codearcs/codearcs.php?code=1890
' Modified by Chris Eykamp to make it more flexible
' Code in this section is public domain

' CE   Apr-2007 Better support for comments and whitespace in INI file
' CE 26-Apr-2007 Fixed problem with empty values (lines that look like key =)

SuperStrict

Import brl.filesystem
Import brl.linkedlist
Import brl.map

Function Trim:String(xs:String) 
	Return xs.Trim() 
End Function

Function SplitString:TList(inString:String, Delim:String)
	Local tempList : TList = New TList
	Local currentChar : String = ""
	Local count : Int = 0
	Local TokenStart : Int = 0
	
	If Len(Delim)<1 Then Return Null
	
	inString = Trim(inString)
	
	For count = 0 Until Len(inString)
		If inString[count..count+1] = delim Then
			tempList.AddLast(inString[TokenStart..Count])
			TokenStart = count + 1
		End If
	Next
	tempList.AddLast(inString[TokenStart..Count])	
	Return tempList
End Function


Type TIniSection
	Field Name:String
	Field Values:TMap
	
	
	Method SetValue(key:String, value:Object)
		Values.Insert(Key, Value)
	End Method
	
	
	Method GetValue:String(Key:String)
		Return String(Values.ValueForKey(Key))
	End Method
	
	
	Method DeleteValue(Key:String)
		Values.Remove(Key)
	End Method
	
	
	Method GetSectionText:String()
		Local result:String = "["+Name+"]~r~n"
		
		For Local s:Object = EachIn Values.keys()
			result = result + String(s) + "=" + String(Values.ValueForKey(s)) + "~r~n"
		Next
		
		Return result+"~r~n"
	End Method
	
	
	Function Create:TIniSection(name:String)
		Local tempSection:TIniSection = New TIniSection
			tempSection.name = name
			tempSection.Values = New TMap
		Return tempSection
	End Function
	
End Type



Type TSectionList
	Field _Sections:TIniSection[]
	
	Method GetSection:TIniSection(sectionName:String)
	
		For Local section:TIniSection = EachIn _Sections
			If section.Name = sectionName Then Return section
		Next
		
		Return Null
		
	End Method
	
	
	Method AddSection:TIniSection(sectionName:String)
		Local currentLength:Int = Len(_Sections)
		
			_Sections = _Sections[..currentLength+1]
			_Sections[currentLength] = TIniSection.Create(sectionName)
		
		Return _Sections[currentLength]
	End Method
	
	
	Method RemoveSection:Int(sectionName:String)
		Local currentLength:Int = Len(_Sections)
		
		For Local i:Int = 0 To currentLength-1
			If _Sections[i].Name = sectionName Then
				If i < currentLength-1 Then
					For Local x:Int = i To currentLength-2
						_Sections[x] = _Sections[x+1]
					Next
				EndIf
				_Sections = _Sections[..currentLength-1]
				
				Return True
				
			EndIf
		Next
		
		Return False
	End Method
	
	
	Function Create:TSectionList()
		Local tempSectionList:TSectionList = New TSectionList
			
		Return tempSectionList
	End Function
	
End Type



Type TPertIni
	Field Filename:String
	Field Loaded:Int
	Field Saved:Int
	Field Sections:TSectionList
	
	
	Method Load:Int()
		Local file:TStream
		Local line:String
		Local tempList:TList
		Local tempArray:Object[]
		Local currentSection:String = ""
		Local error:String
		Local v:String
		
		
		If FileType(Filename) = 1 Then

			file:TStream = ReadStream(FileName)
			
			While Not Eof(file)
				
				line = cleanVal(ReadLine(file))
				
				
				If Not (Line[..1] = ";") Then		' Skip lines that are just comments
					
					If Line[..1] = "[" And Line[Len(Line)-1..] = "]" Then
						currentSection = Line[1..Len(Line)-1]
						
						AddSection(currentSection)
					Else
						If Len(currentSection) > 0 And Len(line) > 0 Then
							tempArray = smartSplit(Line, "=")
							If tempArray <> Null
							
								If tempArray.length > 1 Then
									v = String(tempArray[1]).Trim()
								Else
									v = ""
								EndIf
								
								SetSectionValue(currentSection, String(tempArray[0]).Trim(), v)
							EndIf
						Else If Len(Line) > 0 Then
							Return False 'no section header found'
						EndIf
					EndIf
				EndIf
			Wend
			
			CloseStream(file)
		
		EndIf
		
		Return False
	End Method
	
	
	Method Save:Int(Overwrite:Int = False)
		Local file:TStream
		Local ft:Int = FileType(Filename)
		
		If ft = 0  Or (ft = 1 And Overwrite = True) Then
			file:TStream = WriteStream(FileName)
			WriteString(file, GetIniText())
			CloseStream(file)
		Else
			Return False
		EndIf
		
	End Method
	
	
	Method AddSection:TIniSection(sectionName:String)
		Return Sections.AddSection(sectionName)
	End Method
	
	
	Method GetSection:TIniSection(sectionName:String)
		Return Sections.GetSection(sectionName)
	End Method
	
	
	Method SetSectionValue(sectionName:String, key:String, value:String)
		For Local i:Int = 0 To Len(Sections._Sections) -1
			If Sections._Sections[i].name = sectionName Then
				Sections._Sections[i].SetValue(key, value)
				Return
			EndIf
		Next
	End Method
	
	
	Method DeleteSectionValue(sectionName:String, key:String)
		For Local i:Int = 0 To Len(Sections._Sections) -1
			If Sections._Sections[i].name = sectionName Then
				Sections._Sections[i].DeleteValue(key)
				Return
			EndIf
		Next
	End Method
	
	
	Method GetSectionValue:String(sectionName:String, key:String)
		For Local i:Int = 0 To Len(Sections._Sections) -1
			If Sections._Sections[i].name = sectionName Then
				Return Sections._Sections[i].GetValue(key)
			EndIf
		Next
	End Method
	
	
	Method GetIniText:String()
		Local result:String
			For Local section:TIniSection = EachIn Sections._Sections
				 result:+section.GetSectionText()
			Next
		Return result
	End Method
	
	
	Function Create:TPertIni(filename:String)
		Local tempIni:TPertIni = New TPertIni
			tempIni.Filename = filename
			tempIni.Sections:TSectionList = TSectionList.Create()
		Return tempIni
	End Function
End Type





'###############################################################################
' Trim any whitespace or comments from value

Function cleanVal:String(s:String)
	
	If s Then Return smartSplit(s.Trim(),";")[0] Else Return Null

End Function

'###############################################################################
' Split a string into substrings
' From http://www.blitzbasic.com/codearcs/codearcs.php?code=1560
' by CoderLaureate, bug fix by Chris Eykamp
' This code has been declared by its author to be Public Domain code.

Function SmartSplit:String[](str:String, dels:String, text_qual:String = "~q")
	Local Parms:String[] = New String[1]
	Local pPtr:Int = 0
	Local chPtr:Int = 0
	Local delPtr:Int = 0
	Local qt:Int = False
	Local str2:String = ""
	
	Repeat
		Local del:String = Chr(dels[delPtr])
		Local ch:String = Chr(str[chPtr])
		If ch = text_qual Then 
			If qt = False Then
				qt = True
			Else
				qt = False
			End If
		End If
		If ch = del Then
			If qt = True Then str2:+ ch
		Else
			str2:+ ch
		End If
		If ch = del Or chPtr = str.Length - 1 Then
			If qt = False Then
				Parms[pPtr] = str2.Trim()
				str2 = ""
				pPtr:+ 1
				Parms = Parms[..pPtr + 1]
				If dels.length > 1 And delPtr < dels.length Then delPtr:+ 1
			End If
		End If
		chPtr:+ 1
		If chPtr >= str.Length Then Exit
	Forever
	If Parms.Length > 1 Then Parms = Parms[..Parms.Length - 1]
	Return Parms
			
End Function

Function IniLoadDef:String(ini:TPertIni, section:String, Key:String, def:String)
	If ini.GetSection(section) = Null
		ini.AddSection(section) 
		ini.SetSectionValue(section, key, def) 
	ElseIf ini.GetSectionValue(section, key) = Null
		ini.SetSectionValue(section, key, def) 
	EndIf
	Return ini.GetSectionValue(section, key) 
End Function