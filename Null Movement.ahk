; Null Movement Script for AutoHotkey v2
; This script updates the A and D keys so that only one is held down at a time
; This avoids the situation where game engines treat holding both strafe keys as not moving
; Instead, holding both strafe keys will cause you to move in the direction of the last one that was pressed
; The same logic is applied to the Z and S keys (only one can be held at a time)
; Cheers to https://www.youtube.com/watch?v=Feny5bs2JCg&t=335s for mentioning this
; Changelog:
; 2024-08-10: simpler global usage with single global specifier
; 2024-07-26: Adding MaxThreads 1 and MaxThreadsBuffer 1
; 2024-07-26: Changing to use SendInput instead of Send, removing a couple if statements in key down events
; 2024-07-25: Adding section to allow for end button to close script, leaving commented for the moment
; 2024-07-25: Changed to use scancodes for multi-layout keyboard support
; 2024-07-25: Added requires v2 line

; Scan Code Mappings:
; Z   SC011
; Q   SC01E
; S   SC01F
; D   SC020

#Requires AutoHotkey v2
#SingleInstance force
#MaxThreads 1
#MaxThreadsBuffer 1
Persistent true
ListLines False
KeyHistory 0
ProcessSetPriority "High"
A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 0

global q_held := 0  ; Variable that stores the actual keyboard state of the Q key
global d_held := 0  ; Variable that stores the actual keyboard state of the D key
global q_scrip := 0 ; Variable that stores the state of the Q key output from the script
global d_scrip := 0 ; Variable that stores the state of the D key output from the script

global z_held := 0
global s_held := 0
global q_scrip := 0
global s_scrip := 0

/* Un-comment this section if you want the end button to open a dialog that asks to close the script
ToolTip "Script Enabled",A_ScreenWidth/2,A_ScreenHeight/2
SetTimer () => ToolTip(), -1000

End:: ; <--- this button exits the script
{ 
    Result := MsgBox("Are you sure you want to exit?",, 4)
    if Result = "Yes" 
    {
        ExitApp
    }
}
*/

*$SC01E:: ; *$q:: ; Every time the q key is pressed, * to include occurences with modifiers (shift, control, alt, etc)
{   
    global

    q_held := 1  ; Track the actual state of the A key
    
    if d_scrip
    { 
        d_scrip := 0
        SendInput "{Blind}{SC020 up}" ; Release the D key if it's held down, {Blind} so it includes any key modifiers (shift primarily)
    }
    
    q_scrip := 1
    SendInput "{Blind}{SC01E down}" ; A down key
}

*$SC01E up:: ; *$q up:: ; Every time the a key is released
{    
    global

    q_held := 0
    
    if q_scrip
    {
        q_scrip := 0
        SendInput "{Blind}{SC01E up}"  ; Q up key
    }
        
    if d_held && !d_scrip
    {
        d_scrip := 1
        SendInput "{Blind}{SC020 down}"  ; D down key if it's held
    }
}

*$SC020:: ; *$d::
{    
    global

    d_held := 1
    
    if a_scrip
    {
        a_scrip := 0
        SendInput "{Blind}{SC01E up}"  ; Release the A key if it's held down
    }
    
    d_scrip := 1
    SendInput "{Blind}{SC020 down}"  ; D down key
}

*$SC020 up:: ; *$d up::
{    
    global

    d_held := 0
    
    if d_scrip
    {
        d_scrip := 0
        SendInput "{Blind}{SC020 up}"  ; D up key
    }
    
    if a_held && !a_scrip
    {
        a_scrip := 1
        SendInput "{Blind}{SC01E down}"  ; A down key if it's held
    }
}

*$SC011:: ; *$z::
{    
    global

    z_held := 1

    if s_scrip 
    {
        s_scrip := 0
        SendInput "{Blind}{SC01F up}"
    }

    z_scrip := 1
    SendInput "{Blind}{SC011 down}"
}

*$SC011 up:: ; *$z up::
{    
    global

    z_held := 0

    if z_scrip
    {
        z_scrip := 0
        SendInput "{Blind}{SC011 up}"
    }

    if s_held && !s_scrip 
    {
        s_scrip := 1
        SendInput "{Blind}{SC01F down}"
    }
}

*$SC01F:: ; *$s::
{    
    global

    s_held := 1

    if w_scrip 
    {
        w_scrip := 0
        SendInput "{Blind}{SC011 up}"
    }

    s_scrip := 1
    SendInput "{Blind}{SC01F down}"
}

*$SC01F up:: ; *$s up::
{    
    global

    s_held := 0

    if s_scrip 
    {
        s_scrip := 0
        SendInput "{Blind}{SC01F up}"
    }

    if w_held && !w_scrip 
    {
        w_scrip := 1
        SendInput "{Blind}{SC011 down}"
    }
}
