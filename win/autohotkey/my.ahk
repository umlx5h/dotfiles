------------------------------------------- Global -----------------------------------------------------
#InstallKeybdHook
#UseHook

SetKeyDelay 0

; Fix stuck?
Send, {Alt Up}{LAlt Up}{RAlt Up}{Ctrl Up}{LCtrl Up}{RCtrl Up}{Shift Up}{LShift Up}{RShift Up}{LWin Up}{RWin Up}{LButton Up}{RButton Up}{MButton Up}
Send, {ESC}

-------------------------------------------  Original  ------------------------------------------------

/*
  Dygma Raise用 Vim用のctrlをF13に割り当てる設定
*/
#IfWinActive, ahk_exe Code.exe
*F13::Send {LShift Down}{RCtrl Down}{Alt Down}
*F13 Up::Send {LShift Up}{RCtrl Up}{Alt Up}
#IfWinActive

#IfWinNotActive, ahk_exe Code.exe
*F13::RCtrl
#IfWinNotActive

/*
  PDIC用
*/
; copy word after opening popup
/*
Alt & RButton::
NumLock::
     Send, !{RButton}
     Sleep, 60
     IfWinActive, ahk_class TPopupWindow.UnicodeClass
     {
         Send, ^{w 3}
     }
return
*/


; Pdicのポップアップ画面での操作を定義
#IfWinActive, ahk_class TPopupWindow.UnicodeClass
;   ^c::^w
    ^c::Send ^{w 1}
    
    !Left::Send {Space}
    !Right::Send +{Space}
    !NumpadLeft::Send {Space}
    !NumpadRight::Send +{Space}
    MButton::Tab
#IfWinActive


/*
  左手トラックボール用
*/
NumLock::Send !{RButton}
; これなに？
^NumLock::Send !^{RButton}

/*
DevDocs
*/
/* ; not working?
+^Space::
	IfWinExist, DevDocs ahk_class Chrome_WidgetWin_1 ahk_exe msedge.exe
		IfWinActive
			WinMinimize
		else
			WinActivate
	else
		Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe"  --profile-directory=Default --app-id=ahiigpfcghkbjfcibpojancebdfjmoop --app-url=https://devdocs.io/ --app-run-on-os-login-mode=windowed --app-launch-source=19
*/

/*
Task bar hide
*/
^LWin:: ;Ctrl + left Win key
If WinExist("ahk_class Shell_TrayWnd")
{
	WinHide, ahk_class Shell_TrayWnd
	WinHide, ahk_class Shell_SecondaryTrayWnd
}
Else
{
	WinShow, ahk_class Shell_TrayWnd
	WinShow, ahk_class Shell_SecondaryTrayWnd
}



-------------------------------------------  Emacs keybinding  ------------------------------------------------

/*
Emacs keybind
@from https://mag.nioufuku.net/2020/04/26/programming/00043-autohotkey/
*/
;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;
;#InstallKeybdHook
;#UseHook

; The following line is a contribution of NTEmacs wiki http://www49.atwiki.jp/ntemacs/pages/20.html
;SetKeyDelay 0

