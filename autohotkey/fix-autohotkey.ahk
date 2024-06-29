#Requires AutoHotkey v2.0+

holdup_key() {
	keys := ["Alt", "LAlt", "RAlt", "Ctrl", "LCtrl", "RCtrl", "Shift", "LShift", "RShift", "LWin", "RWin", "F13", "F14", "LButton", "RButton", "MButton"]
	for key in keys {
		SendInput(Format("{ {1} up }", key))
	}
	SendInput("{ESC}")
}

; Fix stuck
holdup_key()
