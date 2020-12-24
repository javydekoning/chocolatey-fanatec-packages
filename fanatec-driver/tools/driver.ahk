#NoEnv
#NoTrayIcon
SendMode Input
DetectHiddenText, off ;toggle search hidden window text
DetectHiddenWindows, off ;toggle detect hidden windows
SetTitleMatchMode, 2 ;contains

winTitle = Windows Security ahk_class #32770

; Driver install windows
Loop, 5 {
    WinWait, %winTitle%, ,300
    WinActivate
    ControlClick, &Install, %winTitle%

    Sleep, 100
}
ExitApp