; Applications you want to disable emacs-like keybindings
; (Please comment out applications you don't use)
is_target()
{
  IfWinActive,ahk_exe WindowsTerminal.exe ; Windows Terminal
    Return 1
  IfWinActive,ahk_exe WezTerm.exe ; WezTerm
    Return 1
  IfWinActive,ahk_exe wezterm-gui.exe ; WezTerm
    Return 1
  IfWinActive,ahk_exe alacritty.exe ; WezTerm
    Return 1
  IfWinActive,ahk_class VMwareUnityHostWndClass
    Return 1
  Return 0
}

keep_shift()
{
  IF GetKeyState("Shift")
    Return 1
  Return 0
}

key_del()
{
  If is_target()
    Send {Blind}^d
  Else
    Send {Blind}{Del}
  Return
}
key_backspace()
{
  If is_target()
    Send {Blind}^h
  Else
    Send {Blind}{BS}
  Return
}
kill_home()
{
  If is_target()
    Send {Blind}^u
  Else {
    Send {ShiftDown}{Home}{ShiftUp}
    Sleep 10
    Send ^x
  }
  Return
}
kill_line()
{
  If is_target()
    Send {Blind}^k
  Else {
    Send {ShiftDown}{END}{ShiftUp}
    Sleep 10
    Send ^x
  }
  Return
}
quit()
{
  If is_target()
    Send {Blind}^g
  Else
    Send {Blind}{ESC}
  Return
}
key_home()
{
  If is_target()
    Send {Blind}^a
  Else
    Send {Blind}{HOME}
  Return
}
key_end()
{
  If is_target()
    Send {Blind}^e
  Else
    Send {Blind}{END}
  Return
}
key_up()
{
  If is_target()
    Send {Blind}^p
  Else
    Send {Blind}{Up}
  Return
}
key_down()
{
  If is_target()
    Send {Blind}^n
  Else
    Send {Blind}{Down}
  Return
}
key_right()
{
  If is_target()
    Send {Blind}^f
  Else
    Send {Blind}{Right}
  Return
}
key_left()
{
  If is_target()
    Send {Blind}^b
  Else
    Send {Blind}{Left}
  Return
}
modified_backspace()
{
  If keep_shift()
    backspace_line()
  Else
    backspace_word()
  Return
}
backspace_line()
{
  Send {End}{ShiftDown}{Home}{Home}{ShiftUp}
  Sleep 10
  Send {BS}{BS}
  Return
}
backspace_word()
{
  Send {ShiftDown}{CtrlDown}{Left}{CtrlUp}{ShiftUp}
  Sleep 10
  Send {BS}
  Return
}
modified_delete()
{
  If keep_shift()
    delete_line()
  Else
    delete_word()
}
delete_line()
{
  Send {Home}{Home}{ShiftDown}{End}{ShiftUp}
  Sleep 10
  Send {Del}{Del}
  Return
}
delete_word()
{
  Send {ShiftDown}{CtrlDown}{Right}{CtrlUp}{ShiftUp}
  Sleep 10
  Send {Del}
  Return
}
; Capslock to F14 to Ctrl & Emacs cursor
F14 & Enter::Send {Blind}^{Enter}
F14 & Space::Send {Blind}^{Space}
;F14 & Tab::Send {Blind}^{Tab}

; F14 + Tab -> Ctrl + Tab (work for Firefox)
; https://stackoverflow.com/a/66664204
SendMode Input
#MaxThreads 255
#MaxThreadsPerHotkey 255
F14 & Tab::
  Send {Blind}{LCtrl down}{Tab} ; blindをつけるとshiftで逆もできるようになる
  Keywait F14
  Send {LCtrl up}
  return
#MaxThreadsPerHotkey

F14 & BS::modified_backspace()
F14 & Del::modified_delete()
F14 & Ins::Send {Blind}^{Ins}
F14 & Up::Send {Blind}^{Up}
F14 & Down::Send {Blind}^{Down}
F14 & Left::Send {Blind}^{Left}
F14 & Right::Send {Blind}^{Right}
F14 & Home::Send {Blind}^{Home}
F14 & End::Send {Blind}^{End}
F14 & PgUp::Send {Blind}^{PgUp}
F14 & PgDn::Send {Blind}^{PgDn}
F14 & AppsKey::Send {Blind}^{AppsKey}
F14 & PrintScreen::Send {Blind}^{PrintScreen}
F14 & CtrlBreak::Send {Blind}^{CtrlBreak}
F14 & Pause::Send {Blind}^{Pause}
;F14 & Esc::Send {Blind}^{Esc}  ; disable for tilde
F14 & F1::Send {Blind}^F1
F14 & F2::Send {Blind}^F2
F14 & F3::Send {Blind}^F3
F14 & F4::Send {Blind}^F4
F14 & F5::Send {Blind}^F5
F14 & F6::Send {Blind}^F6
F14 & F7::Send {Blind}^F7
F14 & F8::Send {Blind}^F8
F14 & F9::Send {Blind}^F9
F14 & F10::Send {Blind}^F10
F14 & F11::Send {Blind}^F11
F14 & F12::Send {Blind}^F12
F14 & sc029::Send {Blind}^{sc029} ; `
F14 & 1::Send {Blind}^1
F14 & 2::Send {Blind}^2
F14 & 3::Send {Blind}^3
F14 & 4::Send {Blind}^4
F14 & 5::Send {Blind}^5
F14 & 6::Send {Blind}^6
F14 & 7::Send {Blind}^7
F14 & 8::Send {Blind}^8
F14 & 9::Send {Blind}^9
F14 & 0::Send {Blind}^0
F14 & -::Send {Blind}^-
F14 & =::Send {Blind}^=
F14 & q::Send {Blind}^q
F14 & w::Send {Blind}^w
F14 & e::key_end()
F14 & r::Send {Blind}^r
F14 & t::Send {Blind}^t
F14 & y::Send {Blind}^y
F14 & u::kill_home()
F14 & i::Send {Blind}^i
F14 & o::Send {Blind}^o
F14 & p::key_up()
F14 & {::Send {Blind}^{[}
F14 & }::Send {Blind}^{]}
F14 & \::Send {Blind}^{\}
F14 & a::key_home()
F14 & s::Send {Blind}^s
F14 & d::key_del()
F14 & f::key_right()
F14 & g::quit()
F14 & h::key_backspace()
; F14 & j::Send {Blind}!{sc029} ; IME toggle
F14 & j::Send {Blind}^j
F14 & k::kill_line()
F14 & l::Send {Blind}^l
F14 & sc027::Send {Blind}^{sc027}
F14 & '::Send {Blind}^'
F14 & z::Send {Blind}^z
F14 & x::Send {Blind}^x
F14 & c::Send {Blind}^c
F14 & v::Send {Blind}^v
F14 & b::key_left()
F14 & n::key_down()
F14 & m::Send {Blind}{Enter}
F14 & ,::Send {Blind}^,
F14 & .::Send {Blind}^.
F14 & /::Send {Blind}^/

F14 & LButton::Send {Blind}^{LButton}
F14 & RButton::Send {Blind}^{RButton}
F14 & MButton::Send {Blind}^{MButton}
F14 & WheelDown::Send {Blind}^{WheelDown}
F14 & WheelUp::Send {Blind}^{WheelUp}
F14 & WheelLeft::Send {Blind}^{WheelLeft}
F14 & WheelRight::Send {Blind}^{WheelRight}
; /Capslock to F14 to Ctrl & Emacs move

; Alt+Q to close application like mac
!q::Send,!{F4}
!w::Send,^w
; / for like mac

; チルダを入力可能にする
F14 & Esc::~
F13 & Esc::~


--------------------------------------------- Ctrl IME ----------------------------------------------------------


; 左右 Ctrl キーの空打ちで IME の OFF/ON を切り替える
;
; 左 Ctrl キーの空打ちで IME を「英数」に切り替え
; 右 Ctrl キーの空打ちで IME を「かな」に切り替え
; Ctrl キーを押している間に他のキーを打つと通常の Ctrl キーとして動作
;
; AutoHotkey: v1.1.33.00
; Author:     Miraium  https://github.com/Miraium/ctrl-ime-ahk
; 
; 以下フォーク元
; Author:     karakaram   http://www.karakaram.com/alt-ime-on-off
; Author:     moremorefor  https://github.com/moremorefor/ctrl-ime-ahk

; Razer Synapseなど、キーカスタマイズ系のツールを併用しているときのエラー対策
#MaxHotkeysPerInterval 350

; 主要なキーを HotKey に設定し、何もせずパススルーする
*~a::
*~b::
*~c::
*~d::
*~e::
*~f::
*~g::
*~h::
*~i::
*~j::
*~k::
*~l::
*~m::
*~n::
*~o::
*~p::
*~q::
*~r::
*~s::
*~t::
*~u::
*~v::
*~w::
*~x::
*~y::
*~z::
*~1::
*~2::
*~3::
*~4::
*~5::
*~6::
*~7::
*~8::
*~9::
*~0::
*~F1::
*~F2::
*~F3::
*~F4::
*~F5::
*~F6::
*~F7::
*~F8::
*~F9::
*~F10::
*~F11::
*~F12::
*~`::
*~~::
*~!::
*~@::
*~#::
*~$::
*~%::
*~^::
*~&::
*~*::
*~(::
*~)::
*~-::
*~_::
*~=::
*~+::
*~[::
*~{::
*~]::
*~}::
*~\::
*~|::
*~;::
*~'::
*~"::
*~,::
*~<::
*~.::
*~>::
*~/::
*~?::
*~Esc::
*~Tab::
*~Space::
*~LAlt::
*~RAlt::
*~Left::
*~Right::
*~Up::
*~Down::
*~Enter::
*~PrintScreen::
*~Delete::
*~Home::
*~End::
*~PgUp::
*~PgDn::
*~LCtrl::
*~RCtrl::
*~Backspace::
    Return

; 左 Ctrl 空打ちで IME を OFF
LCtrl up::
    if (A_PriorHotkey == "*~LCtrl")
    {
        if IME_GetConverting() >= 1 {   ; IME on状態で入力途中（日本語入力途中）に押した場合には、無反応になるように設定
            Return
        }
        IME_SET(0)
    }
    Return

; 右 Ctrl 空打ちで IME を ON
RCtrl up::
    if (A_PriorHotkey == "*~RCtrl")
    {
        IME_SET(1)
    }
    Return
    


/*****************************************************************************
  IME制御用 関数群 (IME.ahk)

    グローバル変数 : なし
    各関数の依存性 : なし(必要関数だけ切出してコピペでも使えます)

    AutoHotkey:     L 1.1.08.01
    Language:       Japanease
    Platform:       NT系
    Author:         eamat.      http://www6.atwiki.jp/eamat/
*****************************************************************************
履歴
    2008.07.11 v1.0.47以降の 関数ライブラリスクリプト対応用にファイル名を変更
    2008.12.10 コメント修正
    2009.07.03 IME_GetConverting() 追加 
               Last Found Windowが有効にならない問題修正、他。
    2009.12.03
      ・IME 状態チェック GUIThreadInfo 利用版 入れ込み
       （IEや秀丸8βでもIME状態が取れるように）
        http://blechmusik.xrea.jp/resources/keyboard_layout/DvorakJ/inc/IME.ahk
      ・Google日本語入力β 向け調整
        入力モード 及び 変換モードは取れないっぽい
        IME_GET/SET() と IME_GetConverting()は有効

    2012.11.10 x64 & Unicode対応
      実行環境を AHK_L U64に (本家およびA32,U32版との互換性は維持したつもり)
      ・LongPtr対策：ポインタサイズをA_PtrSizeで見るようにした

                ;==================================
                ;  GUIThreadInfo 
                ;=================================
                ; 構造体 GUITreadInfo
                ;typedef struct tagGUITHREADINFO {(x86) (x64)
                ;    DWORD   cbSize;                 0    0
                ;    DWORD   flags;                  4    4   ※
                ;    HWND    hwndActive;             8    8
                ;    HWND    hwndFocus;             12    16  ※
                ;    HWND    hwndCapture;           16    24
                ;    HWND    hwndMenuOwner;         20    32
                ;    HWND    hwndMoveSize;          24    40
                ;    HWND    hwndCaret;             28    48
                ;    RECT    rcCaret;               32    56
                ;} GUITHREADINFO, *PGUITHREADINFO;

      ・WinTitleパラメータが実質無意味化していたのを修正
        対象がアクティブウィンドウの時のみ GetGUIThreadInfoを使い
        そうでないときはControlハンドルを使用
        一応バックグラウンドのIME情報も取れるように戻した
        (取得ハンドルをWindowからControlに変えたことでブラウザ以外の大半の
        アプリではバックグラウンドでも正しく値が取れるようになった。
        ※ブラウザ系でもアクティブ窓のみでの使用なら問題ないと思う、たぶん)

*/

;---------------------------------------------------------------------------
;  汎用関数 (多分どのIMEでもいけるはず)

;-----------------------------------------------------------
; IMEの状態の取得
;   WinTitle="A"    対象Window
;   戻り値          1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Int, 0)      ;lParam  : 0
}

