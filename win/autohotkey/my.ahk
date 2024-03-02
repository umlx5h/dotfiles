#Requires AutoHotkey v2.0+
#UseHook
InstallKeybdHook()

holdup_key() {
	keys := ["Alt", "LAlt", "RAlt", "Ctrl", "LCtrl", "RCtrl", "Shift", "LShift", "RShift", "LWin", "RWin", "F13", "F14", "LButton", "RButton", "MButton"]
	for key in keys {
		SendInput(Format("{ {1} up }", key))
	}
	SendInput("{ESC}")
}

; Fix stuck
holdup_key()

/* ------------------------------- Win stuff ------------------------------- */

/* タスクバーを隠すトグル */
^LWin:: ; Ctrl + left Win key
{
	if WinExist("ahk_class Shell_TrayWnd")
	{
		WinHide("ahk_class Shell_TrayWnd")
		WinHide("ahk_class Shell_SecondaryTrayWnd")
	}
	else
	{
		WinShow("ahk_class Shell_TrayWnd")
		WinShow("ahk_class Shell_SecondaryTrayWnd")
	}
}

/* ------------------------------- Mac like ------------------------------- */

!q:: Send("!{F4}") ; Alt+Q to close application
; !w::Send("^w")
; !h::Send("{LWin down}{Down}{LWin up}")

/* ------------------------------- PDIC ------------------------------- */

/* ポップアップ画面での操作 */
#HotIf WinActive("ahk_class TPopupWindow.UnicodeClass")
{
	;^c::^w
	^c:: Send("^{w 1}") ; word copy
	!Left:: Send("{Space}") ; next definition
	!Right:: Send("+{Space}") ; prev definition
	!NumpadLeft:: Send("{Space}")
	!NumpadRight:: Send("+{Space}")
	MButton::Tab ; bookmark word
}
#HotIf

/* 単語を引いた時に同時に単語をコピーする */
/*
Alt & RButton::
NumLock::
{
	Send("!{RButton}")

	Loop 5
	{
		Sleep(25)
		if WinActive("ahk_class TPopupWindow.UnicodeClass")
		{
			Send("^{w 1}")
			break
		}
	}
}
*/

/* 左手トラックボール */
NumLock:: Send("!{RButton}") ; 右クリック
^NumLock:: Send("!^{RButton}") ; CTRL+右クリックでDokopop

/* ------------------------------- Emacs keybinding  ------------------------------- */

