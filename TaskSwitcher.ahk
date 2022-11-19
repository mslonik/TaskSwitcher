#SingleInstance, 	force		; Only one instance of this script may run at a time!
#NoEnv  						; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  	     				; Enable warnings to assist with detecting common errors.
#Requires, AutoHotkey v1.1.34+ 	; Displays an error and quits if a version requirement is not met.
#KeyHistory, 		100			; For debugging purposes.
#LTrim						; Omits spaces and tabs at the beginning of each line. This is primarily used to allow the continuation section to be indented. Also, this option may be turned on for multiple continuation sections by specifying #LTrim on a line by itself. #LTrim is positional: it affects all continuation sections physically beneath it.
#InstallKeybdHook
#MaxHotkeysPerInterval, 1000
SendMode, Input
SetBatchLines, 	-1
SetWorkingDir, 	% A_ScriptDir
ListLines, 		Off

;reset przez nacisniecie i przytrzymanie obu przyciskow np. przez 5 s.
;po resecie uzytkownik oznaczy unikalne okna i okna zdublowane?

global 	v_CurrWindow 	:= 0
	,	AppVersion	:= "0.9.0"
	,	v_NoClass		:= 0
	,	v_WindowTitle	:= ""
	,	v_WindowClass	:= ""
	,	a_WTitle_WClass	:= {}	;global associative array
	,	v_TotalWindows := F_HowManyWindows()
	,	a_SwitchOrder	:= 	{1: 	"1"
					,	2:	"21"
					,	3:	"22"
					,	4:	"31"
					,	5:	"32"
					,	6:	"4"	;Total Commander
					,	7:	"5"	;Signal
					,	8:	"6" ;KeePass
					,	9:	"7"	;Code
					,	10:	"8"} ;ahk help
	,	key 		:= 0
	,	value 	:= ""
	,	first	:= 0
	,	second	:= 0					
	,	length	:= 0

LWin & LAlt::
	++v_CurrWindow
	key := a_SwitchOrder[v_CurrWindow]
	value := StrLen(a_SwitchOrder[v_CurrWindow])
	if (StrLen(a_SwitchOrder[v_CurrWindow]) = 1)
	{
		Send, % "{LWin Down}" . a_SwitchOrder[v_CurrWindow] . "{LWin Up}"
		return
	}
	length := StrLen(a_SwitchOrder[v_CurrWindow])
	if (length = 2)
	{
		first := SubStr(a_SwitchOrder[v_CurrWindow], 1, 1)
		second := SubStr(a_SwitchOrder[v_CurrWindow], 2, 1)
		OutputDebug, % "first:" . A_Space . first . A_Space . "second:" . A_Space . second . "`n"
		; Loop, % second
		; {
			; if (A_Index = second)
			; {
				; Send, % "{LWin Down}" . first . "{LWin Up}" . "{Enter}"
				Send, % "{LWin Down}" . "{" . first . A_Space . second . "}" . "{LWin Up}{Enter}" 
				; Send, {Enter}
				OutputDebug, % "{LWin Down}" . "{first" . A_Space . second . "}" . "{LWin Up}" . "`n"
				; break
			; }
			; else
			; {
				; Send, % "{LWin Down}" . "{" . first . A_Space . second . "}" . "{LWin Up}"
				; Send, {Enter}
				; OutputDebug, % "else {LWin Down}" . "{" . first . A_Space . second . "}" . "{LWin Up}" . "`n"
			; }
		; }
	}
	WinActivate, 	A
return

LAlt & LWin Up::
	--v_CurrWindow
	if (StrLen(a_SwitchOrder[v_CurrWindow]) = 1)
		Send, % "#" . a_SwitchOrder[v_CurrWindow] . "{Enter}"
	if (StrLen(a_SwitchOrder[v_CurrWindow]) = 2)	
		{
			Loop, % SubStr(a_SwitchOrder[v_CurrWindow], 2, 1)
				Send, % "#" . SubStr(a_SwitchOrder[v_CurrWindow], 1, 1)
			Send, {Enter}
		}
	WinActivate, 	A
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
	; for key, value in a_WTitle_WClass
		; OutputDebug, % "key:" . A_Space . key . A_Space . "|" . A_Space . "value:" . value . "`n"
	; MsgBox, % row
	; OutputDebug, % "How many windows:" . A_Space . HowManyWindows . "`n"
	return HowManyWindows
}
; - - - - - - - BLOCK OF FUNCTIONS - END - - - - - - - - - - - 