;-----------------------------------------------------------
; IMEの状態をセット
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, SetSts) ;lParam  : 0 or 1
}

;===========================================================================
; IME 入力モード (どの IMEでも共通っぽい)
;   DEC  HEX    BIN
;     0 (0x00  0000 0000) かな    半英数
;     3 (0x03  0000 0011)         半ｶﾅ
;     8 (0x08  0000 1000)         全英数
;     9 (0x09  0000 1001)         ひらがな
;    11 (0x0B  0000 1011)         全カタカナ
;    16 (0x10  0001 0000) ローマ字半英数
;    19 (0x13  0001 0011)         半ｶﾅ
;    24 (0x18  0001 1000)         全英数
;    25 (0x19  0001 1001)         ひらがな
;    27 (0x1B  0001 1011)         全カタカナ

;  ※ 地域と言語のオプション - [詳細] - 詳細設定
;     - 詳細なテキストサービスのサポートをプログラムのすべてに拡張する
;    が ONになってると値が取れない模様 
;    (Google日本語入力βはここをONにしないと駄目なので値が取れないっぽい)

;-------------------------------------------------------
; IME 入力モード取得
;   WinTitle="A"    対象Window
;   戻り値          入力モード
;--------------------------------------------------------
IME_GetConvMode(WinTitle="A")   {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }
    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x001   ;wParam  : IMC_GETCONVERSIONMODE
          ,  Int, 0)      ;lParam  : 0
}

