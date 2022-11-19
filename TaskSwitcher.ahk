#SingleInstance, 	force		; Only one instance of this script may run at a time!
#NoEnv  						; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  	     				; Enable warnings to assist with detecting common errors.
#Requires, AutoHotkey v1.1.34+ 	; Displays an error and quits if a version requirement is not met.
#KeyHistory, 		100			; For debugging purposes.
#LTrim						; Omits spaces and tabs at the beginning of each line. This is primarily used to allow the continuation section to be indented. Also, this option may be turned on for multiple continuation sections by specifying #LTrim on a line by itself. #LTrim is positional: it affects all continuation sections physically beneath it.
#InstallKeybdHook
#MaxHotkeysPerInterval, 1000
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

;reset przez nacisniecie i przytrzymanie obu przyciskow np. przez 5 s.
;po resecie uzytkownik oznaczy unikalne okna i okna zdublowane?

global 	v_CurrWindow 	:= 0
	,	AppVersion	:= "0.9.0"
	,	v_NoClass		:= 0
	,	v_WindowTitle	:= ""
	,	v_WindowClass	:= ""
	,	a_WTitle_WClass	:= {}	;global associative array
	,	v_TotalWindows := F_HowManyWindows()

LWin & LAlt::
	++v_CurrWindow
	v_NoClass := 0
	if (v_CurrWindow > v_TotalWindows) or (v_CurrWindow > 9)
		v_CurrWindow := 1
	
	OutputDebug, % "v_CurrWindow:" . A_Space . v_CurrWindow . "`n"
	Send, % "#" . v_CurrWindow . "{Enter}"
	WinActivate, 	A
	F_IfUnique()
	; MsgBox Prawo
return

LAlt & LWin Up::
	--v_CurrWindow
	if (v_CurrWindow > v_TotalWindows) or (v_CurrWindow < 1)
		v_CurrWindow := v_TotalWindows
	Send, % "#" . v_CurrWindow . "{Enter}"
	; OutputDebug, % "down:" . A_Space . v_CurrWindow . "`n"
	; MSgbox Lewo
return

; - - - - - - - BLOCK OF FUNCTIONS - BEGINNING - - - - - - - - 
F_IfUnique()
{
	global
	local	WindowTitle	:= ""
		,	WindowClass	:= ""
		,	counter		:= 0
		,	key			:= ""
		,	value		:= ""

	WinGetTitle, 	WindowTitle, 	A
	OutputDebug, % "WindowTitle:" . A_Space . WindowTitle . "`n"
	WinGetClass, 	WindowClass, 	% WindowTitle

	for key, value in a_WTitle_WClass
		if (value == WindowClass)
			counter++
	OutputDebug, % "counter:" . A_Space . counter . "`n"
	return counter
}
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
F_HowManyWindows()
{
	global
	local NoWindows 		:= 0
		, id 			:= ""
		, row 			:= ""
		, WindowTitle 		:= ""
		, HowManyWindows 	:= 0
		, WindowClass 		:= ""

	WinGet, NoWindows, List
	Loop, % NoWindows
	{
		id := NoWindows%A_Index%
		WinGetTitle, WindowTitle, ahk_id %id%
		WinGetClass, WindowClass, % WindowTitle
		if (WindowTitle) and (WindowTitle != "Program Manager")
		{
			a_WTitle_WClass[WindowTitle] := WindowClass	;key must be unique, value not necessary
			row .= ++HowManyWindows . A_Space . WindowTitle . A_Space . "|" . A_Space . WindowClass . "`n"
		}
	}
	for key, value in a_WTitle_WClass
		OutputDebug, % "key:" . A_Space . key . A_Space . "|" . A_Space . "value:" . value . "`n"
	; MsgBox, % row
	; OutputDebug, % "How many windows:" . A_Space . HowManyWindows . "`n"
	return HowManyWindows
}
; - - - - - - - BLOCK OF FUNCTIONS - END - - - - - - - - - - - 