; Applications you want to disable emacs-like keybindings
; (Please comment out applications you don't use)
is_terminal()
{
	if WinActive("ahk_exe WindowsTerminal.exe") ; Windows Terminal
		return 1
	if WinActive("ahk_exe WezTerm.exe") ; WezTerm
		return 1
	if WinActive("ahk_exe wezterm-gui.exe") ; WezTerm
		return 1
	if WinActive("ahk_exe alacritty.exe")
		return 1
	if WinActive("ahk_exe emacs.exe")
		return 1
	if WinActive("ahk_exe gvim.exe")
		return 1
	if WinActive("ahk_exe vmware.exe")
		return 1
	return 0
}

/*
Emacs keybind
@from https://mag.nioufuku.net/2020/04/26/programming/00043-autohotkey/
*/
;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;
; The following line is a contribution of NTEmacs wiki http://www49.atwiki.jp/ntemacs/pages/20.html
;SetKeyDelay 0

keep_shift()
{
	if GetKeyState("Shift")
		return 1
	return 0
}
key_del()
{
	if is_terminal()
		Send("{Blind}^d")
	else
		Send("{Blind}{Del}")
}
key_backspace()
{
	if is_terminal()
		Send("{Blind}^h")
	else
		Send("{Blind}{BS}")
}
kill_home()
{
	if is_terminal()
	{
		Send("{Blind}^u")
	}
	else
	{
		Send("{ShiftDown}{Home}{ShiftUp}")
		Sleep(10)
		;Send ^x      ; with copy
		Send("{Del}") ; without copy
	}
}
kill_line()
{
	if is_terminal()
	{
		Send("{Blind}^k")
	}
	else
	{
		Send("{ShiftDown}{END}{ShiftUp}")
		Sleep(10)
		Send("^x")
	}
}
; quit()
; {
; 	if is_terminal()
; 		Send("{Blind}^g")
; 	else
; 		Send("{Blind}{ESC}")
; }
key_home()
{
	if is_terminal()
		Send("{Blind}^a")
	else
		Send("{Blind}{HOME}")
}
key_end()
{
	if is_terminal()
		Send("{Blind}^e")
	else
		Send("{Blind}{END}")
}
key_up()
{
	if is_terminal()
		Send("{Blind}^p")
	else
		Send("{Blind}{Up}")
}
key_down()
{
	if is_terminal()
		Send("{Blind}^n")
	else
		Send("{Blind}{Down}")
}
key_right()
{
	if is_terminal()
		Send("{Blind}^f")
	else
		Send("{Blind}{Right}")
}
key_left()
{
	if is_terminal()
		Send("{Blind}^b")
	else
		Send("{Blind}{Left}")
}
key_enter()
{
	if is_terminal()
		Send("{Blind}^j")
	else
		Send("{Blind}{Enter}")
}
; modified_backspace()
; {
; 	if is_terminal() {
; 		Send("{Blind}^{BS}")
; 		return
; 	}

; 	if keep_shift()
; 		backspace_line()
; 	else
; 		backspace_word()
; }
; backspace_line()
; {
; 	Send("{End}{ShiftDown}{Home}{Home}{ShiftUp}")
; 	Sleep(10)
; 	Send("{BS}{BS}")
; }
; backspace_word()
; {
; 	Send("{ShiftDown}{CtrlDown}{Left}{CtrlUp}{ShiftUp}")
; 	Sleep(10)
; 	Send("{BS}")
; }
backspace_word()
{
	if is_terminal()
		Send("{Blind}^w")
	else
		Send("^{BS}")
}
; modified_delete()
; {
; 	if is_terminal() {
; 		Send("{Blind}^{Del}")
; 		return
; 	}

; 	if keep_shift()
; 		delete_line()
; 	else
; 		delete_word()
; }
; delete_line()
; {
; 	Send("{Home}{Home}{ShiftDown}{End}{ShiftUp}")
; 	Sleep(10)
; 	Send("{Del}{Del}")
; }
; delete_word()
; {
; 	Send("{ShiftDown}{CtrlDown}{Right}{CtrlUp}{ShiftUp}")
; 	Sleep(10)
; 	Send("{Del}")
; }

; VSCodeではemacs keybindingを無効化し、vimプラグイン用のキーバインドを使うため
; F13-F24 を送る
#HotIf WinActive("ahk_exe Code.exe") or WinActive("ahk_exe Code - Insiders.exe")
{
	F14 & a:: Send("{F13}")
	F14 & b:: Send("{F14}")
	F14 & c:: Send("{F15}")
	F14 & d:: Send("{F16}")
	F14 & e:: Send("{F17}")
	F14 & f:: Send("{F18}")
	F14 & g:: Send("{F19}")
	F14 & h:: Send("{F20}")
	F14 & i:: Send("{F21}")
	F14 & j:: Send("{F22}")
	F14 & k:: Send("{F23}")
	F14 & l:: Send("{F24}")
	F14 & m:: Send("^{F13}")
	F14 & n:: Send("^{F14}")
	F14 & o:: Send("^{F15}")
	F14 & p:: Send("^{F16}")
	F14 & q:: Send("^{F17}")
	F14 & r:: Send("^{F18}")
	F14 & s:: Send("^{F19}")
	F14 & t:: Send("^{F20}")
	F14 & u:: Send("^{F21}")
	F14 & v:: Send("^{F22}")
	F14 & w:: Send("^{F23}")
	F14 & x:: Send("^{F24}")
	F14 & y:: Send("+{F13}")
	F14 & z:: Send("+{F14}")
	F14 & {:: Send("+{F15}")
	F14 & }:: Send("+{F16}")
	F14 & 6:: Send("+{F17}")
}
#HotIf

; VSCode以外はemacs keybindingを使う
; 上のVSCodeで定義しているところだけをHotIfの中で定義する (共通のものは外で定義)
#HotIf !(WinActive("ahk_exe Code.exe") or WinActive("ahk_exe Code - Insiders.exe"))
{

	F14 & a:: key_home()
	F14 & b:: key_left()
	F14 & c:: Send("{Blind}^c")
	F14 & d:: key_del()
	F14 & e:: key_end()
	F14 & f:: key_right()
	; F14 & g::quit()
	F14 & g:: Send("{Blind}^g")
	F14 & h:: key_backspace()
	F14 & i:: Send("{Blind}^i")
	; F14 & j:: Send("{Blind}!{sc029}") ; IME toggle
	F14 & j:: key_enter()
	F14 & k:: kill_line()
	F14 & l:: Send("{Blind}^l")
	; F14 & m:: Send("{Blind}{Enter}")
	F14 & m:: Send("{Blind}^m")
	F14 & n:: key_down()
	F14 & o:: Send("{Blind}^o")
	F14 & p:: key_up()
	F14 & q:: Send("{Blind}^q")
	F14 & r:: Send("{Blind}^r")
	F14 & s:: Send("{Blind}^s")
	F14 & t:: Send("{Blind}^t")
	F14 & u:: kill_home()
	F14 & v:: Send("{Blind}^v")
	F14 & w:: backspace_word()
	F14 & x:: Send("{Blind}^x")
	F14 & y:: Send("{Blind}^y")
	F14 & z:: Send("{Blind}^z")
	F14 & {:: Send("{Blind}^{[}")
	F14 & }:: Send("{Blind}^{]}")
	F14 & 6:: Send("{Blind}^6")
}
#HotIf

; Capslock to F14 to Ctrl
F14 & Enter:: Send("{Blind}^{Enter}")
F14 & Space:: Send("{Blind}^{Space}")

; F14 + Tab -> Ctrl + Tab (work for Firefox)
; ref: https://stackoverflow.com/a/66664204
#MaxThreads 255 ; set globally
#MaxThreadsPerHotkey 255 ; set by hotkey
F14 & Tab::
#MaxThreadsPerHotkey 1 ; go back to default
{
	Send("{Blind}{LCtrl down}{Tab}")
	KeyWait("F14")
	Send("{Blind}{LCtrl up}")
}

F14 & BS:: Send("{Blind}^{BS}")
F14 & Del:: Send("{Blind}^{Del}")
; F14 & BS::modified_backspace()
; F14 & Del::modified_delete()
F14 & Ins:: Send("{Blind}^{Ins}")
F14 & Up:: Send("{Blind}^{Up}")
F14 & Down:: Send("{Blind}^{Down}")
F14 & Left:: Send("{Blind}^{Left}")
F14 & Right:: Send("{Blind}^{Right}")
F14 & Home:: Send("{Blind}^{Home}")
F14 & End:: Send("{Blind}^{End}")
F14 & PgUp:: Send("{Blind}^{PgUp}")
F14 & PgDn:: Send("{Blind}^{PgDn}")
F14 & AppsKey:: Send("{Blind}^{AppsKey}")
F14 & PrintScreen:: Send("{Blind}^{PrintScreen}")
F14 & CtrlBreak:: Send("{Blind}^{CtrlBreak}")
F14 & Pause:: Send("{Blind}^{Pause}")
; F14 & Esc:: Send("{Blind}^{Esc}")
F14 & Esc::~
F14 & F1:: Send("{Blind}^F1")
F14 & F2:: Send("{Blind}^F2")
F14 & F3:: Send("{Blind}^F3")
F14 & F4:: Send("{Blind}^F4")
F14 & F5:: Send("{Blind}^F5")
F14 & F6:: Send("{Blind}^F6")
F14 & F7:: Send("{Blind}^F7")
F14 & F8:: Send("{Blind}^F8")
F14 & F9:: Send("{Blind}^F9")
F14 & F10:: Send("{Blind}^F10")
F14 & F11:: Send("{Blind}^F11")
F14 & F12:: Send("{Blind}^F12")
F14 & 1:: Send("{Blind}^1")
F14 & 2:: Send("{Blind}^2")
F14 & 3:: Send("{Blind}^3")
F14 & 4:: Send("{Blind}^4")
F14 & 5:: Send("{Blind}^5")
; F14 & 6::Send("{Blind}^6") ; vscode vim
F14 & 7:: Send("{Blind}^7")
F14 & 8:: Send("{Blind}^8")
F14 & 9:: Send("{Blind}^9")
F14 & 0:: Send("{Blind}^0")
F14 & -:: Send("{Blind}^-")
F14 & =:: Send("{Blind}^=")
F14 & \:: Send("{Blind}^{\}")
F14 & ':: Send("{Blind}^'")
F14 & ,:: Send("{Blind}^,")
F14 & .:: Send("{Blind}^.")
; F14 & {::Send("{Blind}^{[}") ; vscode vim
; F14 & }::Send("{Blind}^{]}") ; vscode vim
F14 & /:: Send("{Blind}^/")
F14 & LButton:: Send("{Blind}^{LButton}")
F14 & RButton:: Send("{Blind}^{RButton}")
F14 & MButton:: Send("{Blind}^{MButton}")
F14 & WheelDown:: Send("{Blind}^{WheelDown}")
F14 & WheelUp:: Send("{Blind}^{WheelUp}")
F14 & WheelLeft:: Send("{Blind}^{WheelLeft}")
F14 & WheelRight:: Send("{Blind}^{WheelRight}")

/* ------------------------------- Terminal  ------------------------------- */

#HotIf is_terminal()
{
	; ターミナルでF14とCTRLを区別するための設定
	^v:: Send("^+v") ; CTRL+SHIFT+V paste from clipboard
	^c:: Send("^+c") ; CTRL+SHIFT+C copy to clipboard
}
#HotIf

; 複数行のテキストを1行にしてコピー 改行文字を\nに変換 Vimで複数行検索する時に便利
#v::
{
	ClipSaved := ClipboardAll() ; Save the entire clipboard to a variable.
	A_Clipboard := A_Clipboard ; Converts any copied files, HTML, or other formatted text to plain text.
	A_Clipboard := StrReplace(StrReplace(A_Clipboard, "`r`n", "\n"), "`n", "\n")  ; 改行文字を\nに変換
	if is_terminal()
		Send("^+v")
	else
		Send("^v")
	Sleep(50)                 ; Don't change clipboard while it is pasted! (Sleep > 0)
	A_Clipboard := ClipSaved  ; Restore the original clipboard. Note the use of A_Clipboard (not ClipboardAll).
	ClipSaved := ""           ; Free the memory in case the clipboard was very large.
}

/* ------------------------------- IME switch  ------------------------------- */

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

; #Include IMEv2.ahk/IMEv2.ahk
; copy from https://github.com/k-ayaki/IMEv2.ahk/blob/master/IMEv2.ahk

;-----------------------------------------------------------
; IMEの状態をセット
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle := "A") {
	hwnd := WinExist(WinTitle)
	if (WinActive(WinTitle)) {
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
		cbSize := 4 + 4 + (PtrSize * 6) + 16
		stGTI := Buffer(cbSize, 0)
		NumPut("Uint", cbSize, stGTI.Ptr, 0)   ;   DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Uint", stGTI.Ptr)
			? NumGet(stGTI.Ptr, 8 + PtrSize, "Uint") : hwnd
	}
	return DllCall("SendMessage"
		, "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hwnd)
		, "UInt", 0x0283  ;Message : WM_IME_CONTROL
		, "Int", 0x006   ;wParam  : IMC_SETOPENSTATUS
		, "Int", SetSts) ;lParam  : 0 or 1
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
IME_GetConverting(WinTitle := "A", ConvCls := "", CandCls := "") {

	;IME毎の 入力窓/候補窓Class一覧 ("|" 区切りで適当に足してけばOK)
	ConvCls .= (ConvCls ? "|" : "")                 ;--- 入力窓 ---
		. "ATOK\d+CompStr"                     ; ATOK系
		. "|imejpstcnv\d+"                     ; MS-IME系
		. "|WXGIMEConv"                        ; WXG
		. "|SKKIME\d+\.*\d+UCompStr"           ; SKKIME Unicode
		. "|MSCTFIME Composition"              ; SKKIME for Windows Vista, Google日本語入力

	CandCls .= (CandCls ? "|" : "")                 ;--- 候補窓 ---
		. "ATOK\d+Cand"                        ; ATOK系
		. "|imejpstCandList\d+|imejpstcand\d+" ; MS-IME 2002(8.1)XP付属
		. "|mscandui\d+\.candidate"            ; MS Office IME-200
		. "|WXGIMECand"                        ; WXG
		. "|SKKIME\d+\.*\d+UCand"              ; SKKIME Unicode

	CandGCls := "GoogleJapaneseInputCandidateWindow" ;Google日本語入力

	hwnd := WinExist(WinTitle)
	if (WinActive(WinTitle)) {
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
		cbSize := 4 + 4 + (PtrSize * 6) + 16
		stGTI := Buffer(cbSize, 0)
		NumPut("Uint", cbSize, stGTI.Ptr, 0)   ;   DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Ptr", stGTI.Ptr)
			? NumGet(stGTI.Ptr, 8 + PtrSize, "UInt") : hwnd
	}
	ret := 0
	pid := 0
	if (hwnd) {
		pid := WinGetPID("ahk_id " . hwnd)	;WinGet, pid, PID,% "ahk_id " hwnd
	}
	tmm := A_TitleMatchMode
	SetTitleMatchMode "RegEx"
	ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
		: WinExist("ahk_class " . CandGCls) ? 2
			: WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
			: 0
	;; 推測変換(atok)や予想入力(msime)中は候補窓が出ていないものとして取り扱う
	if (2 == ret) {
		if (WinExist("ahk_class " . CandCls . " ahk_pid " pid))
		{
			;; atok だと仮定して再度ウィンドウを検出する
			WinGetPos(&X, &Y, &Width, &Height, "ahk_class " . CandCls . " ahk_pid " pid)
		} else
			if (WinExist("ahk_class " . CandGCls))
			{
				;; Google IME だと仮定して再度ウィンドウを検出する
				WinGetPos(&X, &Y, &Width, &Height, "ahk_class " . CandGCls)
			}
		X1 := X
		Y1 := Y
		X2 := X + Width
		Y2 := Y + Height

		CoordMode "Pixel", "Screen"
		;; ATOK については 推測変換中か否かを確実に検出できる
		;; MS-IME は変換候補窓の表示中のみを検出できる
		;; Google IME も変換候補窓の表示中のみを検出できる
		;; そこで変換候補窓が表示されていないと仮定して処理を進めてみる
		ret := 1
		not_auto_cand_list := [0xFFE1C4  ; ATOK
			, 0xF6E8CB  ; MS-IME
			, 0xFFEAD1] ; Google IME
		for index, ColorID in not_auto_cand_list {
			elevel := PixelSearch(&OutputVarX, &OutputVarY, X1, Y1, X2, Y2, ColorID)
			;;  the color was not found
			if (0 == elevel) {
				ret := 2
				break
			}
		}
		CoordMode "Pixel", "Window"
	}
	SetTitleMatchMode tmm
	return ret
}


; 主要なキーを HotKey に設定し、何もせずパススルーする
; CTRL+Xを実行した時にIME切り替えが発火しないようにするために必要
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
{
	return
}

; 左 Ctrl 空打ちで IME を OFF
LCtrl up::
{
	if (A_PriorHotkey == "*~LCtrl")
	{
		; IME on状態で入力途中（日本語入力途中）に押した場合には、無反応になるように設定
		if IME_GetConverting() >= 1
		{
			return
		}
		IME_SET(0)
	}
}

; 右 Ctrl 空打ちで IME を ON
RCtrl up::
{
	if (A_PriorHotkey == "*~RCtrl")
	{
		IME_SET(1)
	}
}
