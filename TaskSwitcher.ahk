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

global 	v_TotalWindows := F_HowManyWindows()
	,	v_CurrWindow 	:= 0
	,	AppVersion	:= "0.9.0"

LWin & LAlt::
	++v_CurrWindow
	if (v_CurrWindow > v_TotalWindows) or (v_CurrWindow > 9)
		v_CurrWindow := 1
	Send, % "#" . v_CurrWindow
	OutputDebug, % "up:" . A_Space . v_CurrWindow . "`n"
	; MsgBox Prawo
return

LAlt & LWin Up::
	--v_CurrWindow
	if (v_CurrWindow > v_TotalWindows) or (v_CurrWindow < 1)
		v_CurrWindow := v_TotalWindows
	Send, % "#" . v_CurrWindow
	OutputDebug, % "down:" . A_Space . v_CurrWindow . "`n"
	; MSgbox Lewo
return

; - - - - - - - BLOCK OF FUNCTIONS - BEGINNING - - - - - - - - 
F_HowManyWindows()
{
	local NoWindows := 0
		, id := ""
		, row := ""
		, WindowTitle := ""
		, HowManyWindows := 0

	WinGet, NoWindows, List
	Loop, % NoWindows
	{
		id := NoWindows%A_Index%
		WinGetTitle, WindowTitle, ahk_id %id%
		if (WindowTitle) and (WindowTitle != "Program Manager")
			row .= ++HowManyWindows . A_Space . WindowTitle . "`n"
	}
	; MsgBox, % row
	OutputDebug, % "How many windows:" . A_Space . HowManyWindows . "`n"
	return HowManyWindows
}
; - - - - - - - BLOCK OF FUNCTIONS - END - - - - - - - - - - - 