;-------------------------------------------------------
; IME 入力モードセット
;   ConvMode        入力モード
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;--------------------------------------------------------
IME_SetConvMode(ConvMode,WinTitle="A")   {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }
    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283      ;Message : WM_IME_CONTROL
          ,  Int, 0x002       ;wParam  : IMC_SETCONVERSIONMODE
          ,  Int, ConvMode)   ;lParam  : CONVERSIONMODE
}

;===========================================================================
; IME 変換モード (ATOKはver.16で調査、バージョンで多少違うかも)

;   MS-IME  0:無変換 / 1:人名/地名                    / 8:一般    /16:話し言葉
;   ATOK系  0:固定   / 1:複合語              / 4:自動 / 8:連文節
;   WXG              / 1:複合語  / 2:無変換  / 4:自動 / 8:連文節
;   SKK系            / 1:ノーマル (他のモードは存在しない？)
;   Googleβ                                          / 8:ノーマル
;------------------------------------------------------------------
; IME 変換モード取得
;   WinTitle="A"    対象Window
;   戻り値 MS-IME  0:無変換 1:人名/地名               8:一般    16:話し言葉
;          ATOK系  0:固定   1:複合語           4:自動 8:連文節
;          WXG4             1:複合語  2:無変換 4:自動 8:連文節
;------------------------------------------------------------------
IME_GetSentenceMode(WinTitle="A")   {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }
    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x003   ;wParam  : IMC_GETSENTENCEMODE
          ,  Int, 0)      ;lParam  : 0
}

