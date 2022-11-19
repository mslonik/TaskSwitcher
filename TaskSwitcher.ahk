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

global Position := 1

LWin & LAlt::
	Send, % "#" . ++Position
	OutputDebug, % Position
	; MsgBox Prawo
return

LAlt & LWin Up::
	Send, % "#" . --Position
	OutputDebug, % Position
	; MSgbox Lewo
return