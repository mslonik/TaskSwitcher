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
	,	AppVersion	:= "0.9.1"
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
	,	v_TotalWindows := SubStr(a_SwitchOrder[a_SwitchOrder.Count()], 1, 1)

; end of initialization
LWin & LAlt::
	++v_CurrWindow
	if (v_CurrWindow > v_TotalWindows) or (v_CurrWindow > 9)
		v_CurrWindow := 1	
	SelectWindow(v_CurrWindow)
return

LAlt & LWin Up::
	--v_CurrWindow
	if (v_CurrWindow > v_TotalWindows) or (v_CurrWindow < 1)
		v_CurrWindow := v_TotalWindows
	SelectWindow(v_CurrWindow)
return

; - - - - - - - BLOCK OF FUNCTIONS - BEGINNING - - - - - - - - 
SelectWindow(CurrentWindow)
{
	global	;global-mode of operation
	local	key 		:= a_SwitchOrder[CurrentWindow]
		,	length 	:= StrLen(a_SwitchOrder[CurrentWindow])
		,	first 	:= SubStr(key, 1, 1)
		,	second 	:= SubStr(key, 0)

	if (length = 1)
	{
		Send, % "{LWin Down}" . key . "{LWin Up}"
	}
	if (length = 2)
	{
		OutputDebug, % "first:" . A_Space . first . A_Space . "second:" . A_Space . second . "`n"
		Send, % "{LWin Down}" . "{" . first . A_Space . second . "}" 
		Sleep, 300	;yes, it is necessary
		Send, {LWin Up}
		OutputDebug, % "{LWin Down}" . "{first" . A_Space . second . "}" . "{LWin Up}" . "`n"
	}
	WinActivate, 	A
}
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
; - - - - - - - BLOCK OF FUNCTIONS - END - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 