;----------------------------------------------------------------
; IME 変換モードセット
;   SentenceMode
;       MS-IME  0:無変換 1:人名/地名               8:一般    16:話し言葉
;       ATOK系  0:固定   1:複合語           4:自動 8:連文節
;       WXG              1:複合語  2:無変換 4:自動 8:連文節
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;-----------------------------------------------------------------
IME_SetSentenceMode(SentenceMode,WinTitle="A")  {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }
    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283          ;Message : WM_IME_CONTROL
          ,  Int, 0x004           ;wParam  : IMC_SETSENTENCEMODE
          ,  Int, SentenceMode)   ;lParam  : SentenceMode
}


;---------------------------------------------------------------------------
;  IMEの種類を選ぶかもしれない関数

;==========================================================================
;  IME 文字入力の状態を返す
;  (パクリ元 : http://sites.google.com/site/agkh6mze/scripts#TOC-IME- )
;    標準対応IME : ATOK系 / MS-IME2002 2007 / WXG / SKKIME
;    その他のIMEは 入力窓/変換窓を追加指定することで対応可能
;
;       WinTitle="A"   対象Window
;       ConvCls=""     入力窓のクラス名 (正規表現表記)
;       CandCls=""     候補窓のクラス名 (正規表現表記)
;       戻り値      1 : 文字入力中 or 変換中
;                   2 : 変換候補窓が出ている
;                   0 : その他の状態
;
;   ※ MS-Office系で 入力窓のクラス名 を正しく取得するにはIMEのシームレス表示を
;      OFFにする必要がある
;      オプション-編集と日本語入力-編集中の文字列を文書に挿入モードで入力する
;      のチェックを外す
;==========================================================================
IME_GetConverting(WinTitle="A",ConvCls="",CandCls="") {

    ;IME毎の 入力窓/候補窓Class一覧 ("|" 区切りで適当に足してけばOK)
    ConvCls .= (ConvCls ? "|" : "")                 ;--- 入力窓 ---
            .  "ATOK\d+CompStr"                     ; ATOK系
            .  "|imejpstcnv\d+"                     ; MS-IME系
            .  "|WXGIMEConv"                        ; WXG
            .  "|SKKIME\d+\.*\d+UCompStr"           ; SKKIME Unicode
            .  "|MSCTFIME Composition"              ; Google日本語入力

    CandCls .= (CandCls ? "|" : "")                 ;--- 候補窓 ---
            .  "ATOK\d+Cand"                        ; ATOK系
            .  "|imejpstCandList\d+|imejpstcand\d+" ; MS-IME 2002(8.1)XP付属
            .  "|mscandui\d+\.candidate"            ; MS Office IME-2007
            .  "|WXGIMECand"                        ; WXG
            .  "|SKKIME\d+\.*\d+UCand"              ; SKKIME Unicode
   CandGCls := "GoogleJapaneseInputCandidateWindow" ;Google日本語入力

    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    WinGet, pid, PID,% "ahk_id " hwnd
    tmm:=A_TitleMatchMode
    SetTitleMatchMode, RegEx
    ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
        :  WinExist("ahk_class " . CandGCls                 ) ? 2
        :  WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
        :  0
    SetTitleMatchMode, %tmm%
    return ret
}
