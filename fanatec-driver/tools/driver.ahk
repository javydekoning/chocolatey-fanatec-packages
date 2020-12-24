#NoEnv
#NoTrayIcon
SendMode Input
DetectHiddenText, off ;toggle search hidden window text
DetectHiddenWindows, off ;toggle detect hidden windows
SetTitleMatchMode, 2 ;contains

winTitle = Windows Security ahk_class #32770

Loop, 3
{
    ; Driver window
    WinWait, %winTitle%, ,300
    WinActivate
    ; Send alt+i
    Send !a
    Sleep, 100
}
ExitApp